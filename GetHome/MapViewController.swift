//
//  FirstViewController.swift
//  GetHome
//
//  Created by Patrick on 12/2/14.
//  Copyright (c) 2014 Patrick Triest. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, DirectionsDelegate, EAIntroDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBAction func refreshButtonTouch(sender: AnyObject) {
        showOptions()
    }
    
    var myRoute : MKRoute?
    var directionManager: DirectionsManager?
    var plistDict: NSMutableDictionary?
    var homePoint: CLLocationCoordinate2D?
    var homeAddress: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        
        
        var myDict: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("AddressInfo", ofType: "plist") {
            plistDict = NSMutableDictionary(contentsOfFile: path)
            println(plistDict!)
            if (plistDict!["Address"] as String == "none"){
                showIntroPage()
            }
            else {
                homePoint = CLLocationCoordinate2D(latitude: plistDict!["Latitude"] as Double, longitude: plistDict!["Longitude"] as Double)
                println(homePoint)
                homeAddress = plistDict!["Address"] as? String
                self.directionManager = DirectionsManager(directions: self, homeLocation: homePoint!)
            }
        }
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
    
    func showUberMessage(uberMessage: String, pickupLocation: CLLocationCoordinate2D, dropOffLocation: CLLocationCoordinate2D) {
        //Show Error Dialog
        var alert = UIAlertController(title: "Uber", message: uberMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { action in
            return
        })
        alert.addAction(cancelAction)
        
        var okAction = UIAlertAction(title: "Open Uber", style: UIAlertActionStyle.Default, handler: { action in
            // The only required property - pickupLocation
            var pickupLocation = CLLocationCoordinate2D(latitude: pickupLocation.latitude, longitude: pickupLocation.longitude)
            var uber = UberHelper(pickupLocation: pickupLocation)
            uber.dropoffLocation = CLLocationCoordinate2D(latitude: pickupLocation.latitude, longitude: pickupLocation.longitude)
            uber.deepLink()
            return
        })
        alert.addAction(okAction)

        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func showOptions() {
        var optionsController = UIAlertController(title: "How Do You Want to Travel?",
            message: nil, preferredStyle: .Alert)
        
        var walkAction = UIAlertAction(title: "Walking", style: UIAlertActionStyle.Default, handler: { action in
            self.directionManager?.getDirections(MKDirectionsTransportType.Walking)
            return
            })
        optionsController.addAction(walkAction)
        
        var driveAction = UIAlertAction(title: "Driving", style: UIAlertActionStyle.Default, handler: { action in
            self.directionManager?.getDirections(MKDirectionsTransportType.Automobile)
            return
            })
        optionsController.addAction(driveAction)
        
        var uberAction = UIAlertAction(title: "Uber", style: UIAlertActionStyle.Default, handler: { action in
            self.directionManager?.findUber()
            return})
        optionsController.addAction(uberAction)
        
        var resetAddress = UIAlertAction(title: "Reset Home Address", style: UIAlertActionStyle.Default, handler: { action in
            self.getUserAddress()
            return})
        optionsController.addAction(resetAddress)
        
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { action in
            return})
        optionsController.addAction(cancelAction)
        
        self.presentViewController(optionsController, animated: true, completion: nil)
    }
    
    func showProgress() {
        MRProgressOverlayView.showOverlayAddedTo(self.view, animated: true)
    }
    
    func hideProgress() {
        MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
    }
    
    func showIntroPage() {
        var introPage1 = EAIntroPage()
        introPage1.title = "Welcome!"
        introPage1.desc = "Ever wish there was an easier way to find your way home from anywhere?"
        introPage1.titlePositionY = 500
        introPage1.descPositionY = 450

        introPage1.bgImage = UIImage(named: "nightcity")
        
        var introPage2 = EAIntroPage()
        introPage2.title = "We've got good news!"
        introPage2.desc = "Get Home will help you find your way home from anywhere, all you need to do is open the app and we'll do the rest."
        introPage2.titlePositionY = 500
        introPage2.descPositionY = 450
        introPage2.bgImage = UIImage(named: "budapest")
        
        var introPage3 = EAIntroPage()
        introPage3.title = "There's Even More!"
        introPage3.desc = "We'll give you the option between driving or walking home, and you can even order an Uber home directly from the app. Give it a whirl!"
        introPage3.bgImage = UIImage(named: "citystreet")
        
        var intro = EAIntroView(frame: self.view.bounds, andPages: [introPage1, introPage2, introPage3])
        intro.delegate = self
        intro.useMotionEffects = true
        intro.showInView(self.view, animateDuration: 0.0)
    }
    
    func introDidFinish(introView: EAIntroView!) {
        getUserAddress()
    }
    
    func getUserAddress() {
        var alert = UIAlertController(title: "Set your Home Address", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler(nil)
        let locationTextField = alert.textFields?.last as UITextField
        
        if (homeAddress == nil) {
            locationTextField.placeholder = "Enter Home Address"
        }
        else {
            locationTextField.placeholder = homeAddress
        }
        alert.addAction(UIAlertAction(title: "Set", style: UIAlertActionStyle.Default, handler: { action in
            let homeAddress = locationTextField.text
            self.geocodeAddress(homeAddress)
            }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func geocodeAddress(address: String) {
        let addressLookup: CLGeocoder = CLGeocoder()
        addressLookup.geocodeAddressString(address, completionHandler: {(placemarks, error)->Void in
            if (error == nil) {
                let firstCoordinate: CLPlacemark = placemarks[0] as CLPlacemark
                let homeCoordinate: CLLocationCoordinate2D = firstCoordinate.location.coordinate
                println("Lat: " + "\(homeCoordinate.latitude)" + "\nLong: " + "\(homeCoordinate.longitude)")
                self.plistDict!["Address"] = address
                self.plistDict!["Latitude"] = Double(homeCoordinate.latitude)
                self.plistDict!["Longitude"] = Double(homeCoordinate.longitude)
                if let path = NSBundle.mainBundle().pathForResource("AddressInfo", ofType: "plist") {
                    self.plistDict?.writeToFile(path, atomically: true)
                    println(self.plistDict?)
                    
                    self.directionManager = DirectionsManager(directions: self, homeLocation: homeCoordinate)
                }
            }
            else {
                self.showError("Address Not Found")
            }
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "chooseLocationController" {
         //   let destinationViewController = segue.destinationViewController // as chooseLocationController
        }
        else if segue.identifier == "showList" {
            let navigationController = segue.destinationViewController as UINavigationController
            let destinationViewController = navigationController.topViewController as DirectionsTableViewController
            if (directionManager?.thisRoute != nil) {
                destinationViewController.route = directionManager?.thisRoute?
            }
        }
    }
    
}

