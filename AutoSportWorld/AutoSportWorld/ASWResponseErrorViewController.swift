//
//  ASWResponseErrorView.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 27.02.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit
protocol ASWResponseErrorViewControllerDelegate{
    func okAction()
    func cancelAction()
    func retryAction()
}

class ASWResponseErrorViewController: UIViewController {
        
    @IBOutlet weak var contentView: UIView!
    
        @IBOutlet weak var titleLabel: UILabel!
        
        @IBOutlet weak var textLabel: UILabel!
        
        @IBOutlet weak var retryButton: UIButton!
        
        @IBOutlet weak var cancelButton: UIButton!
        
        @IBOutlet weak var okButton: UIButton!
        
        var delegate:ASWResponseErrorViewControllerDelegate?
        var titleText: String = ""
        var bodyText: String = ""
        var okMode:Bool = false
        
        init() {
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            addBackButton()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    func setupUI(){
        textLabel.textColor = UIColor.ASWColor.grey
        titleLabel.text = titleText
        textLabel.text = bodyText
        if okMode {
            okButton.isHidden = false
        } else {
            okButton.isHidden = true
        }
        ASWButtonManager.setupButton(button: okButton)
        ASWButtonManager.setupButton(button: cancelButton)
        ASWButtonManager.setupButton(button: retryButton)
        
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
    }
                
        @IBAction func cancelAction(_ sender: Any) {
            delegate?.cancelAction()
            //enableScreen?()
            //self.isHidden = true
        }
        
        @IBAction func okAction(_ sender: Any) {
            delegate?.okAction()
            //enableScreen?()
            //self.isHidden = true
        }
        
        @IBAction func retryAction(_ sender: Any) {
            delegate?.retryAction()
            //enableScreen?()
            //retryAction?()
            //self.isHidden = true
        }
}

