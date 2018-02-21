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
    
    @IBOutlet weak var button: UIButton!
    
    var retryAction:(()->Bool)?
    
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
    }

    @IBAction func retryAction(_ sender: Any) {
        if retryAction?() ?? true {
            closeASWErrorView()
        }
    }
}
