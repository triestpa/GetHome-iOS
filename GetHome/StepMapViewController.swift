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
        
        mapView.setVisibleMapRect(thisStep!.polyline.boundingMapRect, animated: false)
        
        if (fullRoute != nil) {
            var bluePolyline: CustomPolyline = CustomPolyline(points: fullRoute!.polyline.points(), count: fullRoute!.polyline.pointCount)
            bluePolyline.color = UIColor.blueColor()
            bluePolyline.width = 2
            mapView.addOverlay(bluePolyline)
        }
        
        thisStep?.polyline.points()
        if (thisStep != nil) {
            var redPolyline: CustomPolyline = CustomPolyline(points: thisStep!.polyline.points(), count: thisStep!.polyline.pointCount)
            redPolyline.color = UIColor.redColor()
            redPolyline.width = 4
            mapView.addOverlay(redPolyline)
        }
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: CustomPolyline!) -> MKOverlayRenderer! {
        var myLineRenderer = MKPolylineRenderer(overlay: overlay)
        myLineRenderer.strokeColor = overlay.color!
        myLineRenderer.lineWidth = overlay.width!
        return myLineRenderer
    }

    @IBAction func backButtonPress(sender: AnyObject) {
        self.performSegueWithIdentifier("exitMapSegue", sender: self)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {}
    
}

class CustomPolyline : MKPolyline {
    var color: UIColor?
    var width: CGFloat?

}
