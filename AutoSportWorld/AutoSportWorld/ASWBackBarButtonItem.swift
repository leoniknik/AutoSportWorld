//
//  BackBarButtonItem.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 07.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWBackBarButtonItem: UIBarButtonItem {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.image = UIImage.backward
        self.tintColor = UIColor.white
    }
    
}
