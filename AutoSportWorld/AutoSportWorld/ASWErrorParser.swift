//
//  ASWErrorParser.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 27.02.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ASWErrorParser {
    var hasInternetError: Bool = false
    var hasServerError: Bool = false
    var hasUncnownError: Bool = false
    var errors: [String] = []
    var errorString = ""
    
    init(error:Error,json: JSON) {
        
        if error is AFError{
            if let afError = error as? AFError {
                let code = afError.responseCode ?? 0
                if code == 401{
                    
                } else if code == 404 {
                    
                } else {
                    hasUncnownError = true
                }
            }
        } else if error is NSError {
            if let nsError = error as? NSError {
                if nsError.code == -1009 {
                    hasInternetError = true
                }
            }
        }
    }
}
