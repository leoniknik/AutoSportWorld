//
//  ASWTabBarController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 25.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let selectedIndex = tabBar.items?.index(of: item)
        let tabBarItem = self.tabBar.subviews[selectedIndex! + 1]
        let imageView = tabBarItem.subviews.first as! UIImageView
        let animationManager = ASWAnimationManager()
        animationManager.bouncedAnimation(forImageView: imageView)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupNavbar() {
        self.navigationController?.navigationBar.tintColor = .white
//        self.navigationController?.navigationBar.barTintColor = .white
    }
    
}
