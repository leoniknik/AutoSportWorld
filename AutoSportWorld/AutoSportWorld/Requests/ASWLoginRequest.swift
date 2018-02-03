//
//  ASWLoginRequest.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 07.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import Foundation
import Alamofire

class ASWLoginRequest: ASWRequest {
    
    init(email:String, password:String) {
        super.init()
        url = self.baseURL + "/auth/login"
        parameters["email"] = email
        parameters["password"] = password
    }
    
}
