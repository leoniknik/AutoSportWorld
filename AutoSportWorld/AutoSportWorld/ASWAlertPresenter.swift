//
//  ASWAlertPresenter.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 19.02.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentServerAlert(_ completion: @escaping ()->Void){
        DispatchQueue.main.async {
            [weak self] in
            let alert = UIAlertController(title: "Ошибка на сервере", message: "Повторите попытку или попробуйде позже", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self?.present(alert, animated: true, completion: completion)
        }
    }
    
    func presentServerAlert(){
        presentServerAlert{}
    }
    
    func presentNetworkAlert(_ completion: @escaping ()->Void){
        DispatchQueue.main.async {
            [weak self] in
            let alert = UIAlertController(title: "Нет сети", message: "Проверьте подключение к интернету и повторите попытку", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self?.present(alert, animated: true, completion: completion)
        }
    }
    
    func presentNetworkAlert(){
        presentNetworkAlert{}
    }
    
    func presentAlert(_ title: String, _ text: String, _ completion: @escaping ()->Void){
        DispatchQueue.main.async {
            [weak self] in
            let alert = UIAlertController(title: "Ошибка на сервере", message: "Повторите попытку или попробуйде позже", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self?.present(alert, animated: true, completion: completion)
        }
    }
    
    func presentAlert(_ title: String, _ text: String){
        presentAlert(title, text,{})
    }
    
}
