//
//  RootViewController.swift
//  GetHome
//
//  Created by Patrick on 12/3/14.
//  Copyright (c) 2014 Patrick Triest. All rights reserved.
//

import UIKit

class RootViewController: RESideMenu, RESideMenuDelegate {
    
    var directionManager: DirectionsManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func awakeFromNib() {
        
        self.menuPreferredStatusBarStyle = UIStatusBarStyle.LightContent
        self.contentViewShadowColor = UIColor.blackColor();
        self.contentViewShadowOffset = CGSizeMake(0, 0);
        self.contentViewShadowOpacity = 0.8;
        self.contentViewShadowRadius = 12;
        self.contentViewShadowEnabled = true;
        self.parallaxEnabled = true
        
        self.contentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as UIViewController
        self.leftMenuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LeftMenuViewController") as UIViewController
    }
    
    // MARK: RESide Delegate Methods
    
    func sideMenu(sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {
        println("This will show the menu")
    }
}
