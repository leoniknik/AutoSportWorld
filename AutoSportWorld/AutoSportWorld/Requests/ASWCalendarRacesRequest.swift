//
//  ASWCalendarRacesRequest.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 21.02.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import Foundation
import Alamofire

class ASWCalendarRacesRequest: ASWRequest {
    
    init(from: Date, to: Date) {
        super.init()
        let fromEpic = 1546250981//from.timeIntervalSince1970
        let toEpic =   1546250981//to.timeIntervalSince1970
        url = self.baseURL + "/calendar?from=\(Int(fromEpic))&to=\(Int(toEpic))"
        
    }
    
}
