//
//  FocusManager.swift
//  HackIllinois
//
//  Created by Bryan Keller on 2/19/16.
//  Copyright © 2016 KelHop. All rights reserved.
//

import Cocoa

@objc protocol FocusManagerDelegate: class {
    
    func focusManager(focusManager: FocusManager, didChangeToApplication runningApplication: NSRunningApplication)
    func focusManager(focusManager: FocusManager, didChangeToWebsiteURL websiteURL: NSURL)
    
}

class FocusManager: NSObject {

    weak var delegate: FocusManagerDelegate?
    
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
        
        self.delegate?.focusManager(self, didChangeToApplication: runningApplication)
    }
    
}
