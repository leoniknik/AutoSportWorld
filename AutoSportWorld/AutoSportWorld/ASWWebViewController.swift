//
//  ASWWebViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 04.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var race: ASWRace
    
    init(race: ASWRace) {
        self.race = race
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlackOpaqueNavBar()
        showWebView()
        addBackButton()
    }
    
    func showWebView() {
        
        if var urlString = race.link {
            if !urlString.hasPrefix("https://") {
                urlString = "https://".appending(urlString)
            }
            if let url = URL(string: urlString) {
                let urlRequest = URLRequest(url: url)
                self.webView.loadRequest(urlRequest)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

extension UIViewController {
    //убрать таб бар
    
    //убрать прозрачность
    func setupBlackOpaqueNavBar() {
        navigationController?.navigationBar.barTintColor = UIColor.ASWColor.black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .blackOpaque
    }

    func addBackButton() {
        let backButton = UIBarButtonItem(image: UIImage.backward, style: .done, target: self, action: #selector(goBackDefault))
        self.navigationItem.setLeftBarButton(backButton, animated: false)

    }
    
    @objc func goBackDefault() {
        self.navigationController?.popViewController(animated: false)
    }
    
    func hideTabBarView() {
        self.tabBarController?.tabBar.isHidden = true
    }
}
