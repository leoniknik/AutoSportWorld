//
//  UIAplication+Version.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 21.02.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

extension UIApplication {
    
    class func appVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    class func appBuild() -> String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
    class func versionBuild() -> String {
        let version = appVersion(), build = appBuild()
        
        return version == build ? "v\(version)" : "v\(version)(\(build))"
    }
}
