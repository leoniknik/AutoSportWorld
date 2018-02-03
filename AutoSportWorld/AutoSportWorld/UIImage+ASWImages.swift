//
//  UIImage+AVSImages.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 07.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

extension UIImage {
    static let backward = UIImage(named: "ic_backward")
    static let location = UIImage(named: "ic_location")
    static let likedOff = UIImage(named: "ic_like_off")
    static let likedOn = UIImage(named: "ic_like_on")
    
    static let passwordSecureOnPicture = UIImage(named: "ic_password_on")
    static let passwordSecureOffPictureWhiteBack = UIImage(named: "ic_password_off")
    static let passwordSecureOffPictureBlackBack = UIImage(named: "ic_password_off")
    
    static let share = UIImage(named: "ic_share")

    static let bookmarkOff = #imageLiteral(resourceName: "ic_star_gray_off_48")
    static let bookmarkOn = #imageLiteral(resourceName: "ic_star_gray_48")
    
    static let cardBookmarkOff = #imageLiteral(resourceName: "fab")
    static let cardBookmarkOn = #imageLiteral(resourceName: "ic_star_white_on")
    
    static let cardLikedOff = #imageLiteral(resourceName: "ic_like_black_32")
    static let cardLikedOn = #imageLiteral(resourceName: "ic_like_blue")
/////
//    static let bookmarkOff = #imageLiteral(resourceName: "ic_bookmark_tape_off")
//    static let bookmarkOn = #imageLiteral(resourceName: "ic_bookmark_tape_on")
//    static let cardBookmarkOff = #imageLiteral(resourceName: "ic_bookmark_card_off")
//    static let cardBookmarkOn = #imageLiteral(resourceName: "ic_bookmark_tab_off")
    
    static let autoWatch = #imageLiteral(resourceName: "ic_bookmark_tape_on")
    static let auto = #imageLiteral(resourceName: "ic_bookmark_tape_on")
    static let autoJoin = #imageLiteral(resourceName: "ic_bookmark_tape_off")
    
    static let moto = #imageLiteral(resourceName: "ic_bookmark_tab_off")
    static let motoJoin = #imageLiteral(resourceName: "ic_bookmark_tab_off")
    static let motoWatch = #imageLiteral(resourceName: "ic_bookmark_card_off")
    
    static func from(_ r:Int, _ g:Int, _ b:Int) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0).cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
}
