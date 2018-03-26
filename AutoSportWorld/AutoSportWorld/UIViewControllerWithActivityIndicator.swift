//
//  UIViewController+ActivityIndicator.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 18.02.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWViewController:UIViewController, ASWResponseErrorViewControllerDelegate{

    var errorViewController: ASWResponseErrorViewController!
    var completion:(()->Void)?
    var visualEffectView: UIVisualEffectView!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()   
    }
    
    
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
        errorViewController = ASWResponseErrorViewController()
        errorViewController.delegate = self
        
        var blurEffect = UIBlurEffect.init(style: .extraLight)
        
        visualEffectView =  UIVisualEffectView.init(effect: blurEffect)
        
        visualEffectView.frame = errorViewController.view.bounds;
        visualEffectView.alpha = 0
        //self.view.insertSubview(visualEffectView, at: 0)
        self.view.addSubview(visualEffectView)
        
        errorViewController.modalPresentationStyle = .overCurrentContext
    }
    
    func showAlert(){
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionMoveIn
        self.visualEffectView.alpha = 1
        
        view.window?.layer.add(transition, forKey: kCATransition)
        self.present(self.errorViewController, animated: false, completion: {})
        self.visualEffectView.alpha = 1
    }
    
    
    
    
    func hideAlert(){
        UIView.animate(withDuration: 0.2, animations: {
            self.errorViewController.dismiss(animated: true, completion: nil)
            self.visualEffectView.alpha = 0
        },completion:{ result in
            self.completion?()
            self.completion = nil
        })
    }
    
    func okAction() {
        hideAlert()
    }
    
    func cancelAction() {
        hideAlert()
    }
    
    func retryAction() {
        hideAlert()
    }
}
