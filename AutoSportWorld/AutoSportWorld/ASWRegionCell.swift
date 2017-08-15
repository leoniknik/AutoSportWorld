//
//  RegionCell.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 12.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWRegionCell: UICollectionViewCell {
    
    @IBOutlet weak var checkmark: UIImageView!
    @IBOutlet weak var regionNumber: UILabel!
    
    var darkShadow = CALayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.ASWColor.grey.cgColor
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        self.checkmark.isHidden = true
    }
    
    func selectCell() {
        darkShadow.backgroundColor = UIColor.black.cgColor
        darkShadow.opacity = 0.3
        darkShadow.frame = self.contentView.frame
        self.layer.addSublayer(darkShadow)
        self.checkmark.isHidden = false
    }
    
    func deselectCell() {
        darkShadow.removeFromSuperlayer()
        self.checkmark.isHidden = true
    }

}
