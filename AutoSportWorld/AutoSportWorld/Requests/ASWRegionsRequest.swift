//
//  ASWRegionsRequest.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 23.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation
import Alamofire

class ASWRegionsRequest: ASWRequest {
    
    override init() {
        super.init()
        url = self.baseURL + "/regions"
    }
    
}
