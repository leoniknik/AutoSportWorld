//
//  ASWListRegions.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 23.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation
import SwiftyJSON

class ASWListRegionsParser {
    
    var regions: [ASWRaceRegion] = []
    var regionsIDs: [Int] = []
    init(json: JSON) {
        for item in json["regions"] {
            let raceRegion = item.1
            let id = raceRegion["id"].string
            let name = raceRegion["name"].string
            let centerCity = raceRegion["center_city"].string
            let image = raceRegion["image"].string
            let codesArray = raceRegion["codes"].arrayObject ?? [Any]()
            var codes = [Int]()
            if codesArray.count > 0{
                if let _ = codesArray[0] as? Int {
                    codes = codesArray.map({return $0 as? Int ?? 0})
                }else{
                    codes = codesArray.map({return Int(($0 as? String) ?? "0") ?? 0})
                }
            }

            regions.append(ASWRaceRegion(id: id, name: name, centerCity: centerCity, image: image,codes:codes))
            regionsIDs.append(Int(id ?? "") ?? 0)
        }
    }
    
}
