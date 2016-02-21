//
//  CurrentSessionViewController.swift
//  HackIllinois
//
//  Created by Bryan Keller on 2/20/16.
//  Copyright © 2016 KelHop. All rights reserved.
//

import Cocoa

class CurrentSessionViewController: NSViewController {

    @IBOutlet weak var durationSlider: NSSlider!
    @IBOutlet weak var durationLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.whiteColor().CGColor
        
        self.durationSlider.target = self
        self.durationSlider.action = Selector("durationSliderValueChanged:")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("focusChangeNotificationReceived:"), name: FocusManagerDidChangeFocusNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    // MARK: - Target action
    
    @IBAction func toggleSessionButtonClicked(sender: AnyObject?) {
        
    }
    
    func durationSliderValueChanged(sender: AnyObject?) {
        self.durationLabel.stringValue = "\(Int(round(self.durationSlider.doubleValue))) min"
    }
    
    
    // MARK: - Focus Change Notifications
    
    func focusChangeNotificationReceived(notification: NSNotification) {
        guard self.viewLoaded else {
            return
        }
        
        print("Focus changed to \(notification.userInfo)")
    }
    
}
