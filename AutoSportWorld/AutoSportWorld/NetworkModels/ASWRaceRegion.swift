//
//  ASWRegion.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 17.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation

class ASWRaceRegion {
    
    var id: String?
    var name: String?
    var centerCity: String?
    var image: String?

    init(id: String?, name: String?, centerCity: String?, image: String?) {
        self.id = id
        self.name = name
        self.centerCity = centerCity
        self.image = image
    }
}
