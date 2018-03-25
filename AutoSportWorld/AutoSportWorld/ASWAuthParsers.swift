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
    var email:String = ""
    var password:String = ""
    
    var sessionInfoParser:ASWSessionInfoParser
    
    init(json: JSON) {
        sessionInfoParser = ASWSessionInfoParser(json: json)
    }
}

class ASWLoginErrorParser:ASWErrorParser {

    override init(error: Error,json: JSON) {
        super.init(error: error, json: json)
        print(json["message"].stringValue)
        switch json["message"].stringValue {
        case "wrong email":
            errors.append("Неверный email")
            errorString += "Неверный email"
            break
        case "":
            break
        default:
            break
        }
    }
}

class ASWSignupErrorParser:ASWErrorParser {
    
    var emailHasAlreadyBeenTaken:Bool = false
    var wrongPassword:Bool = false
    
    override init(error: Error,json: JSON) {
        super.init(error: error, json: json)
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
    var errorString = ""
    var valid = false
    
    var sessionInfoParser:ASWSessionInfoParser?
    
    init(json: JSON) {
        
        print(json["message"].stringValue)
        let code = json["code"].stringValue
        valid = code == "ok"
        if valid {
            let sessionInfo = json["session"]
            sessionInfoParser = ASWSessionInfoParser(json: sessionInfo)
        }else{
            let errors = json["errors"]
            errorString = errors["email"].array?.first?.stringValue ?? "Неизвестная ошибка"
            if let pasErr = errors["password"].array?.first?.stringValue{
                errorString += "\n" + pasErr
            }
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

class ASWChangePasswordParser{
    var isOK = false
    var errorMessage = "Неизвестная ошибка"
    
    var sessionInfoParser:ASWSessionInfoParser?
    
    init(json: JSON) {
        var code = json["code"].stringValue
        if code == "ok"{
            isOK = true
            let sessionInfo = json["session"]
            sessionInfoParser = ASWSessionInfoParser(json: sessionInfo)
        } else if code == "validation"{
            errorMessage = json["message"].stringValue
        } else if code == "wrong_password"{
            errorMessage = json["message"].stringValue
        } else{
            errorMessage = "Неизвестная ошибка"
        }
    }
    
}

class ASWSessionInfoParser{
    var refresh_token = ""
    var access_token = ""
    var expires_at = 0
    init(json: JSON) {
        refresh_token = json["refresh_token"].stringValue
        access_token = json["access_token"].stringValue
        expires_at = json["expires_at"].intValue
    }
}




