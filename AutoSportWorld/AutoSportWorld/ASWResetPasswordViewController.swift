//
//  ASWResetPasswordViewController.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 25.03.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWResetPasswordViewController: ASWViewController {

    @IBOutlet weak var emailField: ASWLoginPasswordTextField!
    
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        addBackButton()
        setupBlackOpaqueNavBar()
        super.viewDidLoad()
       
    ASWButtonManager.setupLoginButton(button: resetButton)
        resetButton.isEnabled = false
        
    }

    
    @IBAction func resetPassword(_ sender: Any) {
        func success(parser: ASWResetPasswordParser){
            if parser.isOK{
                presentOKAlert("Успех", "Пароль сброшен. На эл.адрес выслана ссылка для создания нового пароля "){
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                presentAlert("Ошибка", parser.errorMessage)
            }
            
        }
        
        func error(parser: ASWErrorParser){
            presentAlert(errorParser: parser)
                self.resetButton.isEnabled = true
            
        }
        
        resetButton.isEnabled = false
        ASWNetworkManager.resetPassword(email: email, sucsessFunc: success, errorFunc: error)
        
    }
    
    let emailValidator = ASWEmailValidator()
    var email = ""
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBlackOpaqueNavBar()
        setupForm()
    }
    
    func setupForm() {
        setupEmailField()
    }
    
    func setupEmailField() {
        emailField.upperPlaceholderMode = true
        emailField.blackBackgroundStyle = true
        emailField.isPasswordField = false
        emailField.placeHolder = "Введите адрес эл. почты:"
        emailField.upperPlaceHolder = "Введите адрес эл. почты:"
        emailField.textField.addTarget(self, action: #selector(emailDidChange(_:)), for: .editingChanged)
        emailField.setupUI()
    }
    
    @objc func emailDidChange(_ sender: UITextField) {
        if var text = emailField.textField.text {
            text = emailValidator.format(text)
            sender.text = text
            email = text
            emailField.incorrectMod = !(emailValidator.isValid(text) && !text.isEmpty)
            resetButton.isEnabled = (emailValidator.isValid(text) && !text.isEmpty)
        }
    }

}
