//
//  ASWRaceTypeCell.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 14/08/2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWRaceTypeCell: UICollectionViewCell {

    
    
    @IBOutlet weak var checkmark: UIImageView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.ASWColor.grey.cgColor
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        self.label.layer.cornerRadius = 10.0
        self.label.clipsToBounds = true
        
        self.checkmark.isHidden = true
        
        darkShadow.backgroundColor = UIColor.black.cgColor
        darkShadow.opacity = 0.3
        
        self.checkmark.backgroundColor = UIColor.clear
        self.checkmark.layer.opacity = 1.0
    }
    
    var darkShadow = CALayer()
    
    func selectCell() {
        darkShadow.frame = self.contentView.frame
        self.contentView.layer.insertSublayer(darkShadow, below: self.checkmark.layer)
        self.checkmark.isHidden = false
    }
    
    func deselectCell() {
        darkShadow.removeFromSuperlayer()
        self.checkmark.isHidden = true
    }

}
