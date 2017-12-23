//
//  ASWCategoryRequest.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 23.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation
import Alamofire

class ASWCategoriesRequest: ASWRequest {
    
    init(categoryClass: String) {
        super.init()
        url = self.baseURL + "/categories"
        parameters["class"] = categoryClass
    }
    
}
