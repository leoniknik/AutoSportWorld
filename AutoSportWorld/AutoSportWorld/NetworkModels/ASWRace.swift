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
    
    func getShortShedule() -> String {
        
        guard let times = self.times else {
            return "Время не указано"
        }
        let minTimes = times.map {$0.start ?? 0}
        let minTime = minTimes.min() ?? 0
        
        if minTime == 0 {
            return "Время не указано"
        }
        
        let maxTimes = times.map {$0.end ?? 0}
        let maxTime = maxTimes.max() ?? 0
        
        if maxTime == 0 {
            return "Время не указано"
        }
        
        let minDate = Date(timeIntervalSince1970: TimeInterval(minTime))
        let maxDate = Date(timeIntervalSince1970: TimeInterval(maxTime))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY"
        
        let minDateString = dateFormatter.string(from: minDate)
        let maxDateString = dateFormatter.string(from: maxDate)
        
        let result = "\(minDateString) - \(maxDateString)"
        return result
    }
    
    func getFullShedule() -> String {
        
        var result = ""
        guard let times = self.times else {
            return "Время не указано"
        }
        
        for item in times {
            if let start = item.start, let end = item.end {
                let startTime = Date(timeIntervalSince1970: TimeInterval(start))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = (item.dateOnly ?? true) == true ? "с dd.MM.YY" : "с HH:MM dd.MM.YY"
                let startTimeString = "\(dateFormatter.string(from: startTime))"
                
                let endTime = Date(timeIntervalSince1970: TimeInterval(end))
                dateFormatter.dateFormat = " - dd.MM.YY"
                let endTimeString = "\(dateFormatter.string(from: endTime))\n"
                
                result.append(startTimeString + endTimeString)
            }
            else if let start = item.start {
                let time = Date(timeIntervalSince1970: TimeInterval(start))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = (item.dateOnly ?? true) == true ? "с dd.MM.YY" : "с dd.MM.YY HH:MM"
                result.append("\(dateFormatter.string(from: time))\n")
            }
            else if let end = item.end {
                let time = Date(timeIntervalSince1970: TimeInterval(end))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "до dd.MM.YY"
                result.append("\(dateFormatter.string(from: time))\n")
            }
            else {
                continue
            }
            
        }
        result = String(result.dropLast())
        
        return result
    }
    
    func getRaceCategories() -> String {
        return (self.categories ?? []).map{$0.name ?? ""}.joined(separator: "; ")
    }
    
    func getJoinDescription() -> String {
        if (canJoin ?? false) {
            if let _ = jpriceFrom, let _ = jpriceTo {
                return "Покататься - да"
            }
            else if let priceTo = jpriceTo, priceTo == 0 {
                return "Покататься - бесплатно"
            }
            else if let priceFrom = jpriceFrom {
                return "Покататься - от \(priceFrom) р."
            }
            else {
                return "Покататься - да"
            }
        }
        else {
            return "Покататься - нет"
        }
    }
    
    func getWatchDescription() -> String {
        if canWatch ?? false {
            if let _ = wpriceFrom, let _ = wpriceTo {
                return "Посмотреть - да"
            }
            else if let priceTo = wpriceTo, priceTo == 0 {
                return "Посмотреть - бесплатно"
            }
            else if let priceFrom = wpriceFrom {
                return "Посмотреть - от \(priceFrom) р."
            }
            else {
                return "Посмотреть - да"
            }
        }
        else {
            return "Посмотреть - нет"
        }
    }
    
    var latitude: Double? {
        guard let array = geo?.components(separatedBy: " "), array.count == 2 else { return nil }
        return Double(array[0])
    }
    
    var longitude: Double? {
        guard let array = geo?.components(separatedBy: " "), array.count == 2 else { return nil }
        return Double(array[1])
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


