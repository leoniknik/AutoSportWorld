//
//  ASWNameValidator.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 19.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ASWNameValidator {
    
    func isValid(_ string: String) -> Bool {
        return string.count > 1
    }
    
    
    func format(_ string: String) -> String {
        var result = string
        if string.characters.count > 255 {
            result = string.substring(to: string.index(string.startIndex, offsetBy: 255))
        }
        return result
    }
    
}
