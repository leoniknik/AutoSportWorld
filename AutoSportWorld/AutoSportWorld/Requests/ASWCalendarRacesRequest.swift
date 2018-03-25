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
        let fromEpic = from.timeIntervalSince1970
        let toEpic =   to.timeIntervalSince1970
        url = self.baseURL + "/calendar?from=\(Int(fromEpic))&to=\(Int(toEpic))&preferences=regions, categories,can_join,can_watch"
        url = self.baseURL + "/calendar?from=\(Int(fromEpic))&to=\(Int(toEpic))"//&preferences=regions, categories,can_join,can_watch"
        
    }
    
}
