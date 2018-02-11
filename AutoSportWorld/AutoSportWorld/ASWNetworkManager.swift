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
    
    static func validateLogin(email:String,password:String, sucsessFunc: @escaping (ASWValidateLoginParser)->Void,  errorFunc: @escaping ()->Void) {
        
        var request = ASWValidateLoginRequest(email:email,password:password)
        
        func onSuccess(json: JSON) -> Void{
            sucsessFunc(ASWValidateLoginParser(json: json))
        }
        
        func onError(error: JSON) -> Void {
            errorFunc()
        }

        ASWNetworkManager.authRequest(URL: request.url, method: .post, parameters: request.parameters, onSuccess: onSuccess, onError: onError)
    }
    
    
    static func loginUser(email:String,password:String, sucsessFunc: @escaping (ASWLoginSucsessParser)->Void,  errorFunc: @escaping ()->Void) {
        var request = ASWLoginRequest(email:email,password:password)
        
        func onSuccess(json: JSON) -> Void{
            let response = ASWLoginSucsessParser(json:json)
            response.email = email
            response.password = password
            sucsessFunc(response)
        }
        
        func onError(error: JSON) -> Void {
            let response = ASWLoginErrorParser(json: error)
            errorFunc()
        }
        
        ASWNetworkManager.authRequest(URL: request.url, method: .post, parameters: request.parameters, onSuccess: onSuccess, onError: onError)
    }
    
    static func signupUser(email:String,password:String, sucsessFunc: @escaping (ASWSignupParser)->Void,  errorFunc: @escaping ()->Void) {
        var request = ASWSignupRequest(email:email,password:password)
        
        func onSuccess(json: JSON) -> Void{
            let response = ASWSignupParser(json: json)
            sucsessFunc(response)
        }
        
        func onError(error: JSON) -> Void {
            let response = ASWSignupErrorParser(json: error)
            errorFunc()
        }
        
        ASWNetworkManager.authRequest(URL: request.url, method: .post, parameters: request.parameters, onSuccess: onSuccess, onError: onError)
    }
    
    static func sendUserInfo(regions:[Int], categories: [Int], watch: Bool, join: Bool, sucsessFunc: @escaping (ASWUserInfoSendParser)->Void,  errorFunc: @escaping ()->Void) {
        var request = ASWUserInfoSendRequest(regions: regions, categories: categories, watch: watch, join: join)
        
        func onSuccess(json: JSON) -> Void{
            let response = ASWUserInfoSendParser(json: json)
            sucsessFunc(response)
        }
        
        func onError(error: Any) -> Void {
            errorFunc()
        }
        
        ASWNetworkManager.secretRequest(URL: request.url, method: .post, parameters: request.parameters, onSuccess: onSuccess, onError: onError,acessToken:ASWDatabaseManager().getUser()?.access_token ?? "" )
    }
    
    static func getUserInfo(sucsessFunc: @escaping (ASWUserInfoGetParser)->Void,  errorFunc: @escaping ()->Void) {
        var request = ASWUserInfoGetRequest()
        
        func onSuccess(json: JSON) -> Void{
            let response = ASWUserInfoGetParser(json: json)
            sucsessFunc(response)
        }
        
        func onError(error: Any) -> Void {
            errorFunc()
        }
        
        ASWNetworkManager.secretRequest(URL: request.url, method: .post, parameters: request.parameters, onSuccess: onSuccess, onError: onError,acessToken:ASWDatabaseManager().getUser()?.access_token ?? "" )
    }
    
    
 
    
    //get Request
    private static func request(URL: String, method: HTTPMethod, parameters: Parameters, onSuccess: @escaping (JSON) -> Void , onError: @escaping (Any) -> Void) -> Void {
        print("requesting URL \(URL)")
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
    

    private static func secretRequest(URL: String, method: HTTPMethod, parameters: Parameters, onSuccess: @escaping (JSON) -> Void , onError: @escaping (Any) -> Void, acessToken:String) -> Void {
        print("requesting URL \(URL)")
        
        let headers = ["x-access-token":acessToken]
        
        Alamofire.request(URL, method: method, parameters: parameters,encoding: JSONEncoding.default, headers: headers ).validate().responseJSON { response in
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
    
    private static func authRequest(URL: String, method: HTTPMethod, parameters: Parameters, onSuccess: @escaping (JSON) -> Void , onError: @escaping (JSON) -> Void) -> Void {
        Alamofire.request(URL, method: method, parameters: parameters ).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                DispatchQueue.main.async {
                    onSuccess(json)
                }
            case .failure(let error):
                print(error)
                var json = JSON()
                if let data = response.data {
                    do {
                        try json = JSON(data: data)
                        DispatchQueue.main.async {
                            onError(json)
                        }
                    }
                    catch{
                        
                    }
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
