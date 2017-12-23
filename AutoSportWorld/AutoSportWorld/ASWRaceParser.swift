//
//  ASWRaceParser.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 23.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation
import SwiftyJSON

class ASWRaceParser {
    
    var item: ASWRace
    
    init(race: JSON) {
        
        let id = race["id"].string
        let title = race["title"].string
        let shortTitle = race["short_title"].string
        let textRace = race["text"].string
        let whereRace = race["where"].string
        let raspisanie = race["raspisanie"].string
        let canWatch = race["can_watch"].bool
        let canJoin = race["can_join"].bool
        let jpriceFrom = race["jprice_from"].int
        let jpriceTo = race["jprice_to"].int
        let wpriceFrom = race["wprice_from"].int
        let wpriceTo = race["wprice_to"].int
        let level = race["level"].string
        let image = race["image"].string
        let link = race["link"].string
        let likes = race["likes"].int
        let liked = race["liked"].bool
        let geo = race["geo"].string
        
        var raceTimes = [ASWRaceTime]()
        for item in race["times"] {
            let raceTime = item.1
            let start = raceTime["start"].int
            let end = raceTime["end"].int
            let dateOnly = raceTime["date_only"].bool
            raceTimes.append(ASWRaceTime(start: start, end: end, dateOnly: dateOnly))
        }
        
        let regions = ASWListRegionsParser(json: race).regions
        
        let categories = ASWListCategoryParser(json: race).categories
        
        item = ASWRace(id: id, title: title, shortTitle: shortTitle, textRace: textRace, whereRace: whereRace, raspisanie: raspisanie, canWatch: canWatch, canJoin: canJoin, jpriceFrom: jpriceFrom, jpriceTo: jpriceTo, wpriceFrom: wpriceFrom, wpriceTo: wpriceTo, times: raceTimes, regions: regions, categories: categories, level: level, image: image, link: link, likes: likes, liked: liked, geo: geo)
    }
    
}
