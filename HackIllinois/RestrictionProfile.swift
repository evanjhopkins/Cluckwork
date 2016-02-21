//
//  RestrictionProfile.swift
//  HackIllinois
//
//  Created by Evan Hopkins on 2/20/16.
//  Copyright © 2016 KelHop. All rights reserved.
//

import Cocoa

enum RestrictionMode {
    case Whitelist
    case Blacklist
}

class RestrictionProfile: NSObject {
    
    var profileName: String
    var apps: [String]
    var websites: [String]
    var appsRestrictionMode: RestrictionMode
    var websitesRestrictionMode: RestrictionMode
    
    init(profileName: String, apps: [String], websites: [String], appsRestrictionMode: RestrictionMode, websitesRestrictionMode: RestrictionMode) {
        self.profileName = profileName
        self.apps = apps
        self.websites = websites
        self.appsRestrictionMode = appsRestrictionMode
        self.websitesRestrictionMode = websitesRestrictionMode
    }
    
    class func restrictionProfileFromFile(profileName: String) -> RestrictionProfile? {
        if let path = NSBundle.mainBundle().pathForResource(profileName, ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    //coverting json data to native objects
                    let profileName = jsonObj["profileName"].stringValue
                    let apps = jsonObj["apps"].arrayObject as? [String] ?? []
                    let websites = jsonObj["websites"].arrayObject as? [String] ?? []
                    let appsRestrictionMode = jsonObj["isWhiteListApps"].boolValue ? RestrictionMode.Whitelist : RestrictionMode.Blacklist
                    let websitesRestrictionMode = jsonObj["isWhiteListWebsites"].boolValue ? RestrictionMode.Whitelist : RestrictionMode.Blacklist
                    
                    //create a restriction profile from those objects
                    let loadedRestrictionProfile = RestrictionProfile(profileName: profileName, apps: apps, websites: websites, appsRestrictionMode: appsRestrictionMode, websitesRestrictionMode: websitesRestrictionMode)
                    
                    return loadedRestrictionProfile
                }
                else {
                    print("File was found, but appears to be invalid")
                }
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        else {
            print("File not found, invalid filename/path.")
        }
        
        return nil
    }
    
    class func getProfiles() -> [String] {
        let profiles: [String] = ["test_profile", "work_profile", "study_profile"]
        return profiles
    }
    
    func saveRestrictionProfileToFile() {
        //not implementing for demo
    }
    
}
