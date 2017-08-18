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
    }

}
