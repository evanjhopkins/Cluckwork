//
//  CurrentSessionViewController.swift
//  HackIllinois
//
//  Created by Bryan Keller on 2/20/16.
//  Copyright © 2016 KelHop. All rights reserved.
//

import Cocoa

class CurrentSessionViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.redColor().CGColor
    }
    
}
