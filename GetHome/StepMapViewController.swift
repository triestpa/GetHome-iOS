//
//  StepMapViewController.swift
//  GetHome
//
//  Created by Patrick on 12/14/14.
//  Copyright (c) 2014 Patrick Triest. All rights reserved.
//

import Foundation
import MapKit

class StepMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var fullRoute: MKRoute?
    var thisStep: MKRouteStep?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        
        thisStep?.polyline.points()
        if (thisStep != nil) {
            mapView.addOverlay(thisStep!.polyline)
        }
        else {
            println("The step is nil")
        }
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        var myLineRenderer = MKPolylineRenderer(polyline: thisStep!.polyline)
        myLineRenderer.strokeColor = UIColor.redColor()
        myLineRenderer.lineWidth = 3
        return myLineRenderer
    }

    @IBAction func backButtonPress(sender: AnyObject) {
        self.performSegueWithIdentifier("exitMapSegue", sender: self)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {}
    
}
