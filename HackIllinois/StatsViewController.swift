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
    
    override func viewWillAppear() {
        updateStats()
        statsTableView.reloadData()
    }
    
    func updateStats() {
        let restrictionProf = RestrictionProfileSessionManager.sharedManager
        print(restrictionProf.timeSpent)
        stats = []
        for(key, value) in restrictionProf.timeSpent {
            stats.append(Int(value).description + " seconds in " + key )
        }
    }
    
    
    // MARK: - NSTableViewDelegate
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        
        if tableColumn!.title == "StatColumn" {
            let stat = self.stats[row]
            cellView.textField!.stringValue = stat
            return cellView
        }
        
        return cellView
    }
    
    
    // MARK: - NSTableViewDataSource
    
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        return self.stats.count
    }
    
}
