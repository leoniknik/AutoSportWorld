//
//  ASWAlertPresenter.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 19.02.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

extension ASWViewController {
    func presentServerAlert(_ completion: @escaping ()->Void){
        DispatchQueue.main.async {
            [weak self] in
            self?.presentAlert("Ошибка на сервере", "Повторите попытку или попробуйде позже", completion)
        }
    }
    
    func presentServerAlert(){
        presentServerAlert{}
    }
    
    func presentNetworkAlert(_ completion: @escaping ()->Void){
        DispatchQueue.main.async {
            [weak self] in
                self?.presentAlert("Нет сети", "Проверьте подключение к интернету и повторите попытку", completion)
        }
    }
    
    func presentNetworkAlert(){
        presentNetworkAlert{}
    }
    
    func presentAlert(_ title: String, _ text: String, _ completion: @escaping ()->Void){
        DispatchQueue.main.async {
            [weak self] in
            
            self?.errorView.titleLabel.text = title
            self?.errorView.textLabel.text = text
            self?.errorView.retryAction = completion
            self?.errorView.center.y = self?.view.center.y ?? 0
            self?.errorView.center.y -= (self?.view.bounds.height ?? 0)
            self?.view.layoutIfNeeded()
            self?.errorView.isHidden = false
            
            self?.errorView.okButton.isHidden = true
            self?.errorView.retryButton.isHidden = false
            self?.errorView.cancelButton.isHidden = false
            
            UIView.animate(withDuration: 2) {
                self?.errorView.center.y = self?.view.center.y ?? 0
                self?.view.layoutIfNeeded()
            }
            
//            let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//            self?.present(alert, animated: true, completion: completion)
        }
    }
    
    func presentAlert(_ title: String, _ text: String){
        presentAlert(title, text,{})
    }
    
    func presentOKAlert(_ title: String, _ text: String, _ completion: @escaping ()->Void){
        DispatchQueue.main.async {
            [weak self] in
            
            self?.errorView.titleLabel.text = title
            self?.errorView.textLabel.text = text
            self?.errorView.retryAction = completion
            
            
            
            

//self?.errorView.center.y = -300
           
            //self?.errorView.centerYAnchor.constraint(equalTo: (self?.view.centerYAnchor)!, constant: -300).isActive = true
           
            self?.errorView.layoutIfNeeded()
            self?.errorView.isHidden = false
            
            self?.errorView.okButton.isHidden = false
            self?.errorView.retryButton.isHidden = true
            self?.errorView.cancelButton.isHidden = true
            self?.constraint.constant = -300
            self?.view.layoutIfNeeded()
            UIView.animate(withDuration: 2) {
                //self?.errorView.center.y = self?.view.center.y ?? 300
                self?.constraint.constant = 0
                self?.view.layoutIfNeeded()
            }
            
            //            let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
            //            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            //            self?.present(alert, animated: true, completion: completion)
        }
    }
    
    func presentOKAlert(_ title: String, _ text: String){
        presentOKAlert(title, text,{})
    }
    
    func presentAlert(errorParser: ASWErrorParser,_ completion: @escaping ()->Void){
        if errorParser.hasInternetError {
            presentNetworkAlert {
                completion()
            }
        } else if errorParser.hasServerError {
            presentServerAlert {
                completion()
            }
        } else if errorParser.errors.count > 0 {
            presentAlert("Ошибка", errorParser.errorString){
                completion()
            }
        } else {
            presentServerAlert {
                completion()
            }
        }
    }
    
    func presentAlert(errorParser: ASWErrorParser){
        presentAlert(errorParser:errorParser,{})
    }
}
