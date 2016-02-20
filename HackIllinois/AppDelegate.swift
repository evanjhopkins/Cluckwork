//
//  AppDelegate.swift
//  HackIllinois
//
//  Created by Bryan Keller on 2/19/16.
//  Copyright © 2016 KelHop. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet weak var window: NSWindow!
  
  private let menuItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)
  
  func applicationDidFinishLaunching(aNotification: NSNotification) {
    self.menuItem.image = NSImage(named: "icon")
    self.menuItem.image?.template = true
    self.menuItem.action = Selector("menuItemClicked:")
  }

  func applicationWillTerminate(aNotification: NSNotification) {
    // Insert code here to tear down your application
  }


  // MARK: - Target action
  
  func menuItemClicked(sender: NSMenuItem) {
    
  }
  
}

