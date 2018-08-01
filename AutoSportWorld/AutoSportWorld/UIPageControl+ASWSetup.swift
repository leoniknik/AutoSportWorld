//
//  UIPageControl+ASWSetup.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 06.05.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

extension UIPageControl{
    func setupPageControl(){
        self.hidesForSinglePage = true;
        self.numberOfPages = 0;
        self.pageIndicatorTintColor = UIColor.ASWColor.grey
        self.currentPageIndicatorTintColor = UIColor.ASWColor.darkBlue
    }
}

