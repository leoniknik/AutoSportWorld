//
//  ASWValidateLoginRequest.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 26.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import Foundation
import Alamofire

class ASWValidateLoginRequest: ASWRequest {
    
    init(email:String, password:String) {
        super.init()
        url = self.baseURL + "/auth/validate_signup"
        parameters["email"] = email
        parameters["password"] = password
    }
    
}
