//
//  ASWRace.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 17.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation
import UIKit

class ASWRace {
    
    var id: String?
    
    var title: String?
    
    var shortTitle: String?
    
    var textRace: String?
    
    var whereRace: String?
    
    var raspisanie: String? // строка с расписанием
    
    var canWatch: Bool? // можно смотреть
    
    var canJoin: Bool? // можно покататься
    
    var jpriceFrom: Int? // цена в рублях покататься, от. если null, то не указано
    
    var jpriceTo: Int? // цена в рублях покататься, до. если null, то не указано. если 0, то бесплатно
    
    var wpriceFrom: Int? // цена в рублях посмотреть, от. если null, то не указано
    
    var wpriceTo: Int? // цена в рублях посмотреть, до. если null, то не указано. если 0, то бесплатно
    
    var times: [ASWRaceTime]? // времена проведения
    
    var regions: [ASWRaceRegion]?
    
    var categories: [ASWRaceCategory]?
    
    var level: String? // id квалификации. "pro" - профессиональные, "nonpro" - любительские

    var imageURL: String? // ссылка на картинку
    var image: UIImage? // картинка

    var link: String? // внешняя ссылка на мероприятие

    var likes: Int? // число лайков

    var liked: Bool? // лайкнуто ли юзером. поле есть только у авторизованных

    var geo: String? // координаты. если null, то не указано
    
    init(id: String?, title: String?, shortTitle: String?, textRace: String?, whereRace: String?, raspisanie: String?, canWatch: Bool?, canJoin: Bool?, jpriceFrom: Int?, jpriceTo: Int?, wpriceFrom: Int?, wpriceTo: Int?, times: [ASWRaceTime]?, regions: [ASWRaceRegion]?, categories: [ASWRaceCategory]?, level: String?, image: String?, link: String?, likes: Int?, liked: Bool?, geo: String?) {
        
        self.id = id
        self.title = title
        self.shortTitle = shortTitle
        self.textRace = textRace
        self.whereRace = whereRace
        self.raspisanie = raspisanie
        self.canWatch = canWatch
        self.canJoin = canJoin
        self.jpriceFrom = jpriceFrom
        self.jpriceTo = jpriceTo
        self.wpriceFrom = wpriceFrom
        self.wpriceTo = wpriceTo
        self.times = times
        self.regions = regions
        self.categories = categories
        self.level = level
        self.imageURL = image
        self.link = link
        self.likes = likes
        self.liked = liked
        self.geo = geo
        
    }
    
}

class ASWRaceTime {
    var start: Int? // timestamp начала в местном часовом поясе
    
    var end: Int? // timestamp конца в местном часовом поясе. если null, то не указано
    
    var dateOnly: Bool? // если тру, то игнорировать время дня = ""
    
    init(start: Int?, end: Int?, dateOnly: Bool?) {
        self.start = start
        self.end = end
        self.dateOnly = dateOnly
    }
}


