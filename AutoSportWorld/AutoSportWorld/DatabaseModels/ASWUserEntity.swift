//
//  User.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 02.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import Foundation
import RealmSwift

class ASWUserEntity: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var isLogedIn: Bool = false
    let favoriteRaces = List<ASWRaceEntity>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
