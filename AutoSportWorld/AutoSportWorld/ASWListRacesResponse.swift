//
//  ASWListRacesResponse.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 18.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation
import SwiftyJSON

class ASWListRacesResponse {
    
    var races: [ASWRace] = []
    
    init(json: JSON) {
        for item in json["races"] {
            print(json)
            let race = item.1
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
            
            var regions = [ASWRaceRegion]()
            for item in race["regions"] {
                let raceRegion = item.1
                let id = raceRegion["id"].string
                let name = raceRegion["name"].string
                let centerCity = raceRegion["center_city"].string
                let image = raceRegion["image"].string
                regions.append(ASWRaceRegion(id: id, name: name, centerCity: centerCity, image: image))
            }
            
            var categories = [ASWRaceCategory]()
            for item in race["categories"] {
                let raceCategory = item.1
                let name = raceCategory["name"].string
                let categoryClass = raceCategory["class"].string
                let id = raceCategory["id"].string
                let image = raceCategory["image"].string
                categories.append(ASWRaceCategory(id: id, name: name, categoryClass: categoryClass, image: image))
            }
            
            races.append(ASWRace(id: id, title: title, shortTitle: shortTitle, textRace: textRace, whereRace: whereRace, raspisanie: raspisanie, canWatch: canWatch, canJoin: canJoin, jpriceFrom: jpriceFrom, jpriceTo: jpriceTo, wpriceFrom: wpriceFrom, wpriceTo: wpriceTo, times: raceTimes, regions: regions, categories: categories, level: level, image: image, link: link, likes: likes, liked: liked, geo: geo))
            
        }
    }
    
}
