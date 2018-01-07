//
//  ASWValidator.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 06.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

protocol ASWValidator{
    func isValid(_ string:String) -> Bool
    func format(_ string: String) -> String
}
