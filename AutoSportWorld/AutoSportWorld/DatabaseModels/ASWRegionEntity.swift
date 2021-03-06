//
//  ASWSportType.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 04.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import Foundation
import RealmSwift

class ASWRegionEntity: Object {
    
    @objc dynamic var id: Int = 0
    let users = LinkingObjects(fromType: ASWUserEntity.self, property: "regions") // скорее не надо
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
