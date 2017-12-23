//
//  ASWFeedModel.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 17.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation

protocol ASWFeedsModelProtocol {
    weak var delegate: ASWFeedsModelDelegate? {get set}
    
    func updateEvents(cursor: String?)
    func getEvents() -> [ASWRace]
    func getNumberOfEvents() -> Int
    func getEvent(forIndex index: Int) -> ASWRace
}

protocol ASWFeedsModelDelegate: class {
    func update(cursor: String?)
    func updateError()
}

class ASWFeedsModel: ASWFeedsModelProtocol {
    
    weak var delegate: ASWFeedsModelDelegate?
    var events = [ASWRace]()
    
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
    
    @objc func eventsCallback(_ notification: Notification) {
        if let response = (notification.userInfo?["data"] as? ASWListRacesParser) {
            self.events.append(contentsOf: response.races)
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
    
}
