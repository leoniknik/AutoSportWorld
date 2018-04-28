//
//  ASWRaceTypeCell.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 14/08/2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWRaceTypeCell: UICollectionViewCell {

    
    
    
    @IBOutlet weak var indexLabel: UILabel!
    
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
        
        self.indexLabel.isHidden = true
        self.indexLabel.backgroundColor = UIColor.ASWColor.yellowSelection
        
        darkShadow.backgroundColor = UIColor.black.cgColor
        darkShadow.opacity = 0.3
        
        self.indexLabel.layer.cornerRadius = 11
        self.indexLabel.clipsToBounds = true
        self.indexLabel.textColor = UIColor.white
    }
    
    var darkShadow = CALayer()
    
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
