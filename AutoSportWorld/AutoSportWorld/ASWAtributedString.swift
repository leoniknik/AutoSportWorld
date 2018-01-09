//
//  ASWAtributedString.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 07.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWAtributedString{
    
    static func getAtributedString(begining:String,bold:String, end:String, color:UIColor)->NSMutableAttributedString{
        
        // Define attributes
        var labelFont = UIFont.boldSystemFont(ofSize: 16.0)
        var attributes :Dictionary = [NSAttributedStringKey.font : labelFont,NSAttributedStringKey.foregroundColor : UIColor.ASWColor.black] as [NSAttributedStringKey : Any]
        
        // Create attributed string
        var attrString2 = NSMutableAttributedString(string: bold, attributes:attributes)
        
        labelFont = UIFont.systemFont(ofSize: 16.0)
        attributes = [NSAttributedStringKey.font : labelFont,NSAttributedStringKey.foregroundColor : color] as [NSAttributedStringKey : Any]
        
        // Create attributed string
        var attrString1 = NSMutableAttributedString(string: begining, attributes:attributes)
        var attrString3 = NSMutableAttributedString(string: end, attributes:attributes)
        
        attrString1.append(attrString2)
        attrString1.append(attrString3)
        return attrString1
    }
    
}
