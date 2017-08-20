//
//  FBLoginViewController.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 20/08/2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

// add to appdelegate 2 items
//
//
//1------ to appdidfinishlauch
//
//FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
//
//2----
//
//func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//    let handeled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
//    return handeled
//}

//add to infoplist

//<key>CFBundleURLTypes</key>
//<array>
//<dict>
//<key>CFBundleURLSchemes</key>
//<array>
//<string>fb1817641598546903</string>
//</array>
//</dict>
//</array>
//<key>CFBundleVersion</key>
//<string>1</string>
//<key>FacebookAppID</key>
//<string>1817641598546903</string>
//<key>FacebookDisplayName</key>
//<string>ASW</string>
//<key>LSApplicationQueriesSchemes</key>
//<array>
//<string>fbapi</string>
//<string>fb-messenger-api</string>
//<string>fbauth2</string>
//<string>fbshareextension</string>
//</array>



import UIKit
import FacebookCore
import FacebookLogin

class FBLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Add a custom login button to your app
        
   
        
       
            let loginButton = LoginButton(readPermissions: [ .publicProfile ])
            loginButton.center = view.center
            
            view.addSubview(loginButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
    }

    @IBAction func login(_ sender: Any) {
        loginButtonClicked()
            }
    
    // Once the button is clicked, show the login dialog
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
            }
        }
    }
}
