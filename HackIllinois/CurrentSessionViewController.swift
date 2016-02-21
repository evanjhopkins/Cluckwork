//
//  CurrentSessionViewController.swift
//  HackIllinois
//
//  Created by Bryan Keller on 2/20/16.
//  Copyright © 2016 KelHop. All rights reserved.
//

import Cocoa

class CurrentSessionViewController: NSViewController, RestrictionProfileSessionManagerDelegate {

    @IBOutlet weak var statusLabel: NSTextField!
    
    @IBOutlet weak var durationSlider: NSSlider!
    @IBOutlet weak var durationLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.whiteColor().CGColor
        
        self.durationSlider.target = self
        self.durationSlider.action = Selector("durationSliderValueChanged:")
    }
    
    
    // MARK: - Target action
    
    @IBAction func toggleSessionButtonClicked(sender: AnyObject?) {
        
        RestrictionProfileSessionManager.sharedManager.restrictionProfile = RestrictionProfile.restrictionProfileFromFile("work")!
        RestrictionProfileSessionManager.sharedManager.durationInMinutes = 5
        RestrictionProfileSessionManager.sharedManager.delegate = self
        RestrictionProfileSessionManager.sharedManager.startSession()
        self.statusLabel.stringValue = "Don't let your chick die!"
    }
    
    func durationSliderValueChanged(sender: AnyObject?) {
        self.durationLabel.stringValue = "\(Int(self.durationSlider.doubleValue)) min"
    }
    
    
    // MARK: - RestrictionProfileSessionManagerDelegate
    
    func restrictionProfileSessionManager(restrictionProfileSessionManager: RestrictionProfileSessionManager, didCompleteSessionWithRestrictionProfile restrictionProfile: RestrictionProfile) {
        self.statusLabel.stringValue = "You did it! 🐥"
    }
    
    func restrictionProfileSessionManager(restrictionProfileSessionManager: RestrictionProfileSessionManager, didFailSessionWithRestrictionProfile restrictionProfile: RestrictionProfile, minutesLeft: Int, causeIdentifier: String) {
        self.statusLabel.stringValue = "Your chick died 💀🐣💀"
    }
    
}
