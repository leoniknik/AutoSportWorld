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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    
    
    
    private func setupUI() {
        setupErrorView()
    }
    
    private func setupErrorView() {
        errorViewController = ASWResponseErrorViewController()
        errorViewController.delegate = self
        errorViewController.view.frame = view.frame
        
        var blurEffect = UIBlurEffect.init(style: .dark)
        
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
        self.visualEffectView.alpha = 0.8
        
        view.window?.layer.add(transition, forKey: kCATransition)
        self.present(self.errorViewController, animated: false, completion: {})
        self.visualEffectView.alpha = 0.8
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
