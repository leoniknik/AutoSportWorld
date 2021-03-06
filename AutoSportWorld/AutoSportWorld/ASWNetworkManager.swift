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

class ASWNetworkManager{
    
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
    
    static func validateLogin(email:String,password:String,name:String, sucsessFunc: @escaping (ASWValidateLoginParser)->Void,  errorFunc: @escaping (ASWErrorParser)->Void) {
        
        var request = ASWValidateLoginRequest(email:email,password:password, name:name)
        
        func onSuccess(json: JSON) -> Void{
            sucsessFunc(ASWValidateLoginParser(json: json))
        }
        
        func onError(json: JSON, error: Error) -> Void {
            errorFunc(ASWErrorParser(error: error, json: json))
            
        }
        
        ASWNetworkManager.authRequest(URL: request.url, method: .post, parameters: request.parameters, onSuccess: onSuccess, onError: onError)
    }
    
    
    static func loginUser(email:String,password:String, sucsessFunc: @escaping (ASWLoginSucsessParser)->Void,  errorFunc: @escaping (ASWLoginErrorParser)->Void) {
        var request = ASWLoginRequest(email:email,password:password)
        
        func onSuccess(json: JSON) -> Void{
            let response = ASWLoginSucsessParser(json:json)
            response.email = email
            response.password = password
            sucsessFunc(response)
        }
        
        func onError(json: JSON, error: Error) -> Void {
            let response = ASWLoginErrorParser(error: error, json: json)
            errorFunc(response)
        }
        
        ASWNetworkManager.authRequest(URL: request.url, method: .post, parameters: request.parameters, onSuccess: onSuccess, onError: onError)
    }
    
    static func signupUser(email:String,password:String,name:String, sucsessFunc: @escaping (ASWSignupParser)->Void,  errorFunc: @escaping (ASWSignupErrorParser)->Void) {
        var request = ASWSignupRequest(email:email,password:password, name:name)
        
        func onSuccess(json: JSON) -> Void{
            let response = ASWSignupParser(json: json)
            sucsessFunc(response)
        }
        
        func onError(json: JSON, error: Error) -> Void {
            let response = ASWSignupErrorParser(error: error,json: json)
            errorFunc(response)
        }
        
        ASWNetworkManager.authRequest(URL: request.url, method: .post, parameters: request.parameters, onSuccess: onSuccess, onError: onError)
    }
    
    static func sendUserInfo(regions:[String], categories: [String], watch: Bool, join: Bool, sucsessFunc: @escaping (ASWUserInfoSendParser)->Void,  errorFunc: @escaping (ASWErrorParser)->Void) {
        var request = ASWUserInfoSendRequest(regions: regions, categories: categories, watch: watch, join: join)
        
        func onSuccess(json: JSON) -> Void{
            let response = ASWUserInfoSendParser(json: json)
            sucsessFunc(response)
        }
        
        func onError(json:JSON,error: Error) -> Void {
            errorFunc(ASWErrorParser(error: error, json: json))
        }
        
        ASWNetworkManager.secretRequest(URL: request.url, method: .post, parameters: request.parameters, encoding: request.encoding, onSuccess: onSuccess, onError: onError,acessToken:ASWDatabaseManager().getUser()?.access_token ?? "" )
    }
    
    static func getUserInfo(sucsessFunc: @escaping (ASWUserInfoGetParser)->Void,  errorFunc: @escaping (ASWErrorParser)->Void) {
        var request = ASWUserInfoGetRequest()
        
        func onSuccess(json: JSON) -> Void{
            let response = ASWUserInfoGetParser(json: json)
            sucsessFunc(response)
        }
        
        func onError(json:JSON,error: Error) -> Void {
            errorFunc(ASWErrorParser(error: error, json: json))
        }
        
        ASWNetworkManager.secretRequest(URL: request.url, method: .post, parameters: request.parameters, encoding: request.encoding, onSuccess: onSuccess, onError: onError,acessToken:ASWDatabaseManager().getUser()?.access_token ?? "" )
    }
    
    static func getCalendarRaces(from: Date, to: Date, sucsessFunc: @escaping (ASWCalendarRacesParser)->Void,  errorFunc: @escaping (ASWErrorParser)->Void) {
        var request = ASWCalendarRacesRequest(from:from, to:to)
        
        func onSuccess(json: JSON) -> Void{
            let response = ASWCalendarRacesParser(json: json)
            sucsessFunc(response)
        }
        
        func onError(json:JSON,error: Error) -> Void {
            errorFunc(ASWErrorParser(error:error,json:json))
        }
        
        ASWNetworkManager.secretRequest(URL: request.url, method: .get, parameters: request.parameters, encoding: request.encoding, onSuccess: onSuccess, onError: onError,acessToken:ASWDatabaseManager().getUser()?.access_token ?? "" )
    }
    
    static func likeEvent(id: String, successFunc: @escaping () -> ()) {
        let request = ASWLikeRequest(id: id)
        guard let token = ASWDatabaseManager().getUser()?.access_token else { return }
        let headers = ["x-access-token":token,"Content-Type":"application/json"]
        Alamofire.request(request.url, method: .post, parameters: request.parameters, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                successFunc()
            case .failure(let error):
                defaultOnError(error: error)
            }
        }
    }
    
    static func unlikeEvent(id: String, successFunc: @escaping () -> ()) {
        let request = ASWUnlikeRequest(id: id)
        guard let token = ASWDatabaseManager().getUser()?.access_token else { return }
        let headers = ["x-access-token":token,"Content-Type":"application/json"]
        Alamofire.request(request.url, method: .post, parameters: request.parameters, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                successFunc()
            case .failure(let error):
                defaultOnError(error: error)
            }
        }
    }
    
    static func resetPassword(email:String, sucsessFunc: @escaping (ASWResetPasswordParser)->Void,  errorFunc: @escaping (ASWLoginErrorParser)->Void) {
        var request = ASWResetPasswordRequest(email: email)
        
        func onSuccess(json: JSON) -> Void{
            let response = ASWResetPasswordParser(json: json)
            sucsessFunc(response)
        }
        
        func onError(json: JSON, error: Error) -> Void {
            let response = ASWLoginErrorParser(error: error, json: json)
            errorFunc(response)
        }
        
        ASWNetworkManager.authRequest(URL: request.url, method: .post, parameters: request.parameters, onSuccess: onSuccess, onError: onError)
    }
    
    static func changePassword(oldPass: String, newPass: String, sucsessFunc: @escaping (ASWChangePasswordParser)->Void,  errorFunc: @escaping (ASWLoginErrorParser)->Void) {
        var request = ASWChangePasswordRequest(oldPass: oldPass, newPass: newPass)
        
        func onSuccess(json: JSON) -> Void{
            let response = ASWChangePasswordParser(json: json)
            sucsessFunc(response)
        }
        
        func onError(json: JSON, error: Error) -> Void {
            let response = ASWLoginErrorParser(error: error, json: json)
            errorFunc(response)
        }
        
        ASWNetworkManager.secretRequest(URL: request.url, method: .post, parameters: request.parameters, encoding: JSONEncoding.default, onSuccess: onSuccess, onError: onError, acessToken: ASWDatabaseManager().getUser()?.access_token ?? "")
    }
    
    static func vkLogin(url: String, sucsessFunc: @escaping (ASWVKLoginParser)->Void,  errorFunc: @escaping (ASWLoginErrorParser)->Void) {
        var request = ASWRequest()
        request.url = url
        
        func onSuccess(json: JSON) -> Void{
            let response = ASWVKLoginParser(json: json)
            sucsessFunc(response)
        }
        
        func onError(json: JSON, error: Error) -> Void {
            let response = ASWLoginErrorParser(error: error, json: json)
            errorFunc(response)
        }
        
        ASWNetworkManager.authRequest(URL: request.url, method: .get, parameters: request.parameters, onSuccess: onSuccess, onError: onError)
    }
    
    //get Request
    private static func request(URL: String, method: HTTPMethod, parameters: Parameters, onSuccess: @escaping (JSON) -> Void , onError: @escaping (Any) -> Void, encoding: ParameterEncoding = URLEncoding.default) -> Void {
        
        //        let configuration = URLSessionConfiguration.default
        //        configuration.timeoutIntervalForRequest = 5
        //        configuration.timeoutIntervalForResource = 5
        //        let alamoFireManager = Alamofire.SessionManager(configuration: configuration)
        
        var headers: HTTPHeaders? = [:]
                if let token = ASWDatabaseManager().getUser()?.access_token {
                    headers = ["x-access-token":token,"Content-Type":"application/json"]
                }
        
        Alamofire.request(URL, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                DispatchQueue.global(qos: .userInitiated).async {
                    onSuccess(json)
                }
            case .failure(let error):
                DispatchQueue.global(qos: .userInitiated).async {
                    let json = JSON(error)
                    print(error)
                    onError(error)
                }
            }
        }
    }
    
    
    private static func secretRequest(URL: String, method: HTTPMethod, parameters: Parameters, encoding: ParameterEncoding, onSuccess: @escaping (JSON) -> Void , onError: @escaping (JSON,Error) -> Void, acessToken:String) -> Void {
        print("requesting URL \(URL)")
        
        let headers = ["x-access-token":acessToken, "Content-Type":"application/json"]
        
        Alamofire.request(URL, method: method, parameters: parameters,encoding: encoding, headers: headers ).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                DispatchQueue.global(qos: .userInitiated).async {
                    let json = JSON(value)
                    onSuccess(json)
                }
            case .failure(let error):
                DispatchQueue.global(qos: .userInitiated).async {
                    var json = JSON()
                    if let data = response.data {
                        do {
                            json = try JSON(data: data)
                        }
                        catch {
                            return
                        }
                    }
                    DispatchQueue.main.async {
                        onError(json,error)
                    }
                }
            }
        }
    }
    
    private static func authRequest(URL: String, method: HTTPMethod, parameters: Parameters, onSuccess: @escaping (JSON) -> Void , onError: @escaping (JSON,NSError) -> Void) -> Void {
        
        Alamofire.request(URL, method: method, parameters: parameters ).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                DispatchQueue.main.async {
                    onSuccess(json)
                }
            case .failure(let error):
                DispatchQueue.global(qos: .userInitiated).async {
                    print(error)
                    var json = JSON()
                    if let data = response.data {
                        do {
                            var str = String(data: data, encoding: String.Encoding.utf8) as String? ?? ""
                            print(str)
                            str = str.replacingOccurrences(of: "\"code\":null", with: "\"code\":0")
                            print(str)
                            var newData = str.data(using: String.Encoding.utf8) ?? data
                            json = try JSON(data: newData)
                        }
                        catch{
                            print(error)
                        }
                    }
                    DispatchQueue.main.async {
                        onError(json, error as NSError)
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

enum Result<T> {
    case success(T)
    case error(String)
}

extension ASWNetworkManager {
    
    typealias GetEventCompletion = ((Result<ASWRaceParser>) -> Void)?
    static func getEventWithCompletion(request: ASWRaceRequest, completion: GetEventCompletion) {
        
        func onSuccess(json: JSON) -> Void{
            let response = ASWRaceParser(race: json)
            DispatchQueue.main.async {
                completion?(Result.success(response))
            }
        }
        
        func onError(error: Any) -> Void {
            DispatchQueue.main.async {
                completion?(Result.error("Ошибка"))
            }
        }
        
        ASWNetworkManager.request(URL: request.url, method: .get, parameters: request.parameters, onSuccess: onSuccess, onError: onError)
    }
    
    typealias GetEventsCompletion = ((Result<ASWListRacesParser>) -> Void)?
    static func getEventsWithCompletion(request: ASWListRacesRequest, completion: GetEventsCompletion) {
        
        func onSuccess(json: JSON) -> Void{
            let response = ASWListRacesParser(json: json)
            DispatchQueue.main.async {
                completion?(Result.success(response))
            }
        }
        
        func onError(error: Any) -> Void {
            DispatchQueue.main.async {
                completion?(Result.error("Не удалось получить список событий"))
            }
        }
        
        ASWNetworkManager.request(URL: request.url, method: .get, parameters: request.parameters, onSuccess: onSuccess, onError: onError)
    }
}
