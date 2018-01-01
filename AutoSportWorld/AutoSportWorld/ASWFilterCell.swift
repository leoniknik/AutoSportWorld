//
//  ASWFilterCell.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 01.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWFilterCell: UITableViewCell {

    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var titleView: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        switchView.onTintColor = UIColor.ASWColor.yellow
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
