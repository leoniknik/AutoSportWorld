//
//  ASWResetPasswordRequest.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 16.03.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import Foundation
import Alamofire

class ASWResetPasswordRequest: ASWRequest {
    
    init(email:String) {
        super.init()
        parameters["email"] = email
        parameters["send"] = ASWConstants.isDebug ? false : true
        url = baseURL +  "/auth/password/reset"
        encoding = JSONEncoding.default
    }
    
}
