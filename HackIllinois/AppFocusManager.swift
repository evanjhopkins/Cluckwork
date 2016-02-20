//
//  AppFocusManager.swift
//  HackIllinois
//
//  Created by Bryan Keller on 2/19/16.
//  Copyright © 2016 KelHop. All rights reserved.
//

import Cocoa

@objc protocol AppFocusManagerDelegate: class {
    
    func appFocusManager(appDocusManager: AppFocusManager, didChangeToApplication runningApplication: NSRunningApplication)
    
}

class AppFocusManager: NSObject {

    weak var delegate: AppFocusManagerDelegate?
    
    override init() {
        super.init()
        
        NSWorkspace.sharedWorkspace().notificationCenter.addObserver(self, selector: Selector("focusedAppDidChange:"), name: NSWorkspaceDidActivateApplicationNotification, object: nil)
    }
    
    deinit {
        NSWorkspace.sharedWorkspace().notificationCenter.removeObserver(self)
    }
    
    
    // MARK: - Target action
    
    func focusedAppDidChange(sender: NSNotification) {
        guard let runningApplication = sender.userInfo?[NSWorkspaceApplicationKey] as? NSRunningApplication else {
            return
        }
        
        self.delegate?.appFocusManager(self, didChangeToApplication: runningApplication)
    }
    
}
