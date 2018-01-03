//
//  ASWProfileController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 17.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func temp(_ sender: UIButton) {
        let databaseManager = ASWDatabaseManager()
        databaseManager.createTestUser()
    }
    
}
