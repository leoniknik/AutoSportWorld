//
//  ASWFeedModel.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 17.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit
import Kingfisher

protocol ASWFeedsModelProtocol {
    weak var delegate: ASWFeedsModelDelegate? {get set}
    var events: [ASWRace] {get set}
    func updateEvents(cursor: String?, _ search: String?)
    func getEvents() -> [ASWRace]
    func getNumberOfEvents() -> Int
    func getEvent(forIndex index: Int) -> ASWRace
    func getImageFor(race: ASWRace, completion: @escaping () -> ())
    func bookmarkRace(withID id: Int)
    func checkBookmarkedRace(withID id: Int) -> Bool
    func likeEvent(id: Int, sucsessFunc: @escaping ()->())
    func unlikeEvent(id: Int, sucsessFunc: @escaping ()->())
}

protocol ASWFeedsModelDelegate: class {
    func update(cursor: String?)
    func updateError()
    func presentAlert(title:String, text:String)
}

class ASWFeedsModel: ASWFeedsModelProtocol {
    
    weak var delegate: ASWFeedsModelDelegate?
    var events = [ASWRace]()
    private let databaseService = ASWDatabaseManager()
    
    let defaultlimit = 10
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(eventsCallback(_:)), name: .eventsCallback, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(eventsCallbackError(_:)), name: .eventsCallbackError, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(eventsInitCallback(_:)), name: .eventsInitCallback, object: nil)
    }
    
    
    
    func updateEvents(cursor: String?, _ search: String? = nil) {
        var request: ASWListRacesRequest
        
        if let user = ASWDatabaseManager().getUser() {
            
//            //регионы
            var regions = [String]()
            for item in user.regions {
                regions.append(String(item.id))
            }
            let regionParameter = regions.joined(separator: ",")
            
//            категории
            var categories = [String]()
            for item in ASWDatabaseManager().getStringCategoriesIds(auto: true) ?? [] {
                categories.append(String(item))
            }
            for item in ASWDatabaseManager().getStringCategoriesIds(auto: false) ?? [] {
                categories.append(String(item))
            }
            let categoriesParameter = categories.joined(separator: ",")
//            //покататься
            let joinParameter = user.join
//
//            //посмотреть
            let watchParameter = user.watch
            
            let preferences =  "regions,categories,can_join,can_watch"
            
            var sortParameter: String? = nil
            /*сортировка (см. сортировка гонок). варианты:
             old - по убыванию времени начала
             new - по возрастанию времени начала
             soon - по возрастанию времени начала, исключая прошедшие
             cheap - по возрастанию цены, исключая прошедшие
             costly - по убыванию цены, исключая прошедшие */
            if user.dataFilter == 1 {
                sortParameter = "new"
            }

            switch user.costFilter {
            case 0:
                //                filters.append("soon")  free
                break
            case 1:
                sortParameter = "cheap"
                break
            case 2:
                sortParameter = "costly"
                break
            default:
                break
            }

            
            request = ASWListRacesRequest(limit: defaultlimit, preferences: preferences, level: nil, cursor: cursor, categories: categoriesParameter, regions: regionParameter, sort: sortParameter, canJoin: joinParameter, canWatch: watchParameter, search: search)
        } else {
            request = ASWListRacesRequest(limit: defaultlimit, preferences: nil, level: nil, cursor: cursor, categories: nil, regions: nil, sort: nil, canJoin: nil, canWatch: nil, search: search)
        }
        ASWNetworkManager.getEvents(request: request, cursor: cursor)
    }
    
    func getEvents() -> [ASWRace] {
        return events
    }
    
    func getNumberOfEvents() -> Int {
        return events.count
    }
    
    func getEvent(forIndex index: Int) -> ASWRace {
        return events[index]
    }
    
    func checkBookmarkedRace(withID id: Int) -> Bool {
        let race = getEvent(forIndex: id)
        guard let id = getRaceID(race: race) else {
            return false
        }
        return databaseService.checkBookmarkedRace(withID: id)
    }
    
    @objc func eventsCallback(_ notification: Notification) {
        if let response = (notification.userInfo?["data"] as? ASWListRacesParser) {
            for race in response.races {
                if (!self.events.map{$0.id ?? "-1"}.contains(race.id ?? "-1")) {
                    self.events.append(race)
                }
            }
            delegate?.update(cursor: response.cursor)
        }
    }
    
    @objc func eventsInitCallback(_ notification: Notification) {
        if let response = (notification.userInfo?["data"] as? ASWListRacesParser) {
            self.events.removeAll()
            self.events.append(contentsOf: response.races)
            delegate?.update(cursor: response.cursor)
        }
    }
    
    @objc func eventsCallbackError(_ notification: Notification) {
        delegate?.updateError()
    }

    func getImageFor(race: ASWRace, completion: @escaping () -> ()) {
//        if let url = race.imageURL {
//            ImageDownloader.default.downloadImage(with: URL(string:url)!, options: [], progressBlock: nil) {
//                (image, error, url, data) in
//                race.image = image
//                completion()
//                print("Downloaded Image: \(image)")
//            }
//        }
    }
    
    func getRaceID(race: ASWRace) -> Int? {
        guard let string = race.id else {
            return nil
        }
        guard let id = Int(string) else {
            return nil
        }
        return id
    }
    
    func bookmarkRace(withID id: Int) {
        if(databaseService.checkPermission()){
            let race = getEvent(forIndex: id)
            guard let id = getRaceID(race: race) else {
                return
            }
            databaseService.bookmarkRace(withID: id)
        }else{
            delegate?.presentAlert(title: "У вас нет прав", text: "У вас нет прав")
        }
    }
    
    func likeEvent(id: Int, sucsessFunc: @escaping ()->()) {
        ASWNetworkManager.likeEvent(id: events[id].id ?? "", successFunc: sucsessFunc)
    }
    
    func unlikeEvent(id: Int, sucsessFunc: @escaping ()->()) {
        
    }
    
}
