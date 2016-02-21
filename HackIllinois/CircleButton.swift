//
//  CircleButton.swift
//  HackIllinois
//
//  Created by Bryan Keller on 2/20/16.
//  Copyright © 2016 KelHop. All rights reserved.
//

import Cocoa

@IBDesignable
class CircleButton: NSControl {
    
    @IBInspectable var color: NSColor = NSColor.grayColor() {
        didSet {
            self.updateColor()
        }
    }
    
    @IBInspectable var title: String = "" {
        didSet {
            self.updateTitle()
        }
    }
    
    @IBInspectable var titleColor: NSColor = NSColor.blackColor() {
        didSet {
            self.updateTitleColor()
        }
    }
    
    private let titleLabel = NSTextField()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.commonInit()
    }
    
    private func commonInit() {
        self.wantsLayer = true

        self.updateColor()
        
        self.addSubview(self.titleLabel)
        self.titleLabel.editable = false
        self.titleLabel.drawsBackground = false
        self.titleLabel.bezeled = false
        self.updateTitle()
        self.updateTitleColor()
        
        self.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: Selector("clicked:")))
    }
    
    override func resizeSubviewsWithOldSize(oldSize: NSSize) {
        super.resizeSubviewsWithOldSize(oldSize)
        
        self.layer?.cornerRadius = self.bounds.size.width / 2
        self.titleLabel.sizeToFit()
        self.titleLabel.frame = CGRect(x: self.bounds.width / 2 - self.titleLabel.bounds.size.width / 2, y: self.bounds.height / 2 - self.titleLabel.bounds.size.height / 2, width: self.titleLabel.bounds.size.width, height: self.titleLabel.bounds.size.height)
    }
    
    private func updateColor() {
        self.layer?.backgroundColor = self.color.CGColor
    }
    
    private func updateTitle() {
        self.titleLabel.stringValue = self.title
        self.resizeSubviewsWithOldSize(self.bounds.size)
    }
    
    private func updateTitleColor() {
        self.titleLabel.textColor = self.titleColor
    }
    
    // MARK: - Target action
    
    func clicked(gestureRecognizer: NSClickGestureRecognizer) {
        self.sendAction(self.action, to: self.target)
    }
    
}
