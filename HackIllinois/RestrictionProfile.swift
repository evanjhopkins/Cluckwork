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
    
    init(profileName: String, restrictedWebsites: [String:Bool], restrictedApps: [String:Bool], isWhiteListApps: Bool, isWhiteListWebsites: Bool) {
        self.profileName = profileName
        self.restrictedWebsites = restrictedWebsites
        self.restrictedApps = restrictedApps
        self.isWhiteListApps = isWhiteListApps
        self.isWhiteListWebsites = isWhiteListWebsites
    }
    
    class func RestrictionProfileFromFile(profileName: String) -> RestrictionProfile? {
        if let path = NSBundle.mainBundle().pathForResource(profileName, ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    //coverting json data to native objects
                    let profileName = jsonObj["profileName"].stringValue
                    let restrictedApps = jsonObj["restrictedApps"].dictionaryObject as! [String:Bool]
                    let restrictedWebsites = jsonObj["restrictedWebsites"].dictionaryObject as! [String:Bool]
                    let isWhiteListApps = jsonObj["isWhiteListApps"].boolValue
                    let isWhiteListWebsites = jsonObj["isWhiteListWebsites"].boolValue
                    //create a restriction profile from those objects
                    let loadedRestrictionProfile = RestrictionProfile(
                        profileName: profileName,
                        restrictedWebsites: restrictedWebsites,
                        restrictedApps: restrictedApps,
                        isWhiteListApps: isWhiteListApps,
                        isWhiteListWebsites: isWhiteListWebsites
                    )
                    return loadedRestrictionProfile
                } else {
                    print("File was found, but appears to be invalid")
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
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
