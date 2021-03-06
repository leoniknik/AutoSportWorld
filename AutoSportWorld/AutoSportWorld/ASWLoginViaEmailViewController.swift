//
//  ASWLoginViaEmailViewController.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 15.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit


class ASWLoginViaEmailViewController:ASWViewController, UITextFieldDelegate {
    
        override func viewDidLoad() {
            super.viewDidLoad()
            hideKeyboardWhenTappedAround()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        setupTransparentNavBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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

        
        //loginField.textField.text = "evtAlex@gmail.com"
        //passwordField.textField.text = "123123"
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
        loginButton.isEnabled = !passwordField.incorrectMod && !loginField.incorrectMod
    }
    
    func enterWaitMode(){
        ModalLoadingIndicator.show()
        loginButton.isEnabled = false
    }
    
    func leaveWaitMode(){
        DispatchQueue.main.async {
            [weak self] in
            ModalLoadingIndicator.hide()
            self?.updateFormValid()
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        var login = loginField.textField.text ?? ""
        var password = passwordField.textField.text ?? ""
        enterWaitMode()
        if(emailValidator.isValid(login)&&passwordValidator.isValid(password)){
            
            func sucsessFunc(parser:ASWLoginSucsessParser){
                leaveWaitMode()
                ASWDatabaseManager().loginUser(parser:parser)
                if parser.hasEmptyFilters {
                    var vc = ASWViewControllersManager.ChangeUserDataViewControllers.configAllFilters;
                    self.navigationController?.pushViewController(vc, animated: true)
                    return
                }
                
                getUserInfo()
            }
            

            func errorFunc(parser:ASWLoginErrorParser){
                presentAlert(errorParser: parser)
                leaveWaitMode()
                //leaveWaitModeWithError()
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
        
        func errorFunc(parser:ASWErrorParser){
            presentAlert(errorParser: parser)
            leaveWaitMode()
        }
        
        ASWNetworkManager.getUserInfo(sucsessFunc: sucsessFunc, errorFunc: errorFunc)
    }
    
    @IBAction func forgotPasswordPressed(_ sender: Any) {
        self.navigationController?.pushViewController(ASWViewControllersManager.ChangeUserDataViewControllers.resetPassword, animated: true)
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    
    
    
}

extension UIViewController {
    func setupTransparentNavBar() {
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
}
