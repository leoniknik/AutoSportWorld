//
//  ASWUserInfoGetRequest.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 26.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import Foundation
import Alamofire

class ASWUserInfoGetRequest: ASWRequest {
    
    init(email:String, password:String) {
        super.init()
        url = self.baseURL + "/api/preferences?filters=1"
    }
    
}
