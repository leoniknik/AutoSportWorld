//
//  ASWLoginParser.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 07.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import Foundation
import SwiftyJSON

class ASWLoginSucsessParser {

    init(json: JSON) {
        switch json["code"].string ?? "#" {
        case "":
            break
        case "1":
            break
        default:
            break
        }
    }
}

class ASWLoginErrorParser {
    
    var wrongEmail:Bool = false
    var wrongPassword:Bool = false

    init(json: JSON) {
       
        print(json["message"].stringValue)

        switch json["message"].stringValue {
        case "wrong email":
            wrongEmail = true
            break
        case "1":
            break
        default:
            break
        }
    }
}

class ASWSignupErrorParser {
    
    var emailHasAlreadyBeenTaken:Bool = false
    var wrongPassword:Bool = false
    
    init(json: JSON) {
        
        print(json["message"].stringValue)
        
        switch json["message"].stringValue {
        case "{\"email\":[[\"has already been taken\"]]}":
            emailHasAlreadyBeenTaken = true
            break
        case "1":
            break
        default:
            break
        }
    }
}

class ASWSignupParser {
    
    var wrongEmail:Bool = false
    var wrongPassword:Bool = false
    
    init(json: JSON) {
        
        print(json["message"].stringValue)
        
        switch json["message"].stringValue {
        case "wrong email":
            wrongEmail = true
            break
        case "1":
            break
        default:
            break
        }
    }
}
