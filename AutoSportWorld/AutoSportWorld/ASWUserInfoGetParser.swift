//
//  ASWUserInfoGetParser.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 26.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import Foundation
import SwiftyJSON

class ASWUserInfoGetParser {
    var canWatch = false
    var canJoin = false
    
    var categoriesParser: ASWListCategoryParser
    var regionsParser: ASWListRegionsParser
    
    init(json: JSON) {
        canWatch = json["can_watch"].boolValue
        canJoin = json["can_join"].boolValue
        categoriesParser = ASWListCategoryParser(json:json)
        regionsParser = ASWListRegionsParser(json:json)
    }
    
}
