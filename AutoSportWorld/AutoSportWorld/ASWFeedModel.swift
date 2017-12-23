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
    
    func updateEvents()
    func getEvents() -> [ASWRace]
    func getNumberOfEvents() -> Int
    func getEvent(forIndex index: Int) -> ASWRace
}

protocol ASWFeedsModelDelegate: class {
    func update()
    func updateError()
}

class ASWFeedsModel: ASWFeedsModelProtocol {
    
    weak var delegate: ASWFeedsModelDelegate?
    var events = [ASWRace]()
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(eventsCallback(_:)), name: .eventsCallback, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(eventsCallbackError(_:)), name: .eventsCallbackError, object: nil)
    }
    
    func updateEvents() {
        
        let request = ASWListRacesRequest(limit: nil, preferences: nil, level: nil, cursor: nil, categories: nil, regions: nil, sort: nil, canJoin: nil, canWatch: nil)
        
        ASWNetworkManager.getEvents(request: request)
        
        
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
        if let events = (notification.userInfo?["data"] as? ASWListRacesParser)?.races {
            self.events = events
            delegate?.update()
        }
    }
    
    @objc func eventsCallbackError(_ notification: Notification) {
        delegate?.updateError()
    }
    
}
