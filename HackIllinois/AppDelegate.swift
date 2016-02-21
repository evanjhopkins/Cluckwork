//
//  AppDelegate.swift
//  HackIllinois
//
//  Created by Bryan Keller on 2/19/16.
//  Copyright © 2016 KelHop. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("focusChangeNotificationReceived:"), name: FocusManagerDidChangeFocusNotification, object: nil)
        
        NSUserNotificationCenter.defaultUserNotificationCenter().delegate = self
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    private func openMenu() {
        guard let menuItemButton = self.menuItem.button else {
            return
        }
        
        self.containerViewControllerPopover.showRelativeToRect(menuItemButton.bounds, ofView: menuItemButton, preferredEdge: .MinY)
        NSRunningApplication.currentApplication().activateWithOptions(NSApplicationActivationOptions.ActivateIgnoringOtherApps)
    }
    
    private func closeMenu() {
        self.containerViewControllerPopover.performClose(nil)
    }
    
    
    // MARK: - Target action
    
    func menuItemClicked(sender: NSMenuItem) {        
        guard !self.containerViewControllerPopover.shown else {
            self.closeMenu()
            return
        }
        
        self.openMenu()
    }
    
    
    // MARK: - Focus Change Notifications
    
    func focusChangeNotificationReceived(notification: NSNotification) {
        if NSRunningApplication.currentApplication().bundleIdentifier != NSWorkspace.sharedWorkspace().frontmostApplication?.bundleIdentifier {
            self.closeMenu()
        }
    }
    
    
    // MARK: - NSUserNotificationCenterDelegate
    
    func userNotificationCenter(center: NSUserNotificationCenter, didActivateNotification notification: NSUserNotification) {
        self.openMenu()
    }
    
}

