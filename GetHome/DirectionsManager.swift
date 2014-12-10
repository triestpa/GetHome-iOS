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
    func showError(route: String)
}

//Initialize this somewhere that it could be initialized with both view controller classes
class DirectionsManager {
    
    var directionsDelegate:DirectionsDelegate // delegate property
    
    var thisRoute: MKRoute?
    let locationHelper = LocationHelper()
    
    init(directions:DirectionsDelegate){
        self.directionsDelegate = directions
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
    
    func getWalkingDirections(thisView: UIView) {
        if let currentLocation = locationHelper.lastLocation? {
            var point1 = MKPointAnnotation()
            var point2 = MKPointAnnotation()
            
            point1.coordinate = currentLocation.coordinate
            point1.title = "Start"
            
            point2.coordinate = CLLocationCoordinate2DMake(47.5069, 19.0456)
            point2.title = "Home"
            var directionsRequest = MKDirectionsRequest()
            let markYou = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point1.coordinate.latitude, point1.coordinate.longitude), addressDictionary: nil)
            let markHome = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point2.coordinate.latitude, point2.coordinate.longitude), addressDictionary: nil)
            
            directionsRequest.setSource(MKMapItem(placemark: markYou))
            directionsRequest.setDestination(MKMapItem(placemark: markHome))
            directionsRequest.transportType = MKDirectionsTransportType.Walking
            var directions = MKDirections(request: directionsRequest)
            
            directions.calculateDirectionsWithCompletionHandler { (response:MKDirectionsResponse!, error: NSError!) -> Void in
                if error == nil {
                    self.thisRoute = response.routes[0] as? MKRoute
                    self.didUpdateDirections()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    MRProgressOverlayView.dismissOverlayForView(thisView, animated: true)
                }
                else {
                  self.directionsDelegate.showError(error.localizedDescription)
                }
            }
            MRProgressOverlayView.showOverlayAddedTo(thisView, animated: true)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        }
    }
}