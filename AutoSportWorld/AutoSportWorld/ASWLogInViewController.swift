//
//  ASWLogInViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 26.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit
import VK_ios_sdk

let okButton = UIAlertAction(title: "OK", style: .destructive, handler: nil)
fileprivate var SCOPE: [Any]? = nil

class ASWLogInViewController: UIViewController, VKSdkDelegate, VKSdkUIDelegate {

    @IBAction func vkLogin(_ sender: UIButton) {
        print("вк_логин")
        SCOPE = [VK_PER_FRIENDS, VK_PER_WALL, VK_PER_PHOTOS, VK_PER_EMAIL, VK_PER_MESSAGES, VK_PER_OFFLINE]
        VKSdk.instance().register(self)
        VKSdk.instance().uiDelegate = self
        
        VKSdk.authorize(SCOPE)
        print("авторизация прошла")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            print("авторизован")
            print(result.token.email)
            
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
    
}
