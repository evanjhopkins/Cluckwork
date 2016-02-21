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
    private let containerViewControllerPopover = NSPopover()
    private let containerViewController = ContainerViewController(nibName: "ContainerViewController", bundle: nil)
    
    private let focusManager = FocusManager()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        self.menuItem.image = NSImage(named: "icon")
        self.menuItem.image?.template = true
        self.menuItem.action = Selector("menuItemClicked:")
        
        self.containerViewControllerPopover.contentViewController = containerViewController
        self.containerViewControllerPopover.appearance = NSAppearance(named: NSAppearanceNameAqua)
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    
    // MARK: - Target action
    
    func menuItemClicked(sender: NSMenuItem) {        
        guard let menuItemButton = self.menuItem.button where !self.containerViewControllerPopover.shown else {
            self.containerViewControllerPopover.performClose(sender)
            return
        }
        
        self.containerViewControllerPopover.showRelativeToRect(menuItemButton.bounds, ofView: menuItemButton, preferredEdge: .MinY)
    }
    
}

