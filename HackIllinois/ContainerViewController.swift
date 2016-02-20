//
//  ContainerViewController.swift
//  HackIllinois
//
//  Created by Bryan Keller on 2/19/16.
//  Copyright © 2016 KelHop. All rights reserved.
//

import Cocoa

class ContainerViewController: NSViewController, FocusManagerDelegate {
    
    private let currentSessionViewController = CurrentSessionViewController(nibName: "CurrentSessionViewController", bundle:nil)!
    private let statsViewController = StatsViewController(nibName: "StatsViewController", bundle:nil)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChildViewController(self.currentSessionViewController)
        self.view.addSubview(self.currentSessionViewController.view)
        
        self.addChildViewController(self.statsViewController)
        self.view.addSubview(self.statsViewController.view)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
//        self.focusedAppNameLabel.stringValue = NSWorkspace.sharedWorkspace().frontmostApplication?.bundleIdentifier ?? "<<<error>>>"
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        
        let height = self.view.bounds.size.height - 44
        self.currentSessionViewController.view.frame = CGRect(x: 0, y: 44, width: self.view.bounds.size.width, height: height)
        self.statsViewController.view.frame = CGRect(x: 0, y: 44 - height, width: self.view.bounds.size.width, height: height)
    }
    
    
    // MARK: - Target action
    
    override func scrollWheel(theEvent: NSEvent) {
        if theEvent.scrollingDeltaY > 50 {
            
        }
        else if theEvent.scrollingDeltaY < 50 {
            
        }
    }
    
    
    // MARK: - AppFocusManagerDelegate
    
    func focusManager(focusManager: FocusManager, didChangeToApplication runningApplication: NSRunningApplication) {
        guard self.viewLoaded else {
            return
        }
        
//        self.focusedAppNameLabel.stringValue = runningApplication.bundleIdentifier ?? "<<<error>>>"
    }
    
    func focusManager(focusManager: FocusManager, didChangeToWebsiteURL websiteURL: NSURL) {
        guard self.viewLoaded else {
            return
        }
        
//        self.focusedAppNameLabel.stringValue = websiteURL.path ?? "<<<error>>>"
    }
    
}
