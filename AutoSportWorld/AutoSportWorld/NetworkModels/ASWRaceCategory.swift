//
//  ASWCategory.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 17.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWRaceCategory {
    var id: String?
    var name: String?
    var categoryClass: String? // "auto" или "moto"
    var imageUrl: String?
    var image: UIImage?
    var auto:Bool
    
    init(id: String?, name: String?, categoryClass: String?, image: String?) {
        self.id = id
        self.name = name
        self.categoryClass = categoryClass
        self.imageUrl = image
        
        self.auto = (categoryClass ?? "" == "auto")
    }
}
