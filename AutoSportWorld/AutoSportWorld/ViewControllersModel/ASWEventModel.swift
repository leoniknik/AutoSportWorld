//
//  ASWEventModel.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 03.02.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import Foundation

class ASWEventModel {
    
    private let databaseService = ASWDatabaseManager()
    
    func getRaceID(race: ASWRace) -> Int? {
        guard let string = race.id else {
            return nil
        }
        guard let id = Int(string) else {
            return nil
        }
        return id
    }
    
    func bookmarkRace(race: ASWRace) {
        guard let id = getRaceID(race: race) else {
            return
        }
        databaseService.bookmarkRace(withID: id)
    }
    
    func checkBookmarkedRace(race: ASWRace) -> Bool {
        guard let id = getRaceID(race: race) else {
            return false
        }
        return databaseService.checkBookmarkedRace(withID: id)
    }
    
}
