//
//  CurrentSessionViewController.swift
//  HackIllinois
//
//  Created by Bryan Keller on 2/20/16.
//  Copyright © 2016 KelHop. All rights reserved.
//

import Cocoa

class CurrentSessionViewController: NSViewController, RestrictionProfileSessionManagerDelegate {

    @IBOutlet weak var chickStateLabel: NSTextField!
    
    @IBOutlet weak var durationSlider: NSSlider!
    @IBOutlet weak var durationLabel: NSTextField!
    
    @IBOutlet weak var timeRemainingBackgroundView: NSView!
    @IBOutlet weak var timeRemainingLabel: NSTextField!
    @IBOutlet weak var toggleSessionButton: CircleButton!
    
    private var secondTimer: NSTimer?
    private var totalSecondsRemaining = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.whiteColor().CGColor
        
        self.durationSlider.target = self
        self.durationSlider.action = Selector("durationSliderValueChanged:")
        
        self.updateDurationSliderLabel()
        
        self.timeRemainingBackgroundView.wantsLayer = true
        self.timeRemainingBackgroundView.layer?.backgroundColor = NSColor.blackColor().colorWithAlphaComponent(0.5).CGColor
    }
    
    private func updateDurationSliderLabel() {
        self.durationLabel.stringValue = "\(Int(self.durationSlider.doubleValue)) min"
    }
    
    
    // MARK: - Target action
    
    @IBAction func toggleSessionButtonClicked(sender: AnyObject?) {
        if self.secondTimer != nil {
            RestrictionProfileSessionManager.sharedManager.endSession()
            self.restrictionProfileSessionManager(RestrictionProfileSessionManager.sharedManager, didFailSessionWithRestrictionProfile: RestrictionProfileSessionManager.sharedManager.restrictionProfile, minutesLeft: 30, causeIdentifier: "whatever")
            return
        }
        
        RestrictionProfileSessionManager.sharedManager.restrictionProfile = RestrictionProfile.restrictionProfileFromFile("work")!
        RestrictionProfileSessionManager.sharedManager.durationInMinutes = Int(self.durationSlider.doubleValue)
        RestrictionProfileSessionManager.sharedManager.delegate = self
        RestrictionProfileSessionManager.sharedManager.startSession()
        
        self.totalSecondsRemaining = RestrictionProfileSessionManager.sharedManager.durationInMinutes * 60
        self.secondTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("secondTimerFired:"), userInfo: nil, repeats: true)
        self.secondTimer?.fire()
        
        self.chickStateLabel.stringValue = "🐣"
        self.toggleSessionButton.title = "Give up"
        self.durationSlider.enabled = false
    }
    
    func durationSliderValueChanged(sender: AnyObject?) {
        self.updateDurationSliderLabel()
    }
    
    func secondTimerFired(timer: NSTimer) {
        guard self.totalSecondsRemaining >= 0 else {
            self.secondTimer?.invalidate()
            self.secondTimer = nil
            return
        }
        
        let minutes = self.totalSecondsRemaining / 60
        let seconds = self.totalSecondsRemaining - (minutes * 60)
        self.timeRemainingLabel.stringValue = "\(minutes) min, \(seconds) sec remaining!"
        
        self.totalSecondsRemaining -= 1
    }
    
    
    // MARK: - RestrictionProfileSessionManagerDelegate
    
    func restrictionProfileSessionManager(restrictionProfileSessionManager: RestrictionProfileSessionManager, didCompleteSessionWithRestrictionProfile restrictionProfile: RestrictionProfile) {
        self.toggleSessionButton.title = "Start session"
        self.durationSlider.enabled = true
        
        self.secondTimer?.invalidate()
        self.secondTimer = nil
        self.timeRemainingLabel.stringValue = "You did it! ❤️🐤"
        
        self.chickStateLabel.stringValue = "🐥"
        
        let successNotification = NSUserNotification()
        successNotification.title = "You did it!"
        successNotification.informativeText = "Great job being productive! Your newborn chick thanks you 🐥❤️"
        NSUserNotificationCenter.defaultUserNotificationCenter().scheduleNotification(successNotification)
    }
    
    func restrictionProfileSessionManager(restrictionProfileSessionManager: RestrictionProfileSessionManager, didFailSessionWithRestrictionProfile restrictionProfile: RestrictionProfile, minutesLeft: Int, causeIdentifier: String) {
        self.toggleSessionButton.title = "Try again"
        self.durationSlider.enabled = true
        
        self.secondTimer?.invalidate()
        self.secondTimer = nil
        self.timeRemainingLabel.stringValue = "Your chick died 💀"
        
        self.chickStateLabel.stringValue = "🍳"
        
        let failureNotification = NSUserNotification()
        failureNotification.title = "Your chick died"
        failureNotification.informativeText = "You spent too much time doing unproductive things 💔"
        NSUserNotificationCenter.defaultUserNotificationCenter().scheduleNotification(failureNotification)
    }
    
}
