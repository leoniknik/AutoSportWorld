//
//  ASWStoryboardIDManager.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 12.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWViewControllersManager{
    struct RegistrationViewControllers{
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
    }
    
    
    struct AboutAppViewControllers{
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
    
    struct ChangeUserDataViewControllers{
        private static var storyboard = "Registration"
        
        static var changeActionTypeViewController: ASWRegistrationViewController {
            get{
                let storyboard = UIStoryboard(name: self.storyboard, bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "registerView") as! ASWRegistrationViewController
                vc.configChangeActionType()
                return vc
            }
        }
        
        static var changeRegionsViewController: ASWRegistrationViewController {
            get{
                let storyboard = UIStoryboard(name: self.storyboard, bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "registerView") as! ASWRegistrationViewController
                vc.configChangeRegions()
                return vc
            }
        }
        
        static var changeAutoCategories: ASWRegistrationViewController {
            get{
                let storyboard = UIStoryboard(name: self.storyboard, bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "registerView") as! ASWRegistrationViewController
                vc.configChangeRaceCategory(auto: true)
                return vc
            }
        }
        
        static var changeMotoCategories: ASWRegistrationViewController {
            get{
                let storyboard = UIStoryboard(name: self.storyboard, bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "registerView") as! ASWRegistrationViewController
                vc.configChangeRaceCategory(auto: false)
                return vc
            }
        }
        
        static var changeSportType: ASWRegistrationViewController {
            get{
                let storyboard = UIStoryboard(name: self.storyboard, bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "registerView") as! ASWRegistrationViewController
                vc.configChangeSportType()
                return vc
            }
        }
        
        static var configAllFilters: ASWRegistrationViewController {
            get{
                let storyboard = UIStoryboard(name: self.storyboard, bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "registerView") as! ASWRegistrationViewController
                vc.configForAllFilters()
                return vc
            }
        }
        
        static var changeUserInfo: ASWChangeUserInfoViewController {
            get{
                let storyboard = UIStoryboard(name: self.storyboard, bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "changeUserInfo") as! ASWChangeUserInfoViewController
                return vc
            }
        }
        
        static var changePassword: ASWChangePasswordViewController {
            get{
                let storyboard = UIStoryboard(name: self.storyboard, bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "changePassword") as! ASWChangePasswordViewController
                return vc
            }
        }
        
        static var resetPassword: ASWResetPasswordViewController {
            get{
                let vc = ASWResetPasswordViewController.init(nibName: "ASWResetPasswordViewController", bundle: nil)
                return vc
            }
        }

    }
    
    static var calendarViewController:ASWCalendarViewController{
        get{
            let storyboard = UIStoryboard(name: "Calendar", bundle: Bundle.main)
            return storyboard.instantiateViewController(withIdentifier: "calendar") as! ASWCalendarViewController
        }
    }
}
