//
//  ASWLoginPasswordTextField.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 16.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWLoginPasswordTextField: UIView, UITextFieldDelegate {
    
    var isPasswordField:Bool = false{
        didSet{
            self.setupUI()
        }
    }
    var isPasswordHiddenMode:Bool = true{
        didSet{
            self.textField.isSecureTextEntry = isPasswordHiddenMode
            if(isPasswordHiddenMode){
                passwordModeButton.setImage(UIImage.passwordSecureOnPicture, for: .normal)
            }else{
                passwordModeButton.setImage(UIImage.passwordSecureOffPicture, for: .normal)
            }
        }
    }
    
    var placeHolder:String = ""{
        didSet{
            placeHolderLabel.text = placeHolder
        }
    }
    
    let secureOnPicture = "ic_"
    let secureOffPicture = ""
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var placeHolderLabel: UILabel!
    
    @IBOutlet var view: UIView!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("ASWLoginPasswordTextField", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func setupUI(){
        textField.delegate = self
        //textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        
        if(isPasswordField){
            textField.isSecureTextEntry = isPasswordHiddenMode
            passwordModeButton.isHidden = false
        }else{
            passwordModeButton.isHidden = true
            textField.isSecureTextEntry = false
        }
        
    }

    @IBAction func switchShowPasswordMode(_ sender: Any) {
        isPasswordHiddenMode = !isPasswordHiddenMode
    }
    
    @IBOutlet weak var passwordModeButton: UIButton!
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        placeHolderLabel.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.text==""){
            placeHolderLabel.isHidden = false
        }else{
            placeHolderLabel.isHidden = true
        }
    }
    
//    func textDidChange(_:UITextField){
//
//    }
}
