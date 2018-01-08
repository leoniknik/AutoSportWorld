//
//  ASWLoginViaEmailViewController.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 15.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

import SkyFloatingLabelTextField

class ASWLoginViaEmailViewController:UIViewController, UITextFieldDelegate {
    


        override func viewDidLayoutSubviews() {
            
            
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    func setupUI(){
        ASWButtonManager.setupLoginButton(button: loginButton)
        
        loginField.blackBackgroundStyle = true
        loginField.placeHolder = "Логин"
        passwordField.isPasswordField = false
        loginField.setupUI()
        
        passwordField.blackBackgroundStyle = true
        passwordField.isPasswordField = true
        passwordField.placeHolder = "Пароль"
        passwordField.setupUI()
        
        
        loginField.textField.text = "e@gmail.com"
        passwordField.textField.text = "rootroot"
    }

    let emailValidator = ASWEmailValidator()
    let passwordValidator = ASWPasswordValidator()
    
    @IBOutlet weak var loginField: ASWLoginPasswordTextField!
    
    @IBOutlet weak var passwordField: ASWLoginPasswordTextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBAction func loginPressed(_ sender: Any) {
        var login = loginField.textField.text ?? ""
        var password = passwordField.textField.text ?? ""
        if(emailValidator.isValid(login)&&passwordValidator.isValid(password)){
            
            func sucsessFunc(log:String,pas:String){
                ASWDatabaseManager().loginUser(login: log, password: pas)
            }
            
            func errorFunc(){
                
            }
            
            ASWNetworkManager.loginUser(email: login, password: password, sucsessFunc: sucsessFunc, errorFunc: errorFunc)
        }
    }
    
    @IBAction func forgotPasswordPressed(_ sender: Any) {
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
//
//
//
//
//
//
//
//
//
//
//
//
//
//    var emailField: SkyFloatingLabelTextField!
//    var passwordField: SkyFloatingLabelTextField!
//    var repeatPasswordField: SkyFloatingLabelTextField!
//    var nameField: SkyFloatingLabelTextField!
//
//    @IBOutlet weak var emailView: UIView!
//    @IBOutlet weak var passwordView: UIView!
//
//    @IBOutlet weak var emailTextField: UITextField!
//
//    @IBOutlet weak var passwordTextField: UITextField!
//
//    @IBOutlet weak var loginPlaceHolder: UILabel!
//
//    @IBOutlet weak var passwordPlaceHolder: UILabel!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//    override func viewDidLayoutSubviews() {
//        //setupForm()
//        setupUI()
//    }
//
////    func setupForm() {
////        setupPasswordField()
////        setupEmailField()
////
////    }
//
//
////    func setupEmailField() {
////        emailField = SkyFloatingLabelTextField(frame: emailView.frame)
////        emailField.placeholder = "Введите адрес эл. почты"
////        emailField.title = "Введите адрес эл. почты:"
////        emailField.tintColor = UIColor.ASWColor.black
////        emailField.selectedTitleColor = UIColor.ASWColor.grey
////
////        emailField.addTarget(self, action: #selector(emailDidChange(_:)), for: .editingChanged)
////        self.view.addSubview(emailField)
////    }
//
////    func setupPasswordField() {
////        passwordField = SkyFloatingLabelTextField(frame: passwordView.frame)
////        passwordField.placeholder = "Придумайте пароль"
////        passwordField.title = "Придумайте пароль:"
////        passwordField.tintColor = UIColor.ASWColor.black
////        passwordField.selectedTitleColor = UIColor.ASWColor.grey
////        passwordField.addTarget(self, action: #selector(passwordDidChange(_:)), for: .editingChanged)
////
////        self.view.addSubview(passwordField)
////    }
////
////    func emailDidChange(_ sender: UITextField) {
////        if var text = emailField.text {
////
////            text = emailValidator.format(text)
////            sender.text = text
////
////            if !emailValidator.isValid(text) && !text.isEmpty {
////                emailField.selectedLineColor = UIColor.red
////                emailField.lineColor = UIColor.red
////            }
////            else {
////                emailField.selectedLineColor = UIColor.black
////                emailField.lineColor = UIColor.ASWColor.grey
////            }
////        }
////    }
////
////
////    func passwordDidChange(_ sender: UITextField) {
////        if var text = passwordField.text {
////
////            text = passwordValidator.format(text)
////            sender.text = text
////
////            if !passwordValidator.isValid(text) && !text.isEmpty {
////                passwordField.selectedLineColor = UIColor.red
////                passwordField.lineColor = UIColor.red
////            }
////            else {
////                passwordField.selectedLineColor = UIColor.black
////                passwordField.lineColor = UIColor.ASWColor.grey
////            }
////        }
////    }
//
//    let passwordTag = 1
//    let emailTag = 2
//
//    func setupUI(){
//
//
//        let bottomEmailBorder = CALayer.init()
//
//        bottomEmailBorder.frame = CGRect.init(x: emailTextField.frame.origin.x, y: emailTextField.frame.size.height+emailTextField.frame.origin.y+1, width: emailTextField.frame.size.width, height: 1)
//
//        bottomEmailBorder.backgroundColor = UIColor.ASWColor.grey.cgColor
//        self.view.layer.addSublayer(bottomEmailBorder)
//
//        emailTextField.layer.borderWidth = 0
//        passwordTextField.layer.borderWidth = 0
//        emailTextField.delegate = self
//        passwordTextField.delegate = self
//        emailTextField.tag = emailTag
//        passwordTextField.tag = passwordTag
//
////        passwordField.addTarget(self, action: #selector(passwordDidChange(_:)), for: .editingDidBegin)
////        passwordField.addTarget(self, action: #selector(passwordDidChange(_:)), for: .editingDidEnd)
//    }
//
////    func passwordDidChange(_ sender: UITextField) {
////        if var text = passwordField.text {
////            if(text = ""){
////
////            }else{
////
////            }
////        }
////    }
//
//
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if(textField.tag == emailTag){
//            loginPlaceHolder.isHidden = true
//        }else{
//            passwordPlaceHolder.isHidden = true
//        }
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if(textField.text != ""){
//            if(textField.tag == emailTag){
//                loginPlaceHolder.isHidden = true
//            }else{
//                passwordPlaceHolder.isHidden = true
//            }
//        }else{
//            if(textField.tag == emailTag){
//                loginPlaceHolder.isHidden = false
//            }else{
//                passwordPlaceHolder.isHidden = false
//            }
//        }
//    }
//
//}
