//
//  ASWListCategoryParser.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 23.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation
import SwiftyJSON

class ASWListCategoryParser {
    
    var categories = [ASWRaceCategory]()
    var autoCategoryIDs: [Int] = []
    var motoCategoryIDs: [Int] = []
    
    init(json: JSON) {
        for item in json["categories"] {
            let raceCategory = item.1
            let name = raceCategory["name"].string
            let categoryClass = raceCategory["class"].string
            let id = raceCategory["id"].string
            let image = raceCategory["image"].string
            categories.append(ASWRaceCategory(id: id, name: name, categoryClass: categoryClass, image: image))
            if(categoryClass == "auto"){
                autoCategoryIDs.append(Int(id ?? "") ?? 0)
            }else{
                motoCategoryIDs.append(Int(id ?? "") ?? 0)
            }
        }
    }
    
}
