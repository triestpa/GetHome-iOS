//
//  FirstViewController.swift
//  GetHome
//
//  Created by Patrick on 12/2/14.
//  Copyright (c) 2014 Patrick Triest. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var myRoute : MKRoute?
    
    let locationHelper = LocationHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationHelper.startLocationUpdate()
        
        mapView.delegate = self
        mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        
        getDirections(locationHelper.lastLocation!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDirections(userLocation: CLLocation) {
        var point1 = MKPointAnnotation()
        var point2 = MKPointAnnotation()
        
            point1.coordinate = userLocation.coordinate
            point1.title = "You"
            mapView.addAnnotation(point1)
            
            point2.coordinate = CLLocationCoordinate2DMake(24.9511, 121.2358)
            point2.title = "Chungli"
            point2.subtitle = "Taiwan"
            mapView.addAnnotation(point2)
            mapView.centerCoordinate = point2.coordinate
            mapView.delegate = self
            
            //Span of the map
            mapView.setRegion(MKCoordinateRegionMake(point2.coordinate, MKCoordinateSpanMake(0.7,0.7)), animated: true)
            
            var directionsRequest = MKDirectionsRequest()
            let markYou = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point1.coordinate.latitude, point1.coordinate.longitude), addressDictionary: nil)
            let markHome = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point2.coordinate.latitude, point2.coordinate.longitude), addressDictionary: nil)
            
            directionsRequest.setSource(MKMapItem(placemark: markYou))
            directionsRequest.setDestination(MKMapItem(placemark: markHome))
            directionsRequest.transportType = MKDirectionsTransportType.Automobile
            var directions = MKDirections(request: directionsRequest)
            directions.calculateDirectionsWithCompletionHandler { (response:MKDirectionsResponse!, error: NSError!) -> Void in
                if error == nil {
                    self.myRoute = response.routes[0] as? MKRoute
                    self.mapView.addOverlay(self.myRoute?.polyline)
                }
            }
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        var myLineRenderer = MKPolylineRenderer(polyline: myRoute?.polyline!)
        myLineRenderer.strokeColor = UIColor.redColor()
        myLineRenderer.lineWidth = 3
        return myLineRenderer
    }
    
    
    
}

