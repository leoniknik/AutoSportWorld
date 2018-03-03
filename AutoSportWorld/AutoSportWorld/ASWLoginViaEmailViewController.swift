//
//  ASWLoginViaEmailViewController.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 15.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

import SkyFloatingLabelTextField

class ASWLoginViaEmailViewController:UIViewControllerWithActivityMonitor, UITextFieldDelegate {
    
        override func viewDidLoad() {
            super.viewDidLoad()
            hideKeyboardWhenTappedAround()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    func setupUI(){
        ASWButtonManager.setupLoginButton(button: loginButton)
        
        
        loginField.blackBackgroundStyle = true
        loginField.placeHolder = "Логин"
        loginField.isPasswordField = false
        loginField.upperPlaceholderMode = false
        loginField.textField.addTarget(self, action: #selector(loginDidChange(_:)), for: .editingChanged)
        loginField.setupUI()
        
        passwordField.blackBackgroundStyle = true
        passwordField.isPasswordField = true
        passwordField.upperPlaceholderMode = false
        passwordField.placeHolder = "Пароль"
        passwordField.textField.addTarget(self, action: #selector(passwordDidChange(_:)), for: .editingChanged)
        passwordField.setupUI()

        
        loginField.textField.text = "testUser@gmail.com"
        passwordField.textField.text = "123123"
    }

    let emailValidator = ASWEmailValidator()
    let passwordValidator = ASWPasswordValidator()
    

    @IBOutlet weak var loginField: ASWLoginPasswordTextField!
    
    @IBOutlet weak var passwordField: ASWLoginPasswordTextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    @objc func loginDidChange(_ sender: UITextField) {
        if var text = loginField.textField.text {
            text = emailValidator.format(text)
            sender.text = text
            loginField.incorrectMod = !(emailValidator.isValid(text) && !text.isEmpty)
        }
        updateFormValid()
    }
    
    
    @objc func passwordDidChange(_ sender: UITextField) {
        if var text = passwordField.textField.text {
            text = passwordValidator.format(text)
            sender.text = text
            passwordField.incorrectMod =  !(passwordValidator.isValid(text) && !text.isEmpty)
        }
        updateFormValid()
    }
    
    func updateFormValid(){
        var bool = !passwordField.incorrectMod && !loginField.incorrectMod
        loginButton.isEnabled = !passwordField.incorrectMod && !loginField.incorrectMod
    }
    
    func enterWaitMode(){
        activityIndicator?.startAnimating()
        loginButton.isEnabled = false
    }
    
    func leaveWaitMode(){
        DispatchQueue.main.async {
            [weak self] in
            self?.activityIndicator?.stopAnimating()
            self?.updateFormValid()
        }
    }
    
    func leaveWaitModeWithError(){
        leaveWaitMode()
        DispatchQueue.main.async {
            [weak self] in
            let alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self?.present(alert, animated: true, completion: { [weak self] in print("fr")})
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        var login = loginField.textField.text ?? ""
        var password = passwordField.textField.text ?? ""
        enterWaitMode()
        if(emailValidator.isValid(login)&&passwordValidator.isValid(password)){
            
            func sucsessFunc(parser:ASWLoginSucsessParser){
                ASWDatabaseManager().loginUser(parser:parser)
                getUserInfo()
            }
            
            func errorFunc(){
//                UIAlertController(title: "xui", message: "xui", preferredStyle: .alert)
                leaveWaitModeWithError()
            }
            
            ASWNetworkManager.loginUser(email: login, password: password, sucsessFunc: sucsessFunc, errorFunc: errorFunc)
        }
    }
    
    func getUserInfo(){
        
        func sucsessFunc(parser:ASWUserInfoGetParser){
            ASWDatabaseManager().setUserInfo(parser:parser)
            leaveWaitMode()
            DispatchQueue.main.async {
                self.openMainStoryboard()
            }
        }
        
        func errorFunc(){
            leaveWaitModeWithError()
        }
        
        ASWNetworkManager.getUserInfo(sucsessFunc: sucsessFunc, errorFunc: errorFunc)
    }
    
    @IBAction func forgotPasswordPressed(_ sender: Any) {
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
