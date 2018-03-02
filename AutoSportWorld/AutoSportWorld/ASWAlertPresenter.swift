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
            self?.errorViewController.titleText = title
            self?.errorViewController.bodyText = text
            self?.errorViewController.okMode = false
            self?.showAlert()
        }
    }
    
    func presentAlert(_ title: String, _ text: String){
        presentAlert(title, text,{})
    }
    
    func presentOKAlert(_ title: String, _ text: String, _ completion: @escaping ()->Void){
        DispatchQueue.main.async {
            [weak self] in
            self?.errorViewController.titleText = title
            self?.errorViewController.bodyText = text
            self?.errorViewController.okMode = true
            self?.showAlert()
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
