//
//  ASWCollectionItem.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 16.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation

class ASWCollectionItem {
    
    var id: Int = 0
    var searchString: String
    
    init(_ id: Int) {
        self.id = id
        searchString = "\(id)"
    }
    
    init(_ id: Int,_ string:String) {
        self.id = id
        self.searchString = string
    }
    
}
