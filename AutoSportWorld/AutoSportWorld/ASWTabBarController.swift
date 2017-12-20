//
//  ASWTabBarController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 25.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWTabBarController: UITabBarController {
    
    @IBOutlet weak var tabbar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItems()
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let selectedIndex = tabBar.items?.index(of: item)
        let tabBarItem = self.tabBar.subviews[selectedIndex! + 1]
        let imageView = tabBarItem.subviews.first as! UIImageView
        let animationManager = ASWAnimationManager()
        animationManager.bouncedAnimation(forImageView: imageView)
    }

    func setupTabBarItems() {
        let myTabBarItem1 = (self.tabbar.items?[0])! as UITabBarItem
        myTabBarItem1.image = UIImage(named: "ic_lenta_off")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        let myTabBarItem2 = (self.tabbar.items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(named: "ic_bookmark_tab_off")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)

        let myTabBarItem3 = (self.tabbar.items?[2])! as UITabBarItem
        myTabBarItem3.image = UIImage(named: "ic_calendar_off")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)

        let myTabBarItem4 = (self.tabbar.items?[3])! as UITabBarItem
        myTabBarItem4.image = UIImage(named: "ic_map")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)

        setupProfileTab()
    }
    
    func setupProfileTab() {
        
        let secondStoryboard:UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        
        let secondVC: UIViewController = secondStoryboard.instantiateViewController(withIdentifier: "profile") as UIViewController
        
        var viewsTBC = self.viewControllers
        viewsTBC?.append(secondVC)
        self.viewControllers = viewsTBC
        
        let myTabBarItem5 = (self.tabbar.items?[4])! as UITabBarItem
        myTabBarItem5.image = UIImage(named: "ic_profil_off")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem5.selectedImage = UIImage(named: "ic_profil_on")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
    
}
