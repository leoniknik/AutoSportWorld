//
//  ASWChangePasswordRequest.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 16.03.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import Foundation
import Alamofire

class ASWChangePasswordRequest: ASWRequest {
    
    init(oldPass:String, newPass:String) {
        super.init()
        url = self.baseURL + "/auth/signup"
        parameters["old"] = oldPass
        parameters["new"] = newPass
        encoding = JSONEncoding.default
    }
    
}
