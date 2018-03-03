//
//  ASWCalendarRacesParser.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 21.02.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit
import SwiftyJSON

class ASWCalendarRacesParser {
//    var canWatch = false
//    var canJoin = false
//    
//    var categoriesParser: ASWListCategoryParser
//    var regionsParser: ASWListRegionsParser
    var racesParser: ASWListRacesParser

    init(json: JSON) {
        racesParser = ASWListRacesParser(json:json)
    }
    
}
