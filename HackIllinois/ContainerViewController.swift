//
//  ContainerViewController.swift
//  HackIllinois
//
//  Created by Bryan Keller on 2/19/16.
//  Copyright © 2016 KelHop. All rights reserved.
//

import Cocoa

enum ViewingState {
    case ViewingCurrentSession
    case ViewingStats
}

class ContainerViewController: NSViewController {
    
    private let currentSessionViewController = CurrentSessionViewController(nibName: "CurrentSessionViewController", bundle:nil)!
    private let statsViewController = StatsViewController(nibName: "StatsViewController", bundle:nil)!
    
    private var viewingState = ViewingState.ViewingCurrentSession {
        didSet {
            NSAnimationContext.runAnimationGroup({ (animationContext) -> Void in
                animationContext.duration = 0.25
                self.viewWillLayout()
            }, completionHandler:nil)
        }
    }
    private var swipeGestureActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChildViewController(self.currentSessionViewController)
        self.view.addSubview(self.currentSessionViewController.view)
        self.currentSessionViewController.view.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: Selector("currentSessionViewControllerClicked:")))
        
        self.addChildViewController(self.statsViewController)
        self.view.addSubview(self.statsViewController.view)
        self.statsViewController.view.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: Selector("statsViewControllerClicked:")))
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        
        let height = self.view.bounds.size.height - 44
        switch self.viewingState {
            case .ViewingCurrentSession:
                self.currentSessionViewController.view.animator().frame = CGRect(x: 0, y: 44, width: self.view.bounds.size.width, height: height)
                self.statsViewController.view.animator().frame = CGRect(x: 0, y: 44 - height, width: self.view.bounds.size.width, height: height)
            
            case .ViewingStats:
                self.currentSessionViewController.view.animator().frame = CGRect(x: 0, y: height, width: self.view.bounds.size.width, height: height)
                self.statsViewController.view.animator().frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: height)
        }
    }
    
    
    // MARK: - Target action
    
    override func scrollWheel(theEvent: NSEvent) {
        guard abs(theEvent.scrollingDeltaY) > 50 && !self.swipeGestureActive else {
            self.swipeGestureActive = theEvent.scrollingDeltaY != 0
            return
        }
        
        self.swipeGestureActive = true
        
        if theEvent.scrollingDeltaY > 0 {
            self.viewingState = .ViewingCurrentSession
        }
        else if theEvent.scrollingDeltaY < 0 {
            self.viewingState = .ViewingStats
        }
    }
    
    func currentSessionViewControllerClicked(gestureRecognizer: NSClickGestureRecognizer) {
        self.viewingState = .ViewingCurrentSession
    }
    
    func statsViewControllerClicked(gestureRecognizer: NSClickGestureRecognizer) {
        self.viewingState = .ViewingStats
    }
    
}
