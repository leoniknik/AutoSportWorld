//
//  ASWEmailValidator.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 19.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit


class ASWEmailValidator {

    func isValid(_ string:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: string)
    }
    
    
    func format(_ string: String) -> String {
        var result = string
        if string.characters.count > 255 {
            result = string.substring(to: string.index(string.startIndex, offsetBy: 255))
        }
        return result
    }
    
}
