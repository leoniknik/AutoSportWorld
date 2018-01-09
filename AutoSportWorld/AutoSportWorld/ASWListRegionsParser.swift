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
    
    init(json: JSON) {
        for item in json["regions"] {
            let raceRegion = item.1
            let id = raceRegion["id"].string
            let name = raceRegion["name"].string
            let centerCity = raceRegion["center_city"].string
            let image = raceRegion["image"].string
            let codes = (raceRegion["codes"].arrayObject ?? [Int]()) as! [Int]
            regions.append(ASWRaceRegion(id: id, name: name, centerCity: centerCity, image: image,codes:codes))
        }
    }
    
}
