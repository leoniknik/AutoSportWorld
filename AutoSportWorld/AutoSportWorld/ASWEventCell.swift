//
//  EventCell.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 11.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

protocol ASWEventCellDelegate: class {
    func likeEventTapped(id: Int)
    func bookmarkEventTapped(id: Int)
}

class ASWEventCell: UITableViewCell {
    
    weak var delegate: ASWEventCellDelegate?
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var whereLabel: UILabel!
    @IBOutlet weak var joinLabel: UILabel!
    @IBOutlet weak var watchLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var whereImage: UIImageView!
    @IBOutlet weak var joinImage: UIImageView!
    @IBOutlet weak var watchImage: UIImageView!
    @IBOutlet weak var momeyImage: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    var id: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func likeEvent(_ sender: UIButton) {
        delegate?.likeEventTapped(id: self.id)
    }
    
    @IBAction func bookmarkEvent(_ sender: UIButton) {
        delegate?.bookmarkEventTapped(id: self.id)
    }
    
}







