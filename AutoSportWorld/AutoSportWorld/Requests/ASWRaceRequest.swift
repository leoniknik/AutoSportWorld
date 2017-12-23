//
//  ASWRaceRequest.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 23.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation
import Alamofire

class ASWRaceRequest: ASWRequest {
    
    init(raceID: Int) {
        super.init()
        url = self.baseURL + "/races/\(raceID)"
    }
    
}
