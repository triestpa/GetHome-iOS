//
//  LeftMenuViewController.swift
//  RESideSwift
//
//  Created by miguelicious on 11/25/14.
//  Copyright (c) 2014 miguelicious. All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController {

    var directionsManager: DirectionsManager?
    override func viewDidLoad() {
        super.viewDidLoad()
     //   directionsManager = DirectionsManager(directions: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func carDirectionsTouch(sender: AnyObject) {
        directionsManager?.getWalkingDirections()
        
    }

    @IBAction func walkingDirectionsTouch(sender: AnyObject) {
        directionsManager?.getWalkingDirections()
    }
    
    
    @IBAction func homeAddressTouch(sender: AnyObject) {
    }
    
    @IBAction func findUberTouch(sender: AnyObject) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
