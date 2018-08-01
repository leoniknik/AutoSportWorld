//
//  ASWLogInViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 26.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit
import VK_ios_sdk
import SafariServices

let okButton = UIAlertAction(title: "OK", style: .destructive, handler: nil)
fileprivate var SCOPE: [Any]? = nil


class ASWLogInViewController: ASWViewController, VKSdkDelegate, VKSdkUIDelegate {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    
    @IBOutlet weak var vkButton: UIButton!
    
    @IBAction func vkLogin(_ sender: UIButton) {
        SCOPE = [VK_PER_FRIENDS, VK_PER_WALL, VK_PER_PHOTOS, VK_PER_EMAIL, VK_PER_MESSAGES, VK_PER_OFFLINE]
        VKSdk.instance().register(self)
        VKSdk.instance().uiDelegate = self
//        VKSdk.authorize(SCOPE)
        
//        https://example.tld/api/auth/vk/cb?code=
        
        let serverURL = "http://miravtosporta.com:4001/api/auth/vk/cb"
        
        guard let url = URL(string: "https://oauth.vk.com/authorize?client_id=6228877&display=mobile&redirect_uri=http://miravtosporta.com:4001/api/auth/vk/cb&response_type=code&v=5.74") else { return }
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
        
//        vkWebView.loadRequest(request)
        
        //let vc = ASWViewControllerManager.Registration.registerViewController
//        vc.configChangeRegions()
//        self.navigationController?.pushViewController(ASWViewControllersManager.calendarViewController, animated: true)
        
//        NSString *authLink = [NSString stringWithFormat:@"http://api.vk.com/oauth/authorize?client_id=%@&scope=wall,photos&redirect_uri=http://api.vk.com/blank.html&display=touch&response_type=token", appID];
//        NSURL *url = [NSURL URLWithString:authLink];
//
//        [vkWebView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupTransparentNavBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupUI(){
        ASWButtonManager.setupLoginButton(button: loginButton)
        ASWButtonManager.setupLoginButton(button: registrationButton)
        ASWButtonManager.setupVKButton(button: vkButton)
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController) {
        present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError) {
        if let captchaVC = VKCaptchaViewController.captchaControllerWithError(captchaError) {
            present(captchaVC, animated: true, completion: nil)
        }
    }
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult) {
        if (result.token != nil) {
            print(result.token.accessToken)
            print(result.token.expiresIn)
            print(result.token.userId)
            print(result.token.secret)
            print(result.token.description)
            print(result.token.email)
            print(result.token.localUser)
            print(result.user)
        } else if (result.error != nil) {
            //            let alertVC = UIAlertController(title: "", message: "Access denied\n\(result.error)", preferredStyle: UIAlertControllerStyle.alert)
            //            alertVC.addAction(okButton)
            //            self.present(alertVC, animated: true, completion: nil)
        }
        
    }
    
    func vkSdkUserAuthorizationFailed() {
        //        let alertVC = UIAlertController(title: "", message: "Access denied", preferredStyle: UIAlertControllerStyle.alert)
        //        alertVC.addAction(okButton)
        //        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func skipRegistration(_ sender: UIButton) {
        openMainStoryboard()
    }
    
    deinit {
        print("deinit")
    }
    
}


extension ASWLogInViewController: SFSafariViewControllerDelegate {
    
}

