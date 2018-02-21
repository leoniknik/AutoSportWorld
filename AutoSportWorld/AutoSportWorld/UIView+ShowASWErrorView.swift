//
//  UIView+ShowASWErrorView.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 20.02.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

extension UIView{
    func showASWErrorView() {
        let view = ASWErrorView(frame: self.frame)
        view.retryAction = {return true}
        self.addSubview(view)
    }
    func showASWErrorView(retryAction:@escaping ()->Bool) {
        let view = ASWErrorView(frame: self.frame)
        view.retryAction = retryAction
        self.addSubview(view)
    }
    func closeASWErrorView() {
        self.removeFromSuperview()
    }
}
