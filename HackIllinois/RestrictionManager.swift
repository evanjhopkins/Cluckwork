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
    
    func isWebsiteAllowed(raw_url:String) -> Bool {
        let domain = domainFromUrl(raw_url)
        if(restrictionProfile.restrictedWebsites[domain] == false){
            return false
        }else{
            return true
        }
    }
    
    func isAppAllowed(app_name:String) -> Bool {
        if(restrictionProfile.restrictedApps[app_name] == false){
            return false
        }else{
            return true
        }
    }
    
    func domainFromUrl(raw_url: String) -> String {
        let url = NSURL(string: raw_url)
        let domain = url?.host
        return domain! as String
    }
    
    // MARK: - Focus Change Notifications
    
    func focusChangeNotificationReceived(notification: NSNotification) {
        guard let notificationType = (notification.userInfo as? [String: String])?["type"],
            let notificationIdentifier = (notification.userInfo as? [String: String])?["identifier"] else {
                return
        }
        
        if (FocusObtainerType(rawValue: notificationType) == FocusObtainerType.Website){
            print(domainFromUrl(notificationIdentifier) + " -> " + isWebsiteAllowed(notificationIdentifier).description)
        }else if(FocusObtainerType(rawValue: notificationType) == FocusObtainerType.Application){
            print(notificationIdentifier + " -> " + isAppAllowed(notificationIdentifier).description)
        }
    }
    
}