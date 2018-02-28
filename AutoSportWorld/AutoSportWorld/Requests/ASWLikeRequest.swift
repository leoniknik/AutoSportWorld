//
//  ASWLikeRequest.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 26.02.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import Foundation

class ASWLiekRequest: ASWRequest {
    
    init(id: String) {
        super.init()
        url = self.baseURL + "/races/\(id)/like"
    }
    
}