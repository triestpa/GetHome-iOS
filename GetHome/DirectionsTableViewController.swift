//
//  SecondViewController.swift
//  GetHome
//
//  Created by Patrick on 12/2/14.
//  Copyright (c) 2014 Patrick Triest. All rights reserved.
//

import UIKit
import MapKit

class DirectionsTableViewController: UITableViewController {

    var route: MKRoute?
    var routeSteps = [MKRouteStep]()
    var selectedStep: MKRouteStep?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (route != nil) {
            routeSteps = route?.steps as [MKRouteStep]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backButtonTap(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return routeSteps.count
        }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("DirectionsCell", forIndexPath: indexPath) as UITableViewCell
        
        let thisStep = routeSteps[indexPath.row]
        
        cell.textLabel.text = thisStep.instructions
        cell.detailTextLabel?.text = "\(thisStep.distance / 10)" + " meters"

        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row != 0) {
            selectedStep = routeSteps[indexPath.row]
            self.performSegueWithIdentifier("showStepMap", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showStepMap" {
            let destinationViewController = segue.destinationViewController as StepMapViewController
            destinationViewController.thisStep = selectedStep
            destinationViewController.fullRoute = route

        }
    }
}

