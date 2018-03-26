//
//  ASWSignupRequest.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 07.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
////

import Foundation
import Alamofire

class ASWSignupRequest: ASWRequest {
    
    init(email:String, password:String) {
        super.init()
        url = self.baseURL + "/auth/signup"
        parameters["email"] = email
        parameters["password"] = password
        parameters["send"] = ASWConstants.isDebug ? false : true
        parameters["plzdonthack"] = ASWCryptoManager.getHMAC(str: email).toHexString().uppercased()
        encoding = JSONEncoding.default

    }
}
