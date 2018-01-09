//
//  ASWRaceCategoryEntity.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 07.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import Foundation
import RealmSwift

class ASWRaceCategoryEntity: Object {
    
    @objc dynamic var id: Int = 0
    //@objc dynamic var auto: Bool = false
    //let users = LinkingObjects(fromType: ASWUserEntity.self, property: "categories") // скорее не надо
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
