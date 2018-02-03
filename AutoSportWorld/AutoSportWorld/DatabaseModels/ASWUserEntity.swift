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
    
    @objc dynamic var refresh_token: String?
    @objc dynamic var access_token: String?
    @objc dynamic var expires_at: Int = 0

    let favoriteRaces = List<ASWRaceEntity>()
    
    let regions = List<ASWRegionEntity>()
    let autoCategories = List<ASWRaceCategoryEntity>()
    let motoCategories = List<ASWRaceCategoryEntity>()
    
    
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
