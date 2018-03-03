//
//  ASWUserInfoSendRequest.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 26.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import Foundation
import Alamofire

class ASWUserInfoSendRequest: ASWRequest {
    
    init(regions:[String],categories:[String],watch:Bool,join:Bool) {
        super.init()
        url = self.baseURL + "/preferences"
        parameters["region_ids"] = regions
        parameters["category_ids"] = categories
        parameters["can_watch"] = watch
        parameters["can_join"] = join
        encoding = JSONEncoding.default
    }
    
}
