//
//  ASWNetworkManager.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 17.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol ASWNetworkManagerProtocol {
    
    static func getEvents(request: ASWListRacesRequest, cursor: String?)
    
}

class ASWNetworkManager: ASWNetworkManagerProtocol {
    
    static func getEvents(request: ASWListRacesRequest, cursor: String?) {
        
        func onSuccess(json: JSON) -> Void{
            
            let response = ASWListRacesParser(json: json)
            if (cursor != nil) {
                NotificationCenter.default.post(name: .eventsCallback, object: nil, userInfo: ["data": response])
            }
            else {
                NotificationCenter.default.post(name: .eventsInitCallback, object: nil, userInfo: ["data": response])
            }

        }
        
        func onError(error: Any) -> Void {
            if (cursor != nil) {

            }
            else {
                NotificationCenter.default.post(name: .eventsCallbackError, object: nil)
            }
        }
        
        ASWNetworkManager.request(URL: request.url, method: .get, parameters: request.parameters, onSuccess: onSuccess, onError: onError)
    }
    
    static func getEvent(request: ASWRaceRequest) {
        
        func onSuccess(json: JSON) -> Void{

            let response = ASWRaceParser(race: json)
            NotificationCenter.default.post(name: .eventCallback, object: nil, userInfo: ["data": response])
            
        }
        
        func onError(error: Any) -> Void {
            NotificationCenter.default.post(name: .eventCallbackError, object: nil)
        }
        
        ASWNetworkManager.request(URL: request.url, method: .get, parameters: request.parameters, onSuccess: onSuccess, onError: onError)
    }
    
    static func getRegions() {
        var request = ASWRegionsRequest()
        func onSuccess(json: JSON) -> Void{
            
            let response = ASWListRegionsParser(json: json)
            NotificationCenter.default.post(name: .regionsCallback, object: nil, userInfo: ["data": response])
            
        }
        
        func onError(error: Any) -> Void {
            NotificationCenter.default.post(name: .regionsCallbackError, object: nil)
        }
        
        ASWNetworkManager.request(URL: request.url, method: .get, parameters: request.parameters, onSuccess: onSuccess, onError: onError)
    }
    
    static func getRaceTypes(type:String) {
        var request = ASWCategoriesRequest(categoryClass: type)
        func onSuccess(json: JSON) -> Void{
            
            let response = ASWListCategoryParser(json: json)
            NotificationCenter.default.post(name: .raceCategoryCallback, object: nil, userInfo: ["data": response])
            
        }
        
        func onError(error: Any) -> Void {
            NotificationCenter.default.post(name: .raceCategoryCallbackError, object: nil)
        }
        
        ASWNetworkManager.request(URL: request.url, method: .get, parameters: request.parameters, onSuccess: onSuccess, onError: onError)
    }
    
//    static func signupUser(email:String,password:String) {
//        var request = ASWSignupRequest(email:email,password:password)
//
//        func onSuccess(json: JSON) -> Void{
//            //let response = ASWListCategoryParser(json: json)
//            NotificationCenter.default.post(name: .signupCallback, object: nil, userInfo: nil)
//        }
//
//        func onError(error: Any) -> Void {
//            NotificationCenter.default.post(name: .signupCallbackError, object: nil)
//        }
//
//        ASWNetworkManager.request(URL: request.url, method: .post, parameters: request.parameters, onSuccess: onSuccess, onError: onError)
//    }
    
    static func loginUser(email:String,password:String, sucsessFunc: @escaping (String,String)->Void,  errorFunc: @escaping ()->Void) {
        var request = ASWLoginRequest(email:email,password:password)
        
        func onSuccess(json: JSON) -> Void{
            sucsessFunc(email,password)
        }
        
        func onError(error: JSON) -> Void {
            let response = ASWLoginErrorParser(json: error)
            errorFunc()
        }
        
        ASWNetworkManager.loginRequest(URL: request.url, method: .post, parameters: request.parameters, onSuccess: onSuccess, onError: onError)
    }
    
    static func signupUser(email:String,password:String, sucsessFunc: @escaping ()->Void,  errorFunc: @escaping ()->Void) {
        var request = ASWSignupRequest(email:email,password:password)
        
        func onSuccess(json: JSON) -> Void{
            let response = ASWSignupParser(json: json)
            sucsessFunc()
        }
        
        func onError(error: JSON) -> Void {
            let response = ASWSignupErrorParser(json: error)
            errorFunc()
        }
        
        ASWNetworkManager.loginRequest(URL: request.url, method: .post, parameters: request.parameters, onSuccess: onSuccess, onError: onError)
    }
    
    //get Request
    private static func request(URL: String, method: HTTPMethod, parameters: Parameters, onSuccess: @escaping (JSON) -> Void , onError: @escaping (Any) -> Void) -> Void {
        Alamofire.request(URL, method: method, parameters: parameters ).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                DispatchQueue.global(qos: .userInitiated).async {
                    onSuccess(json)
                }
            case .failure(let error):
                DispatchQueue.global(qos: .userInitiated).async {
                    onError(error)
                }
            }
        }
    }
    
    private static func loginRequest(URL: String, method: HTTPMethod, parameters: Parameters, onSuccess: @escaping (JSON) -> Void , onError: @escaping (JSON) -> Void) -> Void {
        Alamofire.request(URL, method: method, parameters: parameters ).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                DispatchQueue.global(qos: .userInitiated).async {
                    onSuccess(json)
                }
            case .failure(let error):
                var json = JSON()
                if let data = response.data {
                    json = JSON(data: data)
                }
                DispatchQueue.global(qos: .userInitiated).async {
                    onError(json)
                }
            }
        }
    }

    
    class func defaultOnSuccess(json: JSON) -> Void{
        print(json)
    }
    
    class func defaultOnError(error: Any) -> Void {
        print(error)
    }
    
}
