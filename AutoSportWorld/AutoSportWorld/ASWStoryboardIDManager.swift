//
//  ASWStoryboardIDManager.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 12.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

//class ASWStoryboardIDManager{
//    struct Registration{
//        static let registerAccountView = "registerAccountView"
//        static let collectionView = "collectionView"
//        static let changePasswordView = "changePasswordView"
//        static let registerView = "registerView"
//    }
//}

class ASWViewControllerManager{
    struct Registration{
        private static var storyboard = "Registration"
        static var registerAccountViewController:ASWRegisterAccountViewController{
            get{
                let storyboard = UIStoryboard(name: self.storyboard, bundle: Bundle.main)
                return storyboard.instantiateViewController(withIdentifier: "registerAccountView") as! ASWRegisterAccountViewController
            }
        }
        
        static var registerCollectionViewController:ASWCollectionViewController{
            get{
                let storyboard = UIStoryboard(name: self.storyboard, bundle: Bundle.main)
                return storyboard.instantiateViewController(withIdentifier: "collectionView") as! ASWCollectionViewController
            }
        }
        
        static var registerViewController:ASWRegistrationViewController{
            get{
                let storyboard = UIStoryboard(name: self.storyboard, bundle: Bundle.main)
                return storyboard.instantiateViewController(withIdentifier: "registerView") as! ASWRegistrationViewController
            }
        }
        
//        static var changePasswordViewController:ASWChangeRegionsViewController{
//            get{
//                let storyboard = UIStoryboard(name: self.storyboard, bundle: Bundle.main)
//                return storyboard.instantiateViewController(withIdentifier: "changePasswordView") as! ASWChangeRegionsViewController
//            }
//        }
    }
    
    struct AboutApp{
        private static var storyboard = "AboutApp"
        static var aboutAppViewController: ASWAboutAppViewController {
            get{
                let storyboard = UIStoryboard(name: self.storyboard, bundle: Bundle.main)
                return storyboard.instantiateViewController(withIdentifier: "aboutApp") as! ASWAboutAppViewController
            }
        }
        static var developersViewController: ASWDevelopersViewController {
            get{
                let storyboard = UIStoryboard(name: self.storyboard, bundle: Bundle.main)
                return storyboard.instantiateViewController(withIdentifier: "developers") as! ASWDevelopersViewController
            }
        }
    }
}
