//
//  ASWRegistrationViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 18.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ASWRegistrationViewController: UIViewController, UITextFieldDelegate {
    
    let emailValidator = ASWEmailValidator()
    let passwordValidator = ASWPasswordValidator()
    let nameValidator = ASWNameValidator()
    
    var emailField: SkyFloatingLabelTextField!
    var passwordField: SkyFloatingLabelTextField!
    var repeatPasswordField: SkyFloatingLabelTextField!
    var nameField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var repeatPasswordView: UIView!
    @IBOutlet weak var nameView: UIView!
    
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
        nameField = SkyFloatingLabelTextField(frame: nameView.frame)
        nameField.placeholder = "Введите свое имя"
        nameField.title = "Введите свое имя:"
        nameField.tintColor = UIColor.ASWColor.black
        nameField.selectedTitleColor = UIColor.ASWColor.grey
        
        nameField.addTarget(self, action: #selector(nameDidChange(_:)), for: .editingChanged)
        self.view.addSubview(nameField)
    }

    func setupEmailField() {
        emailField = SkyFloatingLabelTextField(frame: emailView.frame)
        emailField.placeholder = "Введите адрес эл. почты"
        emailField.title = "Введите адрес эл. почты:"
        emailField.tintColor = UIColor.ASWColor.black
        emailField.selectedTitleColor = UIColor.ASWColor.grey
        
        emailField.addTarget(self, action: #selector(emailDidChange(_:)), for: .editingChanged)
        self.view.addSubview(emailField)
    }
    
    func setupPasswordField() {
        passwordField = SkyFloatingLabelTextField(frame: passwordView.frame)
        passwordField.placeholder = "Придумайте пароль"
        passwordField.title = "Придумайте пароль:"
        passwordField.tintColor = UIColor.ASWColor.black
        passwordField.selectedTitleColor = UIColor.ASWColor.grey
        passwordField.addTarget(self, action: #selector(passwordDidChange(_:)), for: .editingChanged)
        
        self.view.addSubview(passwordField)
    }
    
    func setupRepeatPasswordField() {
        repeatPasswordField = SkyFloatingLabelTextField(frame: repeatPasswordView.frame)
        repeatPasswordField.placeholder = "Повторите пароль"
        repeatPasswordField.title = "Повторите пароль:"
        repeatPasswordField.tintColor = UIColor.ASWColor.black
        repeatPasswordField.selectedTitleColor = UIColor.ASWColor.grey
        repeatPasswordField.addTarget(self, action: #selector(repeatPasswordDidChange(_:)), for: .editingChanged)
        
        self.view.addSubview(repeatPasswordField)
    }
    
    
    func emailDidChange(_ sender: UITextField) {
        if var text = emailField.text {
            
            text = emailValidator.format(text)
            sender.text = text
            
            if !emailValidator.isValid(text) && !text.isEmpty {
                emailField.selectedLineColor = UIColor.red
                emailField.lineColor = UIColor.red
            }
            else {
                emailField.selectedLineColor = UIColor.black
                emailField.lineColor = UIColor.ASWColor.grey
            }
        }
    }
    
    
    func passwordDidChange(_ sender: UITextField) {
        if var text = passwordField.text {
            
            text = passwordValidator.format(text)
            sender.text = text
            
            if !passwordValidator.isValid(text) && !text.isEmpty {
                passwordField.selectedLineColor = UIColor.red
                passwordField.lineColor = UIColor.red
            }
            else {
                passwordField.selectedLineColor = UIColor.black
                passwordField.lineColor = UIColor.ASWColor.grey
            }
        }
    }
    
    
    func repeatPasswordDidChange(_ sender: UITextField) {
        if var text = repeatPasswordField.text {
            
            text = passwordValidator.format(text)
            sender.text = text
            
            if !passwordValidator.isValid(text) && !text.isEmpty {
                repeatPasswordField.selectedLineColor = UIColor.red
                repeatPasswordField.lineColor = UIColor.red
            }
            else {
                repeatPasswordField.selectedLineColor = UIColor.black
                repeatPasswordField.lineColor = UIColor.ASWColor.grey
            }
        }
    }
    
    
    func nameDidChange(_ sender: UITextField) {
        if var text = nameField.text {
            text = nameValidator.format(text)
            sender.text = text
        }
    }
    
    func isFormValid() -> Bool {
        guard passwordValidator.isValid(passwordField.text ?? "") else {
            return false
        }
        
        guard passwordValidator.isValid(repeatPasswordField.text ?? "") else {
            return false
        }
        
        if let name = nameField.text {
            guard name.characters.count != 0 else {
                return false
            }
        }
        else {
            return false
        }
        
        guard emailValidator.isValid(emailField.text ?? "") else {
            return false
        }
        
        guard passwordField.text! == repeatPasswordField.text! else {
            return false
        }
        
        return true
    }
    
}
