//
//  ASWLikeRequest.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 26.02.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import Foundation

class ASWLikeRequest: ASWRequest {
    
    init(id: String) {
        super.init()
        url = self.baseURL + "/races/\(id)/like"
    }
    
}

class ASWUnlikeRequest: ASWRequest {
    
    init(id: String) {
        super.init()
        url = self.baseURL + "/races/\(id)/unlike"
    }
    
}
