//
//  UIViewController+MainScreen.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 26.02.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

extension UIViewController {
    func openMainStoryboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() else { return }
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.setViewControllers([viewController], animated: false)
    }
}
