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
import SwiftyJSON

let okButton = UIAlertAction(title: "OK", style: .destructive, handler: nil)
fileprivate var SCOPE: [Any]? = nil


class ASWLogInViewController: ASWViewController, VKSdkDelegate, VKSdkUIDelegate {
    @IBOutlet weak var webViewButton: UIButton!
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    
    @IBOutlet weak var vkButton: UIButton!
    
    @IBAction func vkLogin(_ sender: UIButton) {
        SCOPE = [VK_PER_FRIENDS, VK_PER_WALL, VK_PER_PHOTOS, VK_PER_EMAIL, VK_PER_MESSAGES, VK_PER_OFFLINE]
        VKSdk.instance().register(self)
        VKSdk.instance().uiDelegate = self
        //VKSdk.authorize(SCOPE)
        
//        https://example.tld/api/auth/vk/cb?code=
        
        let serverURL = "http://miravtosporta.com:4001/api/auth/vk/cb"
        
        guard let url = URL(string: "https://oauth.vk.com/authorize?client_id=6228877&display=mobile&redirect_uri=http://miravtosporta.com:4001/api/auth/vk/cb&response_type=code&v=5.74&display=touch") else { return }
        //let svc = SFSafariViewController(url: url)
        //svc.delegate = self
        //present(svc, animated: true, completion: nil)
        webView.loadRequest(URLRequest(url: url))
        webView.delegate = self
        webView.isHidden = false
        webViewButton.isHidden = false
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
        webView.layer.cornerRadius = 20
        webView.clipsToBounds = true
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
            
            func success(parser:ASWVKLoginParser){
                
            }
            func error(parser:ASWLoginErrorParser){
                
            }
            
            ASWNetworkManager.vkLogin(url: "http://miravtosporta.com:4001/api/auth/vk/cb?code="+result.token.accessToken, sucsessFunc: success, errorFunc: error)
            
            
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
    
    
    func getUserInfo(){
        
        func sucsessFunc(parser:ASWUserInfoGetParser){
            ASWDatabaseManager().setUserInfo(parser:parser)
            
            
            DispatchQueue.main.async {
                self.openMainStoryboard()
            }
            
        }
        
        func errorFunc(parser:ASWErrorParser){
            presentAlert(errorParser: parser)
        }
        
        ASWNetworkManager.getUserInfo(sucsessFunc: sucsessFunc, errorFunc: errorFunc)
    }
    
    @IBAction func closeWebView(_ sender: Any) {
        webViewButton.isHidden = true
        webView.isHidden = true
        webView.resignFirstResponder()
        webView.endEditing(true)
    }
}


extension ASWLogInViewController: SFSafariViewControllerDelegate {
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        print(URL)
    }
}

extension ASWLogInViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("------------------")
        print(webView.request?.url?.absoluteString)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("------------------")
        print(webView.request?.url?.absoluteString)
        let doc = webView.stringByEvaluatingJavaScript(from: "document.documentElement.outerHTML")
        
        let part = "http://miravtosporta.com:4001/api/auth/vk/cb?code"
        let urlpart = webView.request?.url?.absoluteString.substring(to: part.count)
        if urlpart == part {
            let jsonString = doc?.slice(from: "<html><head></head><body><pre style=\"word-wrap: break-word; white-space: pre-wrap;\">", to: "</pre></body></html>")
            print(jsonString)
            var json = JSON.parse(jsonString!)
            var parser = ASWVKLoginParser(json: json)
            
            if parser.valid{
                webView.isHidden = true
                webViewButton.isHidden = true
                webView.resignFirstResponder()
                webView.endEditing(true)
                ASWDatabaseManager().loginUser(parser:parser)
                
                if parser.filtersEmpty {
                    var vc = ASWViewControllersManager.ChangeUserDataViewControllers.configAllFilters;
                    self.navigationController?.pushViewController(vc, animated: true)
                    return
                }
                getUserInfo()
            }
            
        }
        
    }
}


extension String {
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}


extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}

