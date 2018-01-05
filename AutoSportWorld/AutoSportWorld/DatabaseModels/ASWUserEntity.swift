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
    @objc dynamic var email: String = ""
    @objc dynamic var password: String = ""
    @objc dynamic var login: String = ""
    
    @objc dynamic var auto: Bool = false
    @objc dynamic var autoWatch: Bool = false
    @objc dynamic var autoJoin: Bool = false
    
    
    @objc dynamic var moto: Bool = false
    @objc dynamic var motoWatch: Bool = false
    @objc dynamic var motoJoin: Bool = false
    
    let favoriteRaces = List<ASWRaceEntity>()
    
    let autoRegions = List<ASWRegionEntity>()
    let motoRegions = List<ASWRegionEntity>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
