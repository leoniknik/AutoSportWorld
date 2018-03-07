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
    var racesParser: ASWListRacesParser

    init(json: JSON) {
        racesParser = ASWListRacesParser(json:json)
    }
}
