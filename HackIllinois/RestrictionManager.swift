//
//  RestrictionManager.swift
//  HackIllinois
//
//  Created by Evan Hopkins on 2/20/16.
//  Copyright © 2016 KelHop. All rights reserved.
//

import Cocoa

class RestrictionManager: NSObject {
    var restrictionProfile: RestrictionProfile

    init(restrictionProfile: RestrictionProfile) {
        self.restrictionProfile = restrictionProfile
        
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("focusChangeNotificationReceived:"), name: FocusManagerDidChangeFocusNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func isWebsiteAllowed(domain: String) -> Bool {
        return !(restrictionProfile.websites.contains(domain) ?? true)
    }
    
    private func isAppAllowed(appBundleIdentifier: String) -> Bool {
        return !(restrictionProfile.apps.contains(appBundleIdentifier) ?? true)
    }
    
    func domainFromUrl(urlPath: String) -> String? {
        guard let url = NSURL(string: urlPath) else {
            return nil
        }
        
        return url.host
    }
    
    // MARK: - Focus Change Notifications
    
    func focusChangeNotificationReceived(notification: NSNotification) {
        guard let type = (notification.userInfo as? [String: String])?["type"],
              let identifier = (notification.userInfo as? [String: String])?["identifier"] else {
                return
        }
        
        if FocusObtainerType(rawValue: type) == FocusObtainerType.Website {
            if let domain = self.domainFromUrl(identifier) {
                print(domain + " -> " + isWebsiteAllowed(domain).description)
            }
        }
        else if FocusObtainerType(rawValue: type) == FocusObtainerType.Application {
            print(identifier + " -> " + isAppAllowed(identifier).description)
        }
    }
    
}