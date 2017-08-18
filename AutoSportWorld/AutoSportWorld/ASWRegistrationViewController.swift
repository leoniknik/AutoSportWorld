//
//  ASWRegistrationViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 18.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit
import SwiftValidator

class ASWRegistrationViewController: UIViewController {

    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupValidator()
    }
    
    func setupValidator() {
//        validator.registerField(fullNameTextField, rules: [RequiredRule(), FullNameRule()])
//        
//        // You can pass in error labels with your rules
//        // You can pass in custom error messages to regex rules (such as ZipCodeRule and EmailRule)
//        validator.registerField(emailTextField, errorLabel: emailErrorLabel, rules: [RequiredRule(), EmailRule(message: "Invalid email")])
//        
//        // You can validate against other fields using ConfirmRule
//        validator.registerField(emailConfirmTextField, errorLabel: emailConfirmErrorLabel, rules: [ConfirmationRule(confirmField: emailTextField)])
//        
//        // You can now pass in regex and length parameters through overloaded contructors
//        validator.registerField(phoneNumberTextField, errorLabel: phoneNumberErrorLabel, rules: [RequiredRule(), MinLengthRule(length: 9)])
//        validator.registerField(zipcodeTextField, errorLabel: zipcodeErrorLabel, rules: [RequiredRule(), ZipCodeRule(regex : "\\d{5}")])
//        
//        // You can unregister a text field if you no longer want to validate it
//        validator.unregisterField(fullNameTextField)
    }

}
