//
//  ASWListRacesResponse.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 18.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation
import SwiftyJSON

class ASWListRacesParser {
    
    var races: [ASWRace] = []
    
    init(json: JSON) {
        
        for item in json["races"] {
            
            let race = ASWRaceParser(race: item.1).item
            races.append(race)
            
        }
    }
    
}
