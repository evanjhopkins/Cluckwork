//
//  RestrictionManager.swift
//  HackIllinois
//
//  Created by Evan Hopkins on 2/20/16.
//  Copyright © 2016 KelHop. All rights reserved.
//

import Cocoa

class RestrictionManager: NSObject, FocusManagerDelegate {
    var restrictionProfile: RestrictionProfile
    //var restrictedDomains:[String:Bool] = ["www.facebook.com":false, "reddit.com":false]
    //var restrictedApps:[String:Bool] = ["Spotify":false]
    
    init(restrictionProfile: RestrictionProfile) {
        self.restrictionProfile = restrictionProfile
    }
    
    func isUrlAllowed(raw_url:String) -> Bool {
        let domain = domainFromUrl(raw_url)
        if(restrictionProfile.restrictedWebsites[domain] == false){
            return false
        }else{
            return true
        }
    }
    
    func domainFromUrl(raw_url:String) -> String {
        let url = NSURL(string: raw_url)
        let domain = url?.host
        return domain! as String
    }
    
    func focusManager(focusManager: FocusManager, didChangeToApplication runningApplication: NSRunningApplication) {
        //        self.focusedAppNameLabel.stringValue = runningApplication.bundleIdentifier ?? "<<<error>>>"
    }
    
    func focusManager(focusManager: FocusManager, didChangeToWebsiteURL websiteURL: NSURL) {
        print(websiteURL.description + " -> " + isUrlAllowed(websiteURL.description).description)
        //        self.focusedAppNameLabel.stringValue = websiteURL.path ?? "<<<error>>>"
    }
}