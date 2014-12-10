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
        showOptions()
    }
    
    var myRoute : MKRoute?
    var directionManager: DirectionsManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        mapView.delegate = self
        mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        
        directionManager = DirectionsManager(directions: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        var myLineRenderer = MKPolylineRenderer(polyline: myRoute?.polyline!)
        myLineRenderer.strokeColor = UIColor.redColor()
        myLineRenderer.lineWidth = 3
        return myLineRenderer
    }
    
    func updateView(route: MKRoute) {
        //center on user
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let currentLocaton: CLLocationCoordinate2D? = directionManager?.locationHelper.lastLocation?.coordinate
        let region = MKCoordinateRegionMake(currentLocaton! , span)
        self.mapView.setRegion(region, animated: true)
        
        //update the map directions
        self.mapView.removeOverlay(self.myRoute?.polyline)
        self.myRoute = route
        self.mapView.addOverlay(self.myRoute?.polyline)
    }
    
    func showError(errorMessage: String) {
        //Show Error Dialog
        var alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        var okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { action in
            return
        })
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showOptions() {
        var optionsController = UIAlertController(title: "How Do You Want to Travel?",
            message: nil, preferredStyle: .Alert)
        
        var walkAction = UIAlertAction(title: "Walking", style: UIAlertActionStyle.Default, handler: { action in
            self.directionManager?.getDirections(self.view, transport: MKDirectionsTransportType.Walking)
            return
            })
        optionsController.addAction(walkAction)
        
        var driveAction = UIAlertAction(title: "Driving", style: UIAlertActionStyle.Default, handler: { action in
            self.directionManager?.getDirections(self.view, transport: MKDirectionsTransportType.Automobile)
            return
            })
        optionsController.addAction(driveAction)
        
        var uberAction = UIAlertAction(title: "Uber", style: UIAlertActionStyle.Default, handler: { action in
            self.directionManager?.findUber()
            return})
        optionsController.addAction(uberAction)
        
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { action in
            return})
        optionsController.addAction(cancelAction)
        
        self.presentViewController(optionsController, animated: true, completion: nil)
    }
}

