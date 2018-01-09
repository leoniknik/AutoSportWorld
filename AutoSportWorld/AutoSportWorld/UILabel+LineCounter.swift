//
//  UILabel+LineCounter.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 07.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

extension UILabel {
    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }
}
