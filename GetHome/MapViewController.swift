//
//  FirstViewController.swift
//  GetHome
//
//  Created by Patrick on 12/2/14.
//  Copyright (c) 2014 Patrick Triest. All rights reserved.
//

import UIKit
import MapKit

/* 
Notification closure
or
protocal- data manager delegate

http://codereview.stackexchange.com/questions/55775/is-this-a-correct-use-of-using-protocols-and-delegate-pattern-in-swift
*/

class MapViewController: UIViewController, MKMapViewDelegate, DirectionsDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBAction func refreshButtonTouch(sender: AnyObject) {
        getDirections()
    }
    
    var myRoute : MKRoute?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshButton.layer.cornerRadius = 10;
        refreshButton.clipsToBounds = true;
                
        mapView.delegate = self
        mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDirections() {
        if let currentLocation = locationHelper.lastLocation? {
            
            var point1 = MKPointAnnotation()
            var point2 = MKPointAnnotation()
            
            point1.coordinate = currentLocation.coordinate
            point1.title = "Start"
            mapView.addAnnotation(point1)
            
            point2.coordinate = CLLocationCoordinate2DMake(47.5069, 19.0456)
            point2.title = "Home"
            mapView.addAnnotation(point2)
            mapView.centerCoordinate = point2.coordinate
            mapView.delegate = self
            
            //Span of the map
            mapView.setRegion(MKCoordinateRegionMake(point1.coordinate, MKCoordinateSpanMake(0.03,0.03)), animated: true)
            
            var directionsRequest = MKDirectionsRequest()
            let markYou = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point1.coordinate.latitude, point1.coordinate.longitude), addressDictionary: nil)
            let markHome = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point2.coordinate.latitude, point2.coordinate.longitude), addressDictionary: nil)
            
            directionsRequest.setSource(MKMapItem(placemark: markYou))
            directionsRequest.setDestination(MKMapItem(placemark: markHome))
            directionsRequest.transportType = MKDirectionsTransportType.Walking
            var directions = MKDirections(request: directionsRequest)
            directions.calculateDirectionsWithCompletionHandler { (response:MKDirectionsResponse!, error: NSError!) -> Void in
                if error == nil {
                    self.myRoute = response.routes[0] as? MKRoute
                    self.mapView.addOverlay(self.myRoute?.polyline)
                }
            }
        }
        else {
            println("Last Location Not Found")
        }
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        var myLineRenderer = MKPolylineRenderer(polyline: myRoute?.polyline!)
        myLineRenderer.strokeColor = UIColor.redColor()
        myLineRenderer.lineWidth = 3
        return myLineRenderer
    }
    
    func updateView() {
        //update the map directions
    }
    
}

