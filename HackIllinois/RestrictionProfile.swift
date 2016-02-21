//
//  RestrictionProfile.swift
//  HackIllinois
//
//  Created by Evan Hopkins on 2/20/16.
//  Copyright © 2016 KelHop. All rights reserved.
//

import Cocoa

class RestrictionProfile: NSObject{
    var profileName: String
    var restrictedWebsites: [String:Bool]
    var restrictedApps: [String:Bool]
    var isWhiteListApps: Bool
    var isWhiteListWebsites: Bool
    
    //new
    init(profileName: String, restrictedWebsites: [String:Bool], restrictedApps: [String:Bool], isWhiteListApps: Bool, isWhiteListWebsites: Bool) {
        self.profileName = profileName
        self.restrictedWebsites = restrictedWebsites
        self.restrictedApps = restrictedApps
        self.isWhiteListApps = isWhiteListApps
        self.isWhiteListWebsites = isWhiteListWebsites
        RestrictionProfile.loadRestrictionProfileFromFile("test_profile")
    }
    
    static func loadRestrictionProfileFromFile(profileName: String) {
        if let path = NSBundle.mainBundle().pathForResource("test_profile", ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    print(jsonObj["restrictedApps"])
                    let profileName = jsonObj["profileName"]
                    let restrictedApps = jsonObj["restrictedApps"]
                    let restrictedWebsites = jsonObj["restrictedWebsites"]
                    let isWhiteListApps = jsonObj["isWhiteListApps"]
                    let isWhiteListWebsites = jsonObj["isWhiteListWebsites"]
//                    let loadedRestrictionProfile = RestrictionProfile(
//                        profileName: profileName.stringValue,
//                        restrictedWebsites: restrictedWebsites.dictionaryValue,
//                        restrictedApps: restrictedApps.dictionaryValue,
//                        isWhiteListApps: isWhiteListApps.boolValue,
//                        isWhiteListWebsites: isWhiteListWebsites.boolValue
//                    )
                } else {
                    print("File was found, but appears to be invalid")
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("File not found, invalid filename/path.")
        }
    }
    
    func saveRestrictionProfileToFile() {
    
    }
}
