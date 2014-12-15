//
//  DirectionsManager.swift
//  GetHome
//
//  Created by Patrick on 12/4/14.
//  Copyright (c) 2014 Patrick Triest. All rights reserved.
//

import Foundation
import MapKit

protocol DirectionsDelegate {
    func updateView(route: MKRoute)
    func showError(message: String)
    func showUberMessage(message: String, pickupLocation: CLLocationCoordinate2D, dropOffLocation: CLLocationCoordinate2D)
    func showProgress()
    func hideProgress()
}

//Initialize this somewhere that it could be initialized with both view controller classes
class DirectionsManager {
    
    var directionsDelegate:DirectionsDelegate // delegate property
    
    var thisRoute: MKRoute?
    let locationHelper = LocationHelper()
    
    var urlSession: NSURLSession!
    let uberServerKey = "KD1nRWopePlDo1KCi2_OJ8rxvPFG74nvljsc0bW7"
    var uberResponse: NSDictionary!
    
    let homePoint = CLLocationCoordinate2DMake(47.5069, 19.0456)
    
    init(directions:DirectionsDelegate, homeLocation: CLLocationCoordinate2D){
        self.directionsDelegate = directions
        self.homePoint = homeLocation
        locationHelper.startLocationUpdate()
    }

    func didUpdateDirections() {
        if (thisRoute != nil) {
            directionsDelegate.updateView(thisRoute!)
        }
        else {
            self.directionsDelegate.showError("No Route Found")
        }
    }
    
    func getDirections(transport: MKDirectionsTransportType) {

        if let currentLocation = locationHelper.lastLocation? {
            var point1 = MKPointAnnotation()
            var point2 = MKPointAnnotation()
            
            point1.coordinate = currentLocation.coordinate
            point1.title = "Start"
            
            point2.coordinate = homePoint
            point2.title = "Home"
            var directionsRequest = MKDirectionsRequest()
            let markYou = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point1.coordinate.latitude, point1.coordinate.longitude), addressDictionary: nil)
            let markHome = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point2.coordinate.latitude, point2.coordinate.longitude), addressDictionary: nil)
            
            directionsRequest.setSource(MKMapItem(placemark: markYou))
            directionsRequest.setDestination(MKMapItem(placemark: markHome))
            directionsRequest.transportType = transport
            var directions = MKDirections(request: directionsRequest)
            
            directions.calculateDirectionsWithCompletionHandler { (response:MKDirectionsResponse!, error: NSError!) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.directionsDelegate.hideProgress()
                if error == nil {
                    self.thisRoute = response.routes[0] as? MKRoute
                    self.didUpdateDirections()
                }
                else {
                  self.directionsDelegate.showError(error.localizedDescription)
                }
            }
            directionsDelegate.showProgress()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        }
    }
    
    func findUber() {
        let currentLocation = locationHelper.lastLocation?.coordinate
        if (currentLocation != nil) {
            queryUberApi(currentLocation!, home: homePoint)
        }
        else {
            self.directionsDelegate.showError("Could Not Find Current Location")
        }
    }
    
    func queryUberApi(currentLocation: CLLocationCoordinate2D, home: CLLocationCoordinate2D) {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlSession = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        
        var urlString = "https://api.uber.com/v1/estimates/price?server_token=" + uberServerKey
        urlString = urlString + "&start_latitude=" + "\(currentLocation.latitude)" + "&start_longitude=" + "\(currentLocation.longitude)"
        urlString = urlString + "&end_latitude=" + "\(home.latitude)" + "&end_longitude=" + "\(home.longitude)"
        
        println(urlString)
        
        if let url = NSURL(string: urlString as NSString) {
            makeNetworkRequest(url)
        }
        else {
            //Catch NSURL formation error
            directionsDelegate.showError("Invalid URL.")
        }
    }
    
    func makeNetworkRequest(url: NSURL) {
        let dataTask = urlSession.dataTaskWithURL(url, completionHandler: {data, response, error in
            let response = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            // Detect http request error
            if error != nil {
                self.directionsDelegate.showError("Web Request Failed, Please Make Sure The Internet on Your Device is Working")
            }
            else {
                println(response)
                self.parseResult(data)
            }
            //Hide progress indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.directionsDelegate.hideProgress()
        })
        //Show progress indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        directionsDelegate.showProgress()
        dataTask.resume()
    }
    
    func parseResult(data: NSData) {
        // Parse JSON
        if let serverResponse: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary {
            self.uberResponse = serverResponse as NSDictionary
            
            //Check for an error message within the response
            if let errorMessage: NSString = self.uberResponse["message"] as? NSString {
                println(errorMessage)
                directionsDelegate.showError(errorMessage)
            }
            else {
                let pricesArray = uberResponse["prices"] as NSArray
                let priceDataDict = pricesArray[0] as NSDictionary
                let priceEstimate = priceDataDict["estimate"] as String
                var rideDuration = priceDataDict["duration"] as Int
                
                let currentLocation = locationHelper.lastLocation?.coordinate

                rideDuration = rideDuration / 60
                let uberMessage = "\nPrice Estimate: " + "\(priceEstimate)" + "\nRide Duration: " + "\(rideDuration)" + " minutes\n\n Open the Uber App on your phone to order a ride home."
                directionsDelegate.showUberMessage(uberMessage, pickupLocation: currentLocation!, dropOffLocation: homePoint)
            }
        }
        else {
            //Catch parsing error
            print("JSON Parse Error")
            directionsDelegate.showError("JSON Parse Error")
        }
    }

}