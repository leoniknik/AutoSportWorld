//
//  ASWFeedModel.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 17.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

protocol ASWFeedsModelProtocol {
    weak var delegate: ASWFeedsModelDelegate? {get set}
    var events: [ASWRace] {get set}
    func updateEvents(cursor: String?)
    func getEvents() -> [ASWRace]
    func getNumberOfEvents() -> Int
    func getEvent(forIndex index: Int) -> ASWRace
    func getImageFor(race: ASWRace, completion: @escaping () -> ())
    func bookmarkRace(withID id: Int)
    func checkBookmarkedRace(withID id: Int) -> Bool
}

protocol ASWFeedsModelDelegate: class {
    func update(cursor: String?)
    func updateError()
}

class ASWFeedsModel: ASWFeedsModelProtocol {
    
    
    weak var delegate: ASWFeedsModelDelegate?
    var events = [ASWRace]()
    private let imageService = ASWImageDownloader()
    private let databaseService = ASWDatabaseManager()
    
    let defaultlimit = 10
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(eventsCallback(_:)), name: .eventsCallback, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(eventsCallbackError(_:)), name: .eventsCallbackError, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(eventsInitCallback(_:)), name: .eventsInitCallback, object: nil)
    }
    
    
    
    func updateEvents(cursor: String?) {
        let request = ASWListRacesRequest(limit: defaultlimit, preferences: nil, level: nil, cursor: cursor, categories: nil, regions: nil, sort: nil, canJoin: nil, canWatch: nil)
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
        if let url = race.imageURL {
            imageService.send(url: url, completionHandler: { (image) in
                race.image = image
                completion()
            })
        }
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
        let race = getEvent(forIndex: id)
        guard let id = getRaceID(race: race) else {
            return
        }
        databaseService.bookmarkRace(withID: id)
    }
    
}
