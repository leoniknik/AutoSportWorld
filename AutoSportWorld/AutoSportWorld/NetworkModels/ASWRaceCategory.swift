//
//  ASWCategory.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 17.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation

class ASWRaceCategory {
    var id: String?
    var name: String?
    var categoryClass: String? // "auto" или "moto"
    var image: String?
    
    init(id: String?, name: String?, categoryClass: String?, image: String?) {
        self.id = id
        self.name = name
        self.categoryClass = categoryClass
        self.image = image
    }
}
