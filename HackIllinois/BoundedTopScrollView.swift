//
//  BoundedTopScrollView.swift
//  HackIllinois
//
//  Created by Bryan Keller on 2/21/16.
//  Copyright © 2016 KelHop. All rights reserved.
//

import Cocoa

class BoundedTopScrollView: NSScrollView {
    
    override func scrollWheel(theEvent: NSEvent) {
        if self.verticalScroller?.floatValue == 0 && theEvent.scrollingDeltaY >= 0 {
            self.nextResponder?.scrollWheel(theEvent)
        }
    }
    
}
