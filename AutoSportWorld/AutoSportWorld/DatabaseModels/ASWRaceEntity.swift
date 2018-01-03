//
//  ASWRaceEntity.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 02.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import Foundation
import RealmSwift

class ASWRaceEntity: Object {
    
    @objc dynamic var id: Int = 0
    let users = LinkingObjects(fromType: ASWUserEntity.self, property: "favoriteRaces")
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
