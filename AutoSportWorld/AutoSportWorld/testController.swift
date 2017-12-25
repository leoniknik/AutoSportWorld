//
//  testController.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 16.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class testController: UIViewController {

    
    @IBOutlet weak var f1: ASWLoginPasswordTextField!
    
    @IBOutlet weak var f2: ASWLoginPasswordTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        f2.isPasswordField = true

        
    }


    
}
