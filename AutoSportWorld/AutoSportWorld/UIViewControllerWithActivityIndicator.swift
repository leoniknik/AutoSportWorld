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
        activity.widthAnchor.constraint(equalToConstant: 200).isActive = true
        activity.heightAnchor.constraint(equalToConstant: 100).isActive = true
        activity.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
}

class ASWViewController:UIViewController{
    
    var errorView: ASWResponseErrorView = ASWResponseErrorView.fromNib()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var constraint:NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()   
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//
//            errorView.center.y -= (view.bounds.height)
//
//    }
    
    private func setupUI() {
        setupActivity()
        setupErrorView()
    }
    
    private func setupActivity() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.green
        self.view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.widthAnchor.constraint(equalToConstant: 200).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 200).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupErrorView() {
        
        view.addSubview(errorView)
        errorView.center.x = view.center.x
        errorView.center.y = view.center.y
        
        
        
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        constraint = NSLayoutConstraint(item: errorView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: -300)
        
        self.view.addConstraint(constraint)
        constraint.isActive = true
        
        
        errorView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        errorView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4).isActive = true
        errorView.isHidden = true
        
        errorView.clipsToBounds = true
        errorView.layer.cornerRadius = 20
        
        errorView.enableScreen = {[weak self] in self?.view.isUserInteractionEnabled = true}
        errorView.disableScreen = {[weak self] in self?.view.isUserInteractionEnabled = false}
    }
}
