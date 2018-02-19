//
//  UIViewController+ActivityIndicator.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 18.02.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

import UIKit

class UIViewControllerWithActivityMonitor:UIViewController {
    var activityIndicator:UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = UIActivityIndicatorView()
        guard let activity = activityIndicator else{
            return
        }
        activity.hidesWhenStopped = true
        activity.color = UIColor.green
        self.view.addSubview(activity)
        activity.translatesAutoresizingMaskIntoConstraints = false
//        let widthConstraint = NSLayoutConstraint(item: activity, attribute: .width, relatedBy: .equal,
//                                                 toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60)
//
//        let heightConstraint = NSLayoutConstraint(item: activity, attribute: .height, relatedBy: .equal,
//                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60)
//        activity.addConstraint(widthConstraint)
//        activity.addConstraint(heightConstraint)
        activity.widthAnchor.constraint(equalToConstant: 200).isActive = true
        activity.heightAnchor.constraint(equalToConstant: 100).isActive = true
        activity.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        let xConstraint = NSLayoutConstraint(item: activity, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
//
//        let yConstraint = NSLayoutConstraint(item: activity, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
//
//        self.view.addConstraint(xConstraint)
//        self.view.addConstraint(yConstraint)
        
//        NSLayoutConstraint.activate([widthConstraint, heightConstraint, xConstraint, yConstraint])
    }
    
}
