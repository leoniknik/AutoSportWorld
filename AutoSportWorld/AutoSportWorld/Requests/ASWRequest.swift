//
//  ASWUrls.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 17.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation
import Alamofire

class ASWRequest {

    var baseURL = ASWConstants.isDebug ?  "http://34.214.102.142:4000/api" : "http://34.214.102.142:4001/api"
    var parameters: Parameters = [:]
    var url: String = ""
    var encoding: ParameterEncoding = URLEncoding.default
}

