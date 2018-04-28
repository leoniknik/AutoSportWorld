//
//  RegionCell.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 12.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWRegionCell: UICollectionViewCell {
    
    @IBOutlet weak var indexLabel: UILabel!
    
    @IBOutlet weak var regionNumber: UILabel!
    
    @IBOutlet weak var name: UILabel!
    var darkShadow = CALayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.ASWColor.grey.cgColor
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        self.indexLabel.isHidden = true
        self.indexLabel.backgroundColor = UIColor.white;
        
        darkShadow.backgroundColor = UIColor.black.cgColor
        darkShadow.opacity = 0.3
        
        self.indexLabel.layer.cornerRadius = 11
        self.indexLabel.clipsToBounds = true
    }
    
    func selectCell(indexPath:IndexPath) {
        darkShadow.frame = self.contentView.frame
        self.contentView.layer.insertSublayer(darkShadow, below: self.indexLabel.layer)
        self.indexLabel.text = "\(indexPath.item+1)"
        self.indexLabel.isHidden = false
    }
    
    func deselectCell() {
        darkShadow.removeFromSuperlayer()
        self.indexLabel.isHidden = true
    }

}
