//
//  ASWGetRaceParser.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 23.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//


import Foundation
import SwiftyJSON

class ASWGetRaceParser {
    
    var race: ASWRace
    
    init(json: JSON) {
        race = ASWRaceParser(race: json["race"]).item
    }
    
}
