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
    
    private var stats = [(String, NSImage)]()
    
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
        stats = []
        let sortedDict = Array(restrictionProf.timeSpent).sort({$0.1 > $1.1})
        for (bundleIdentifier, timeInterval) in sortedDict {
            if(restrictionProf.blockedAppAndWebsiteIdentifiers().contains(bundleIdentifier)){
                guard let path = NSWorkspace.sharedWorkspace().absolutePathForAppBundleWithIdentifier(bundleIdentifier),
                      let bundle = NSBundle(path: path),
                      let name = bundle.localizedInfoDictionary?["CFBundleName"] else {
                    continue
                }
                
                let icon = NSWorkspace.sharedWorkspace().iconForFile(path)
                stats.append(("\(Int(ceil(timeInterval))) seconds in \(name)", icon))
            }
        }
    }
    
    
    // MARK: - NSTableViewDelegate
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        
        if tableColumn!.title == "StatColumn" {
            let stat = self.stats[row]
            cellView.textField?.stringValue = stat.0
            cellView.imageView?.image = stat.1
            return cellView
        }
        
        return cellView
    }
    
    
    // MARK: - NSTableViewDataSource
    
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        return self.stats.count
    }
    
}
