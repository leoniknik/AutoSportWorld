//
//  ASWChangeUserInfoViewController.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 21.02.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWChangeUserInfoViewController: UIViewController {

    @IBOutlet weak var nameField: ASWLoginPasswordTextField!
    
    @IBOutlet weak var emailField: ASWLoginPasswordTextField!
    
    @IBOutlet weak var phoneField: ASWLoginPasswordTextField!
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        let user = ASWDatabaseManager().getUser() ?? ASWUserEntity()
        self.title = "Изменить личных данных"
        nameField.textField.text = user.login
        emailField.textField.text = user.email
        
    }
    
    func setupUI(){
        setupNameField()
        setupEmailField()
        setupPhoneField()
        ASWButtonManager.setupButton(button: button)
    }
    
    func setupNameField() {
        nameField.upperPlaceholderMode = true
        nameField.blackBackgroundStyle = false
        nameField.isPasswordField = false
        nameField.placeHolder = "Имя:"
        nameField.upperPlaceHolder = "Имя:"
//        nameField.textField.addTarget(self, action: #selector(nameDidChange(_:)), for: .editingChanged)
        nameField.setupUI()
    }
    
    func setupEmailField() {
        emailField.upperPlaceholderMode = true
        emailField.blackBackgroundStyle = false
        emailField.isPasswordField = false
        emailField.placeHolder = "Почта:"
        emailField.upperPlaceHolder = "Почта:"
        //        nameField.textField.addTarget(self, action: #selector(nameDidChange(_:)), for: .editingChanged)
        emailField.setupUI()
    }
    
    func setupPhoneField() {
        phoneField.upperPlaceholderMode = true
        phoneField.blackBackgroundStyle = false
        phoneField.isPasswordField = false
        phoneField.placeHolder = "Телефон:"
        phoneField.upperPlaceHolder = "Телефон:"
        //        nameField.textField.addTarget(self, action: #selector(nameDidChange(_:)), for: .editingChanged)
        phoneField.setupUI()
    }
    
    @IBAction func confirmChange(_ sender: Any) {
    }
    
    
}
