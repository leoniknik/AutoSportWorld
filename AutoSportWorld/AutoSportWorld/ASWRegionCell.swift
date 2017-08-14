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
    
    let darkShadow = CALayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.ASWColor.grey.cgColor
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        
        //добавление слоя для затемнения
        darkShadow.backgroundColor = UIColor.black.cgColor
        darkShadow.opacity = 0.0
        darkShadow.frame = self.frame
        self.layer.addSublayer(darkShadow)
        
    }

}
