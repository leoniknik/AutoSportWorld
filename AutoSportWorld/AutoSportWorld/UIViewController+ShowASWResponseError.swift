//
//  UIViewController+ShowASWResponseError.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 27.02.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

//import Foundation
//import UIKit
//
//extension UIViewController{
//    func showASWErrorView() {
//        showASWErrorView(retryAction:{return true})
//    }
//    func showASWErrorView(retryAction:@escaping ()->Void) {
//        let errorView = ASWResponseErrorView(frame: self.view.frame)
//        errorView.retryAction = retryAction
//        
//        errorView.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(errorView)
//        
//        errorView.center.y -= 600
////        let horizontalConstraint = NSLayoutConstraint(item: errorView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: -600)
////
////        let verticalConstraint = NSLayoutConstraint(item: errorView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: -600)
////
//       let widthConstraint = NSLayoutConstraint(item: errorView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.width, multiplier: 0.8, constant: 0)
////
//      let heightConstraint = NSLayoutConstraint(item: errorView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.height, multiplier: 0.4, constant: 0)
////
//       NSLayoutConstraint.activate([widthConstraint,heightConstraint])
////        verticalConstraint.isActive = true
////        horizontalConstraint.isActive = true
//     self.view.layoutIfNeeded()
//        
//        UIView.animate(withDuration: 2, animations: {
//
//            errorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
//            self.view.layoutIfNeeded()
//        })
//        
//    }
//    func closeASWErrorView() {
//        self.view.removeFromSuperview()
//    }
//}

