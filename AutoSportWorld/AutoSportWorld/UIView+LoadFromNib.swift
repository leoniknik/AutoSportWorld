//
//  UIView+LoadFromNib.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 28.02.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
