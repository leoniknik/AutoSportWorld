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
    
    override init() {
        super.init()
        url = self.baseURL + "/preferences?filters=true"
    }
    
}
