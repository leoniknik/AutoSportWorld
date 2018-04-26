//
//  ASWErrorView.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 20.02.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWErrorView: UIView {

    @IBOutlet var view: UIView!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    var retryAction:(()->Void)?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        label.textColor = UIColor.ASWColor.grey
        ASWButtonManager.setupButton(button: button)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("ASWErrorView", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor).isActive = true
        view.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
    }

    @IBAction func retryAction(_ sender: Any) {
        closeASWErrorView()
        retryAction?()
        

    }
}
