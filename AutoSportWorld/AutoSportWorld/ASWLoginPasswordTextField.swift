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
            
            let when = DispatchTime.now() + 0.01 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
                if let newPosition = self?.textField.beginningOfDocument{
                    self?.textField.selectedTextRange = self?.textField.textRange(from: newPosition, to: newPosition)
                }
                if let newPosition = self?.textField.endOfDocument{
                    self?.textField.selectedTextRange = self?.textField.textRange(from: newPosition, to: newPosition)
                }
                
            }
            
        }
    }
    
    var incorrectMod:Bool = false{
        didSet{
            DispatchQueue.main.async {
                [weak self] in
                if(self?.incorrectMod ?? false){
                    self?.lineView.backgroundColor = .red
                }else{
                    if(self?.blackBackgroundStyle ?? false){
                        self?.lineView.backgroundColor = UIColor.white
                    }else{
                        self?.lineView.backgroundColor = UIColor.black
                    }
                }
            }
        }
    }
    
    var placeHolder:String = ""{
        didSet{
            placeHolderLabel.text = placeHolder
            upperPlaceHolderLabel.text = placeHolder
        }
    }
    
    
    var validator: ASWValidator?
    var blackBackgroundStyle:Bool = false
    var upperPlaceholderMode:Bool = false
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var placeHolderLabel: UILabel!
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var upperPlaceHolderLabel: UILabel!
    
    @IBOutlet weak var lineView: UIView!
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
        
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.clear.cgColor
        
        upperPlaceHolderLabel.textColor = UIColor.ASWColor.grey
        
        if(blackBackgroundStyle){
            lineView.backgroundColor = UIColor.white
            placeHolderLabel.textColor = UIColor.white
            textField.textColor = UIColor.white
        }else{
            lineView.backgroundColor = UIColor.black
            placeHolderLabel.textColor = UIColor.black
            textField.textColor = UIColor.black
        }
        
        textFieldDidEndEditing(self.textField)
        view.setNeedsDisplay()
    }

    @IBAction func switchShowPasswordMode(_ sender: Any) {
        isPasswordHiddenMode = !isPasswordHiddenMode
    }
    
    @IBOutlet weak var passwordModeButton: UIButton!
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        placeHolderLabel.isHidden = true
        upperPlaceHolderLabel.isHidden = !upperPlaceholderMode
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.text==""){
            placeHolderLabel.isHidden = false
            upperPlaceHolderLabel.isHidden = true
        }else{
            placeHolderLabel.isHidden = true
            upperPlaceHolderLabel.isHidden = !upperPlaceholderMode
        }
    }
    
    
    

}
