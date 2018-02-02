//
//  UIViewController+HideKeyboard.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 31.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import Foundation
//  UIViewController+HideKeyboard.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 02.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
