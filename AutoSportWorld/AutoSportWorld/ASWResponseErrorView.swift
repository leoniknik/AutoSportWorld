//
//  ASWResponseErrorView.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 27.02.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

    class ASWResponseErrorView: UIView {
        

        @IBOutlet weak var titleLabel: UILabel!
        
        @IBOutlet weak var textLabel: UILabel!
        
        @IBOutlet weak var retryButton: UIButton!
        
        @IBOutlet weak var cancelButton: UIButton!
        
        @IBOutlet weak var okButton: UIButton!
        var retryAction:(()->Void)?
        var disableScreen:(()->Void)?
        var enableScreen:(()->Void)?
        override func awakeFromNib() {
            textLabel.textColor = UIColor.ASWColor.grey
            ASWButtonManager.setupButton(button: okButton)
            ASWButtonManager.setupButton(button: cancelButton)
            ASWButtonManager.setupButton(button: retryButton)
        }
                
        @IBAction func cancelAction(_ sender: Any) {
            enableScreen?()
            self.isHidden = true
        }
        
        @IBAction func okAction(_ sender: Any) {
            enableScreen?()
            self.isHidden = true
        }
        
        @IBAction func retryAction(_ sender: Any) {
            enableScreen?()
            retryAction?()
            self.isHidden = true
        }
}

