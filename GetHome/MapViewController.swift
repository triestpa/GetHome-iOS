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
        directionManager?.getWalkingDirections(self.view)
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
        //update the map directions
        self.myRoute = route
        self.mapView.addOverlay(self.myRoute?.polyline)
    }
    
    func showError(errorMessage: String) {
        //Show Error Dialog
        var alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true, completion: nil)
        var okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { action in
            return
        })
        alert.addAction(okAction)
    }
}

