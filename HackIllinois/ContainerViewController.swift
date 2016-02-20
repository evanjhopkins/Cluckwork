//
//  ContainerViewController.swift
//  HackIllinois
//
//  Created by Bryan Keller on 2/19/16.
//  Copyright © 2016 KelHop. All rights reserved.
//

import Cocoa

class ContainerViewController: NSViewController, AppFocusManagerDelegate {
    
    @IBOutlet weak var focusedAppNameLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        NSRunningApplication.currentApplication().activateWithOptions(NSApplicationActivationOptions.ActivateAllWindows)
    }
    
    
    // MARK: - AppFocusManagerDelegate
    
    func appFocusManager(appDocusManager: AppFocusManager, didChangeToApplication runningApplication: NSRunningApplication) {
        guard self.viewLoaded else {
            return
        }
        self.focusedAppNameLabel.stringValue = runningApplication.bundleIdentifier ?? "<<<error>>>"
    }
    
}
