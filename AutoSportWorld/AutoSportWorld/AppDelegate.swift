//
//  AppDelegate.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 06.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit
import VK_ios_sdk
import GoogleMaps
import RealmSwift

fileprivate var SCOPE: [Any]? = nil

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupUI()
        initVK()
        initGoogleMap()
        printRealmConfig()
        
//        func test(){}
//        
//        func sucsessCheck(parser:ASWValidateLoginParser){
//        }
//        
//        func errorCheck(){
//        }
//        
//        ASWNetworkManager.validateLogin(email: "lol", password: "", sucsessFunc: sucsessCheck, errorFunc: errorCheck)
//        
        return true
    }

    func setupUI() {
        //настройка цвета таб бара
        UITabBar.appearance().barTintColor = UIColor.ASWColor.black
        //настройка цвета выделенного tab item
        UITabBar.appearance().tintColor = UIColor.white
    
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.ASWColor.grey], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        VKSdk.processOpen(url, fromApplication: UIApplicationOpenURLOptionsKey.sourceApplication.rawValue)
        print("application URL")
        return true
    }
    
    func initVK() {
        VKSdk.initialize(withAppId: "6162114")
        SCOPE = [VK_PER_FRIENDS, VK_PER_WALL, VK_PER_PHOTOS, VK_PER_EMAIL, VK_PER_MESSAGES, VK_PER_OFFLINE]
        VKSdk.wakeUpSession(SCOPE, complete: {(_ state: VKAuthorizationState, _ error: Error?) -> Void in
            if error != nil {
                //                let alertVC = UIAlertController(title: "", message: error.debugDescription, preferredStyle: UIAlertControllerStyle.alert)
                //                alertVC.addAction(okButton)
                //                self.window?.rootViewController?.present(alertVC, animated: true, completion: nil)
            }
            else if state == VKAuthorizationState.authorized{
                print("авторизован")
                
                
            }
            else if state != VKAuthorizationState.authorized {
                print("не авторизован")
            }
        })
    }
    
    func initGoogleMap() {
        GMSServices.provideAPIKey("AIzaSyD32daYcxUE9uE7DqStnmkPh75TvzwoUtQ")
    }
    
    func printRealmConfig() {
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        let config = Realm.Configuration(
            
            schemaVersion: 9,
            
            migrationBlock: { migration, oldSchemaVersion in
                
                if (oldSchemaVersion < 5) {
                    
                }
        })
        Realm.Configuration.defaultConfiguration = config
        
    }
    
}

