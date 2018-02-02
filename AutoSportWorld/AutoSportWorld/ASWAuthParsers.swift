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
    
    //var wrongEmail:Bool = false
    //var wrongPassword:Bool = false
    
    var email = ""
    var valid = false
    
    var refresh_token = ""
    var access_token = ""
    var expires_at = 0
    
    init(json: JSON) {
        
        print(json["message"].stringValue)
        let code = json["code"].stringValue
        valid = code == "ok"
        if valid {
            let sessionInfo = json["session"]
            refresh_token = sessionInfo["refresh_token"].stringValue
            access_token = sessionInfo["access_token"].stringValue
            expires_at = sessionInfo["expires_at"].intValue
        }else{
            let errors = json["errors"]
            email = errors[email].array?.first?.stringValue ?? "emailError"
        }
    }
}

class ASWValidateLoginParser {
    
    var valid = false
    
    var email:String = ""
    var password:String = ""
    var totalErrorString:String = ""
    
    init(json: JSON) {
        
        print(json["message"].stringValue)
        valid = json["valid"].boolValue
        if(valid){
            
        }else{
            
            let errors = json["errors"]
            
            for error in errors["email"].arrayValue{
                if (email != ""){
                    email += "\n"
                }
                email += error.stringValue
            }
            
            for error in errors["password"].arrayValue{
                if (password != ""){
                    password += "\n"
                }
                password += error.stringValue
            }
            
            totalErrorString = email + "\n" + password
        }
    }
}

class ASWLoginParser {
    
    //var wrongEmail:Bool = false
    //var wrongPassword:Bool = false
    
    var email = ""
    var valid = false
    
    var refresh_token = ""
    var access_token = ""
    var expires_at = 0
    
    init(json: JSON) {
        
        print(json["message"].stringValue)
        let code = json["code"].stringValue
        valid = code == "ok"
        if valid {
            let sessionInfo = json["session"]
            refresh_token = sessionInfo["refresh_token"].stringValue
            access_token = sessionInfo["access_token"].stringValue
            expires_at = sessionInfo["expires_at"].intValue
        }else{
            let errors = json["errors"]
            email = errors[email].array?.first?.stringValue ?? "emailError"
        }
    }
}


