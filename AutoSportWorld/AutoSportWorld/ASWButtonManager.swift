//
//  ASWButtonManager.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 06.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWButtonManager{
    static func setupButton(button:UIButton){
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        var image = UIImage.from(9, 51, 142)
        button.setBackgroundImage(image, for: .normal)
        
        image = UIImage.from(1, 25, 62)
        button.setBackgroundImage(image, for: .selected)
        
        image = UIImage.from(234, 234, 234)
        button.setBackgroundImage(image, for: .disabled)
        
    }
    
    static func setupVKButton(button:UIButton){
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        var image = UIImage.from(37, 98, 147)
        button.setBackgroundImage(image, for: .normal)
        
        image = UIImage.from(19, 45, 64)
        button.setBackgroundImage(image, for: .selected)
        
        image = UIImage.from(234, 234, 234)
        button.setBackgroundImage(image, for: .disabled)
        
    }
    
    static func setupLoginButton(button:UIButton){
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        var image = UIImage.from(255,255, 255)
        button.setBackgroundImage(image, for: .normal)
        
        image = UIImage.from(108, 108, 108)
        button.setBackgroundImage(image, for: .selected)
        
        image = UIImage.from(234, 234, 234)
        button.setBackgroundImage(image, for: .disabled)
        
    }
}

