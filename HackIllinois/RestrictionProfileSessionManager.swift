//
//  RestrictionProfileSessionManager.swift
//  HackIllinois
//
//  Created by Evan Hopkins on 2/20/16.
//  Copyright © 2016 KelHop. All rights reserved.
//

import Cocoa

protocol RestrictionProfileSessionManagerDelegate: class {
    
    func restrictionProfileSessionManager(restrictionProfileSessionManager: RestrictionProfileSessionManager, didCompleteSessionWithRestrictionProfile restrictionProfile: RestrictionProfile)
    func restrictionProfileSessionManager(restrictionProfileSessionManager: RestrictionProfileSessionManager, didFailSessionWithRestrictionProfile restrictionProfile: RestrictionProfile, minutesLeft: Int, causeIdentifier: String)
    
}

class RestrictionProfileSessionManager: NSObject {
    
    private let restrictionProfile: RestrictionProfile
    let durationInMinutes: Int
    private var lastFocusChangeTime: NSDate?
    private var lastFocusIdentifier: String?
    public var timeSpent: [String: NSTimeInterval] = [String: NSTimeInterval]()
    weak var delegate: RestrictionProfileSessionManagerDelegate?
    
    private var sessionTimer: NSTimer?
    
    private var displayedNotification: NSUserNotification?
    private var failureTimer: NSTimer?

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
        self.sessionTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(self.durationInMinutes * 60), target: self, selector: Selector("sessionCompletionTimerFired:"), userInfo: nil, repeats: false)
    }
    
    func endSession() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        self.sessionTimer?.invalidate()
        self.sessionTimer = nil
        
        self.failureTimer?.invalidate()
        self.failureTimer = nil
    }
    
    private func isAppAllowed(appBundleIdentifier: String) -> Bool {
        return self.restrictionProfile.apps.contains(appBundleIdentifier) && self.restrictionProfile.appsRestrictionMode == .Whitelist
    }
    
    private func isWebsiteAllowed(domain: String) -> Bool {
        return self.restrictionProfile.websites.contains(domain) && self.restrictionProfile.websitesRestrictionMode == .Whitelist
    }
    
    private func domainFromUrl(urlPath: String) -> String? {
        guard let url = NSURL(string: urlPath) else {
            return nil
        }
        
        return url.host
    }
    
    private func logTimeSpent(forIdentifier identifier: String) {
        if let lastFocusChangeTime = self.lastFocusChangeTime, let lastFocusIdentifier = self.lastFocusIdentifier {
            var timeInterval = self.timeSpent[lastFocusIdentifier]!
            timeInterval += NSDate().timeIntervalSinceDate(lastFocusChangeTime)
            print(self.lastFocusIdentifier! + ": " + timeInterval.description)
            self.timeSpent[self.lastFocusIdentifier!] = timeInterval
        }
        
        if self.timeSpent[identifier] == nil {
            self.timeSpent[identifier] = 0
        }
        
        self.lastFocusIdentifier = identifier
        self.lastFocusChangeTime = NSDate()

    }
    
    
    // MARK: - Target action
    
    func sessionCompletionTimerFired(timer: NSTimer) {
        self.endSession()
        self.delegate?.restrictionProfileSessionManager(self, didCompleteSessionWithRestrictionProfile: self.restrictionProfile)
    }
    
    func failureTimerFired(timer: NSTimer) {
        self.endSession()
        self.delegate?.restrictionProfileSessionManager(self, didFailSessionWithRestrictionProfile: self.restrictionProfile, minutesLeft: 30, causeIdentifier: "com.yourMom.ayyy.lmao")
    }
    
    
    // MARK: - Focus Change Notifications
    
    func focusChangeNotificationReceived(notification: NSNotification) {
        guard let type = (notification.userInfo as? [String: String])?["type"],
              let identifier = (notification.userInfo as? [String: String])?["identifier"] else {
                return
        }
        
        if FocusObtainerType(rawValue: type) == FocusObtainerType.Website {
            self.logTimeSpent(forIdentifier: identifier)
            
            if let domain = self.domainFromUrl(identifier) {
                print(domain + " -> " + self.isWebsiteAllowed(domain).description)
                
                if !self.isWebsiteAllowed(domain) {
                    
                    if self.failureTimer == nil {
                        self.displayedNotification = NSUserNotification()
                        self.displayedNotification?.title = "Your egg is in danger!"
                        self.displayedNotification?.informativeText = "Return to an allowed website immediately or the baby chick in your egg will die 🐣🔫"
                        NSUserNotificationCenter.defaultUserNotificationCenter().scheduleNotification(self.displayedNotification!)
                        
                        self.failureTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("failureTimerFired:"), userInfo: nil, repeats: false)
                    }
                }
                else {
                    self.failureTimer?.invalidate()
                    self.failureTimer = nil
                    
                    NSUserNotificationCenter.defaultUserNotificationCenter().removeAllDeliveredNotifications()
                }
            }
        }
        else if FocusObtainerType(rawValue: type) == FocusObtainerType.Application {
            self.logTimeSpent(forIdentifier: identifier)

            if !self.isAppAllowed(identifier) {
                if self.failureTimer == nil {
                    self.displayedNotification = NSUserNotification()
                    self.displayedNotification?.title = "Your egg is in danger!"
                    self.displayedNotification?.informativeText = "Return to an allowed app immediately or the baby chick in your egg will die 🐣🔫"
                    NSUserNotificationCenter.defaultUserNotificationCenter().scheduleNotification(self.displayedNotification!)
                    
                    self.failureTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("failureTimerFired:"), userInfo: nil, repeats: false)
                }
            }
            else {
                self.failureTimer?.invalidate()
                self.failureTimer = nil
                
                NSUserNotificationCenter.defaultUserNotificationCenter().removeAllDeliveredNotifications()
            }
        }
    }
    
}