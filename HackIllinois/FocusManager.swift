//
//  FocusManager.swift
//  HackIllinois
//
//  Created by Bryan Keller on 2/19/16.
//  Copyright © 2016 KelHop. All rights reserved.
//

import Cocoa
import Firebase

let FocusManagerDidChangeFocusNotification = "FocusManagerDidChangeFocusNotification"

enum FocusObtainerType: String {
    case Application = "Application"
    case Website = "Website"
}

class FocusManager: NSObject {
    
    override init() {
        super.init()
        
        NSWorkspace.sharedWorkspace().notificationCenter.addObserver(self, selector: Selector("focusedAppDidChange:"), name: NSWorkspaceDidActivateApplicationNotification, object: nil)
        
        let firebase = Firebase(url:"https://kelhophackillinois.firebaseio.com")
        firebase.observeEventType(.Value, withBlock: { (snapshot) -> Void in
            guard let websiteURLString = (snapshot.value as? NSDictionary)?["url"] else {
                return
            }
            
             NSNotificationCenter.defaultCenter().postNotificationName(FocusManagerDidChangeFocusNotification, object: self, userInfo: ["type": FocusObtainerType.Application.rawValue, "identifier": websiteURLString])
        })
           
    }
    
    deinit {
        NSWorkspace.sharedWorkspace().notificationCenter.removeObserver(self)
    }
    
 
    
    // MARK: - Target action
    
    func focusedAppDidChange(sender: NSNotification) {
        guard let runningApplicationBundleIdentifier = (sender.userInfo?[NSWorkspaceApplicationKey] as? NSRunningApplication)?.bundleIdentifier
        else {
            return
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(FocusManagerDidChangeFocusNotification, object: self, userInfo: ["type": FocusObtainerType.Application.rawValue, "identifier": runningApplicationBundleIdentifier])
    }
    
}
