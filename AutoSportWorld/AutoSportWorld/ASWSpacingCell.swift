//
//  ASWSpacingCell.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 12.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWSpacingCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.ASWColor.greyBackground
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
