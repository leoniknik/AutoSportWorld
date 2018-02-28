//
//  ASWFavoriteModel.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 03.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWFavoriteModel: ASWFeedsModelProtocol {
    
    var events = [ASWRace]()
    var results = [Int]()
    var countOfEvents = 0
    private let imageService = ASWImageDownloader()
    private let databaseService = ASWDatabaseManager()
    
    weak var delegate: ASWFeedsModelDelegate?
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(eventCallback(_:)), name: .eventCallback, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(eventCallbackError(_:)), name: .eventCallbackError, object: nil)
    }
    
    func updateEvents(cursor: String?) {
        
        guard let racesIDs = databaseService.getRaceIds() else {
            delegate?.updateError()
            return
        }
        
        countOfEvents = racesIDs.count
        
        if countOfEvents == 0 {
            delegate?.updateError()
        }
        
        for id in racesIDs {
            let request = ASWRaceRequest(raceID: id)
            ASWNetworkManager.getEvent(request: request)
        }
        
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
    
    func getImageFor(race: ASWRace, completion: @escaping () -> ()) {
        if let url = race.imageURL {
            imageService.send(url: url, completionHandler: { (image) in
                race.image = image
                completion()
            })
        }
    }
    
    func bookmarkRace(withID id: Int) {
        let race = getEvent(forIndex: id)
        guard let id = getRaceID(race: race) else {
            return
        }
        databaseService.bookmarkRace(withID: id)
    }
    
    func checkBookmarkedRace(withID id: Int) -> Bool {
        let race = getEvent(forIndex: id)
        guard let id = getRaceID(race: race) else {
            return false
        }
        return databaseService.checkBookmarkedRace(withID: id)
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
    
    @objc func eventCallback(_ notification: Notification) {
        if let response = (notification.userInfo?["data"] as? ASWRaceParser) {
            self.events.append(response.item)
            self.results.append(1)
            if self.results.count == countOfEvents {
                delegate?.update(cursor: nil)
            }
        }
    }
    
    @objc func eventCallbackError(_ notification: Notification) {
        self.results.append(1)
        if self.results.count == countOfEvents {
            delegate?.updateError()
        }
    }
    
    func likeEvent(id: Int, sucsessFunc: @escaping () -> ()) {
        
    }
    
    func unlikeEvent(id: Int, sucsessFunc: @escaping () -> ()) {
        
    }
    
}
