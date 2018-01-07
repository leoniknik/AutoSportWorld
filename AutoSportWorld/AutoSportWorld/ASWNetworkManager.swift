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
    
    class func defaultOnSuccess(json: JSON) -> Void{
        print(json)
    }
    
    class func defaultOnError(error: Any) -> Void {
        print(error)
    }
    
}
