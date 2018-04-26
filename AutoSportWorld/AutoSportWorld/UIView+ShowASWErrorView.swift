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
        self.insertSubview(view, at: 0)
    }
    
    func showASWErrorView(title:String,text:String) {
        let view = ASWErrorView(frame: self.bounds)
        view.titleLabel.text = title
        view.label.text = text
        view.button.setTitle("ОК", for: .disabled)
        view.button.isEnabled = false
        view.retryAction = {return false}
        self.addSubview(view)
    }
    
    func showASWPermissionErrorView() {
        let view = ASWErrorView(frame: self.bounds)
        view.titleLabel.text = "perm"
        view.label.text = "perm"
        view.button.setTitle("ОК", for: .disabled)
        view.button.isEnabled = false
        view.retryAction = {return false}
        self.addSubview(view)
    }
    
    func showASWErrorView(retryAction:@escaping ()->Void) {
        let view = ASWErrorView(frame: self.frame)
        view.retryAction = retryAction
        self.addSubview(view)
    }
    func closeASWErrorView() {
        if self is ASWErrorView{
            self.removeFromSuperview()
        }else{
            for view in self.subviews {
                if view is ASWErrorView{
                    view.removeFromSuperview()
                }
            }
        }
        
        
    }
}
