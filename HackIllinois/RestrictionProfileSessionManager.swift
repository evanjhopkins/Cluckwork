//
//  RestrictionProfileSessionManager.swift
//  HackIllinois
//
//  Created by Evan Hopkins on 2/20/16.
//  Copyright © 2016 KelHop. All rights reserved.
//

import Cocoa

class RestrictionProfileSessionManager: NSObject {
    
    private let restrictionProfile: RestrictionProfile
    let durationInMinutes: Int
    
    private var sessionTimer: NSTimer?

    init(restrictionProfile: RestrictionProfile, durationInMinutes: Int) {
        self.restrictionProfile = restrictionProfile
        self.durationInMinutes = durationInMinutes
        
        super.init()
    }
    
    deinit {
        self.endSession()
    }
    
    func startSession() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("focusChangeNotificationReceived:"), name: FocusManagerDidChangeFocusNotification, object: nil)
        self.sessionTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(self.durationInMinutes * 60), target: self, selector: Selector("sessionDurationAchieved:"), userInfo: nil, repeats: false)
    }
    
    func endSession() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.sessionTimer?.invalidate()
        self.sessionTimer = nil
    }
    
    private func isAppAllowed(appBundleIdentifier: String) -> Bool {
        return self.restrictionProfile.apps.contains(appBundleIdentifier) && self.restrictionProfile.appsRestrictionMode == .Whitelist
    }
    
    private func isWebsiteAllowed(domain: String) -> Bool {
        return self.restrictionProfile.websites.contains(domain) && self.restrictionProfile.websitesRestrictionMode == .Whitelist
    }
    
    func domainFromUrl(urlPath: String) -> String? {
        guard let url = NSURL(string: urlPath) else {
            return nil
        }
        
        return url.host
    }
    
    
    // MARK: - Target action
    
    func sessionDurationAchieved(timer: NSTimer) {
        self.endSession()
    }
    
    
    // MARK: - Focus Change Notifications
    
    func focusChangeNotificationReceived(notification: NSNotification) {
        guard let type = (notification.userInfo as? [String: String])?["type"],
              let identifier = (notification.userInfo as? [String: String])?["identifier"] else {
                return
        }
        
        if FocusObtainerType(rawValue: type) == FocusObtainerType.Website {
            if let domain = self.domainFromUrl(identifier) {
                print(domain + " -> " + self.isWebsiteAllowed(domain).description)
                
                if !self.isWebsiteAllowed(domain) {
                    
                }
            }
        }
        else if FocusObtainerType(rawValue: type) == FocusObtainerType.Application {
            print(identifier + " -> " + self.isAppAllowed(identifier).description)
            
            if !self.isAppAllowed(identifier) {
                
            }
        }
    }
    
}