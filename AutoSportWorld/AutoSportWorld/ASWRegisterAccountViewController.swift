//
//  ASWRegisterAccountViewController.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 04.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

//
//  ASWRegistrationViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 18.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

protocol ASWRegisterAccountViewControllerDelegate{
    func updateUserLoginInfo(valid:Bool,login:String,email:String,password:String)
}

class ASWRegisterAccountViewController: UIViewController, UITextFieldDelegate {
    
    
    let emailValidator = ASWEmailValidator()
    let passwordValidator = ASWPasswordValidator()
    let nameValidator = ASWNameValidator()
    
    var delegate: ASWRegisterAccountViewControllerDelegate?
    
    var email = ""
    var password = ""
    var name = ""
    
    
    @IBOutlet weak var emailField: ASWLoginPasswordTextField!
    
    @IBOutlet weak var passwordField: ASWLoginPasswordTextField!
    
    @IBOutlet weak var repeatPasswordField: ASWLoginPasswordTextField!
    
    @IBOutlet weak var nameField: ASWLoginPasswordTextField!
    
    
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        setupForm()
    }
    
    func setupForm() {
        setupNameField()
        setupEmailField()
        setupPasswordField()
        setupRepeatPasswordField()
    }
    
    func setupNameField() {
        nameField.upperPlaceholderMode = true
        nameField.blackBackgroundStyle = false
        nameField.placeHolder = "Введите имя:"
        nameField.textField.addTarget(self, action: #selector(nameDidChange(_:)), for: .editingChanged)
        nameField.setupUI()
    }
    
    func setupEmailField() {
        emailField.upperPlaceholderMode = true
        emailField.blackBackgroundStyle = false
        emailField.placeHolder = "Введите адрес эл. почты:"
        emailField.textField.addTarget(self, action: #selector(emailDidChange(_:)), for: .editingChanged)
        emailField.setupUI()
    }
    
    func setupPasswordField() {
        passwordField.upperPlaceholderMode = true
        passwordField.blackBackgroundStyle = false
        passwordField.placeHolder = "Придумайте пароль (мин. 6 знаков):"
        passwordField.textField.addTarget(self, action: #selector(passwordDidChange(_:)), for: .editingChanged)
        passwordField.setupUI()
    }
    
    func setupRepeatPasswordField() {
        repeatPasswordField.upperPlaceholderMode = true
        repeatPasswordField.blackBackgroundStyle = false
        repeatPasswordField.placeHolder = "Повторите пароль:"
        repeatPasswordField.textField.addTarget(self, action: #selector(repeatPasswordDidChange(_:)), for: .editingChanged)
        repeatPasswordField.setupUI()
    }
    
    
    @objc func emailDidChange(_ sender: UITextField) {
        if var text = emailField.textField.text {
            text = emailValidator.format(text)
            sender.text = text
            email = text
            emailField.incorrectMod = (!emailValidator.isValid(text) && !text.isEmpty)
        }
        delegate?.updateUserLoginInfo(valid: isFormValid(), login: name, email: email, password: password)
    }
    
    
    @objc func passwordDidChange(_ sender: UITextField) {
        if var text = passwordField.textField.text {
            text = passwordValidator.format(text)
            sender.text = text
            password = text
            passwordField.incorrectMod =  !passwordValidator.isValid(text) && !text.isEmpty
        }
        delegate?.updateUserLoginInfo(valid: isFormValid(), login: name, email: email, password: password)
    }
    
    
    @objc func repeatPasswordDidChange(_ sender: UITextField) {
        if var text = repeatPasswordField.textField.text {

            text = passwordValidator.format(text)
            sender.text = text

            repeatPasswordField.incorrectMod = !passwordValidator.isValid(text) && !text.isEmpty && text == passwordField.textField.text
        }
        delegate?.updateUserLoginInfo(valid: isFormValid(), login: name, email: email, password: password)
    }
    
    
    @objc func nameDidChange(_ sender: UITextField) {
        if var text = nameField.textField.text {
            name = text
            text = nameValidator.format(text)
            sender.text = text
            nameField.incorrectMod = !nameValidator.isValid(text)
        }
        delegate?.updateUserLoginInfo(valid: isFormValid(), login: name, email: email, password: password)
    }
    
    func fillFormFromUserModel(){
        nameField.textField.text = name
        emailField.textField.text = email
        repeatPasswordField.textField.text = password
        passwordField.textField.text = password
    }
    
    func isFormValid() -> Bool {
        guard passwordValidator.isValid(passwordField.textField.text ?? "") else {
            return false
        }

        guard passwordValidator.isValid(repeatPasswordField.textField.text ?? "") else {
            return false
        }

        if let nameData = nameField.textField.text {
            guard nameData.count != 0 else {
                return false
            }
        }
        else {
            return false
        }

        guard emailValidator.isValid(emailField.textField.text ?? "") else {
            return false
        }

        guard passwordField.textField.text ?? "-1" == repeatPasswordField.textField.text ?? "1" else {
            return false
        }

        return true
    }
    
//    @IBAction func act(_ sender: Any) {
//        fillFormFromUserModel()
//    }
    
}



//func setupNameField() {
//    nameField = SkyFloatingLabelTextField(frame: nameView.frame)
//    nameField.placeholder = "Введите свое имя"
//    nameField.title = "Введите свое имя:"
//    nameField.tintColor = UIColor.ASWColor.black
//    nameField.selectedTitleColor = UIColor.ASWColor.grey
//
//    nameField.addTarget(self, action: #selector(nameDidChange(_:)), for: .editingChanged)
//    self.view.addSubview(nameField)
//}
//
//func setupEmailField() {
//    emailField = SkyFloatingLabelTextField(frame: emailView.frame)
//    emailField.placeholder = "Введите адрес эл. почты"
//    emailField.title = "Введите адрес эл. почты:"
//    emailField.tintColor = UIColor.ASWColor.black
//    emailField.selectedTitleColor = UIColor.ASWColor.grey
//
//    emailField.addTarget(self, action: #selector(emailDidChange(_:)), for: .editingChanged)
//    self.view.addSubview(emailField)
//}
//
//func setupPasswordField() {
//    passwordField = SkyFloatingLabelTextField(frame: passwordView.frame)
//    passwordField.placeholder = "Придумайте пароль"
//    passwordField.title = "Придумайте пароль:"
//    passwordField.tintColor = UIColor.ASWColor.black
//    passwordField.selectedTitleColor = UIColor.ASWColor.grey
//    passwordField.addTarget(self, action: #selector(passwordDidChange(_:)), for: .editingChanged)
//
//    self.view.addSubview(passwordField)
//}
//
//func setupRepeatPasswordField() {
//    repeatPasswordField = SkyFloatingLabelTextField(frame: repeatPasswordView.frame)
//    repeatPasswordField.placeholder = "Повторите пароль"
//    repeatPasswordField.title = "Повторите пароль:"
//    repeatPasswordField.tintColor = UIColor.ASWColor.black
//    repeatPasswordField.selectedTitleColor = UIColor.ASWColor.grey
//    repeatPasswordField.addTarget(self, action: #selector(repeatPasswordDidChange(_:)), for: .editingChanged)
//
//    self.view.addSubview(repeatPasswordField)
//}
//

