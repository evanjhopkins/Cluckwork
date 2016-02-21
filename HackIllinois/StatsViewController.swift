//
//  StatsViewController.swift
//  HackIllinois
//
//  Created by Bryan Keller on 2/20/16.
//  Copyright © 2016 KelHop. All rights reserved.
//

import Cocoa

class StatsViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet private weak var statsTableView: NSTableView!
    
    private var stats = ["stat one", "stat two", "stat three"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statsTableView.setDataSource(self)
        self.statsTableView.setDelegate(self)
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.whiteColor().CGColor
    }
    
    
    // MARK: - NSTableViewDelegate
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // 1
        let cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        
        // 2
        if tableColumn!.title == "StatColumn" {
            print("its stat")
            // 3
            let stat = self.stats[row]
            cellView.textField!.stringValue = stat
            return cellView
        }else{
            print("not stat")
        }
        
        return cellView
    }
    
    
    // MARK: - NSTableViewDataSource
    
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        return self.stats.count
    }
    
}
