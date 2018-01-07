//
//  ASWPasswordValidator.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 19.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ASWPasswordValidator : ASWValidator {
    
    func isValid(_ string:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z]{6,16}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: string)
    }
    
    
    func format(_ string: String) -> String {
        var result = string
        if string.characters.count > 16 {
            result = string.substring(to: string.index(string.startIndex, offsetBy: 16))
        }
        return result
    }
    
}
