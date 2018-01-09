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
    var codes: String?

    init(id: String?, name: String?, centerCity: String?, image: String?, codes:[Int]) {
        self.id = id
        self.name = name
        self.centerCity = centerCity
        self.image = image
        var codeString = ""
        for code in codes{
            if codeString == ""{
                codeString += "\(code)"
            }else{
                codeString += "/\(code)"
            }
        }
        self.codes = codeString
    }
}
