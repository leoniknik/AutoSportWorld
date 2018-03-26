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
    @objc dynamic var login: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var auto: Bool = false
    @objc dynamic var moto: Bool = false
    @objc dynamic var watch: Bool = false
    @objc dynamic var join: Bool = false
    @objc dynamic var refresh_token: String?
    @objc dynamic var access_token: String?
    @objc dynamic var expires_at: Int = 0
    @objc dynamic var dataFilter: Int = 1
    @objc dynamic var costFilter: Int = 1

    let favoriteRaces = List<ASWRaceEntity>()
    let regions = List<ASWRegionEntity>()
    let autoCategories = List<ASWRaceCategoryEntity>()
    let motoCategories = List<ASWRaceCategoryEntity>()

    override static func primaryKey() -> String? {
        return "id"
    }
}
