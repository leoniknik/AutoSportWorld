//
//  AboutAppViewController.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 20/08/2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit
import StoreKit

class ASWAboutAppViewController: UIViewController {

    @IBOutlet weak var serviceLabel: UILabel!
    
    @IBOutlet weak var rateButton: UIButton!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var termsOfUseButton: UIButton!
    
    @IBOutlet weak var rulesView: UIView!
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hidesBottomBarWhenPushed = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "О приложении"
        setupUI()
        addBackButton(animated: true)
        setupBlackOpaqueNavBar()
        navigationController?.navigationBar.tintColor = .white
        setupRulesTransition()
    }
    
    func setupUI(){
        ASWButtonManager.setupButton(button: rateButton)
        serviceLabel.textColor = UIColor.ASWColor.grey
    }
    
    
    @IBAction func rate(_ sender: Any) {
        SKStoreReviewController.requestReview()
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupRulesTransition() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openRules))
        rulesView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func openRules() {
        let vc = ASWRulesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
