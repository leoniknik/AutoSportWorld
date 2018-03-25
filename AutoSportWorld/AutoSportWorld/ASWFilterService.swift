//
//  ASWFilterService.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 01.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import Foundation

class ASWFiltersService {
    
    func isUserLogedIn() -> Bool {
        if ASWDatabaseManager().getUser() != nil {
            return true
        }
        return false
    }
    
}
