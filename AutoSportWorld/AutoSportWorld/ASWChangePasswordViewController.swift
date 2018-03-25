//
//  ASWChangePasswordViewController.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 12.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit


class ASWChangePasswordViewController:ASWBasePasswordViewController {

    
    @IBOutlet weak var oldPassField: ASWLoginPasswordTextField!
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addBackButton()
        self.title = "Сменить пароль"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupForm()
        setupBlackOpaqueNavBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func setupForm() {
        super.setupForm()
        setupOldPassField()
        ASWButtonManager.setupButton(button: button)
    }
    
    func setupOldPassField() {
        oldPassField.upperPlaceholderMode = true
        oldPassField.blackBackgroundStyle = false
        oldPassField.isPasswordField = true
        oldPassField.placeHolder = "Старый пароль:"
        oldPassField.upperPlaceHolder = "Старый пароль:"
        //        nameField.textField.addTarget(self, action: #selector(nameDidChange(_:)), for: .editingChanged)
        oldPassField.setupUI()
    }

    @objc override func passwordDidChange(_ sender: UITextField) {
        super.passwordDidChange(sender)
    }
    
    
    override func isFormValid() -> Bool {
        if !super.isFormValid(){
            return false
        }
        
        guard passwordValidator.isValid(oldPassField.textField.text ?? "") else {
            return false
        }
        
        return true
    }
    
    @IBAction func confirmChange(_ sender: Any) {
        guard let newPass = passwordField.textField.text else {
            return
        }
        
        guard let oldPass = oldPassField.textField.text else {
            return
        }
        
        
        
        func success(parser:ASWChangePasswordParser){
            self.button.isEnabled = true
            if parser.isOK{
                if let si = parser.sessionInfoParser{
                    ASWDatabaseManager().setSessionInfo(refresh_token: si.refresh_token, access_token: si.access_token, expires_at: si.expires_at)
                    presentOKAlert("Изменения сохранены","Изменения сохранены"){
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    presentOKAlert("Ошибка","Ошибка")
                }
            }else{
                presentOKAlert("Ошибка", parser.errorMessage)
            }
        }
        
        func error(parser:ASWErrorParser){
            presentAlert(errorParser: parser){
                [weak self] in self?.button.isEnabled = true
            }
        }
        
        self.button.isEnabled = false
        
        ASWNetworkManager.changePassword(oldPass: oldPass, newPass: newPass, sucsessFunc: success, errorFunc: error)
    }
    
}
