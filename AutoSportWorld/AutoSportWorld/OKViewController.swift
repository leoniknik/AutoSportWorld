//
//  OKViewController.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 20/08/2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//


//1- add brifging file to project properties
//2- edit appdelegate to
//    2.1 - init api
//
//        var settings = OKSDKInitSettings()
//        settings.appKey = "CBAKEGNFEBABABABA"
//        settings.appId = "1154828544"
//        settings.controllerHandler = {() -> UIViewController in
//        return self.window!.rootViewController!
//        }
//        OKSDK.initWith(settings)
//
//    2.2 - edit open url
//
//        func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//            OKSDK.open(url)
//            return true
//        }
//3- edit info plist
////to begining
//<key>CFBundleURLTypes</key>
//<array>
//<dict>
//<key>CFBundleTypeRole</key>
//<string>Viewer</string>
//<key>CFBundleURLName</key>
//<string>ru.ok</string>
//<key>CFBundleURLSchemes</key>
//<array>
//<string>ok1154828544</string>
//</array>
//</dict>
//</array>
//<key>CFBundleVersion</key>
//<string>1</string>
//<key>LSApplicationQueriesSchemas</key>
//<array/>
//<key>LSApplicationQueriesSchemes</key>
//<array>
//<string>ok1154828544</string>
//<string>okauth</string>
//</array>
//
//// to end
//<key>item0</key>
//<string>okauth</string>
//<key>item1</key>
//<string>ok1154828544</string>
//











import UIKit

class OKViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        try? OKSDK.getInstallSource({(_ data: Any) -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                let message: String = "install source: \(data)"
                let alert = UIAlertView(title: "getInstallSource", message: message, delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "")
                alert.show()
            })
        }, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

        var commonError: OKErrorBlock? = {(_ error: Error?) -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                var alert = UIAlertView(title: "Error", message: (error?.localizedDescription)!, delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "")
                alert.show()
            })
        }

        
        func lg() {
            OKSDK.authorize(withPermissions: ["VALUABLE_ACCESS", "LONG_ACCESS_TOKEN", "PHOTO_CONTENT"], success: {(_ data: Any) -> Void in
                print("Sucsess login")

                OKSDK.invokeMethod("users.getCurrentUser", arguments: [String: String](), success: {(_ data: Any) -> Void in
                    print("Sucsess login step 2")
                    
                    if let dataDictionary = data as? Dictionary<String, AnyObject> {
                        let fName = dataDictionary["first_name"] as! String
                        let lName = dataDictionary["last_name"] as! String
                        print("Hello \(fName) \(lName)!!!")
                    }
                    }, error: {(_ error: Error?) -> Void in
                        print(error.debugDescription)
                })
            }
             , error: {(_ error: Error?) -> Void in
                print(error.debugDescription)
            })
        }
        
    @IBAction func logIn(_ sender: Any) {
        lg()
    }
    
    @IBAction func clear(_ sender: Any) {
        OKSDK.clearAuth()
    }
 
}


