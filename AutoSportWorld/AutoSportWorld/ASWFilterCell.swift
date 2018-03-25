//
//  ASWFilterCell.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 01.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

protocol ASWFilterCellDelegate: class {
    func valueChanged(indexPath: IndexPath)
}

class ASWFilterCell: UITableViewCell {

    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var titleView: UILabel!
    
    weak var delegate: ASWFilterCellDelegate?
    
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        switchView.onTintColor = UIColor.ASWColor.darkBlue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func valueChanged(_ sender: UISwitch) {
        delegate?.valueChanged(indexPath: indexPath)
    }
    
    
}
