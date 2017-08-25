//
//  ASWAnimationManager.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 25.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWAnimationManager {
    
    func bouncedAnimation(forImageView imageView: UIImageView) {
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            imageView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        }, completion: nil)
        UIView.animate(withDuration: 0.2, delay: 0.2, animations: {() -> Void in
            imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: nil)
        UIView.animate(withDuration: 0.2, delay: 0.4, animations: {() -> Void in
            imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: nil)
        UIView.animate(withDuration: 0.2, delay: 0.6, animations: {() -> Void in
            imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    
}

