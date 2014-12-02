//
//  LocationHelper.swift
//  GetHome
//
//  Created by Patrick on 12/2/14.
//  Copyright (c) 2014 Patrick Triest. All rights reserved.
//

import UIKit
import CoreLocation

class LocationHelper: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    var lastLocation: CLLocation?
    
    override init() {
        super.init()
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    func startLocationUpdate() {
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdate() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        let newLocation = locations.last! as CLLocation
        if newLocation.horizontalAccuracy >= 0 && newLocation.horizontalAccuracy >= locationManager.desiredAccuracy {
            lastLocation = newLocation
            
            println("latitude: \(newLocation.coordinate.latitude) longitude: \(newLocation.coordinate.longitude)")
            
            stopLocationUpdate()
        }
        else {
            println("Location Accuracy Not Valid: " + "\(newLocation.horizontalAccuracy)")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Failed to get location: " + error.localizedDescription)
        stopLocationUpdate()
    }
}