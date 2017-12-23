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
            NotificationCenter.default.post(name: .eventsCallbackError, object: nil)
        }
        
        ASWNetworkManager.request(URL: request.url, method: .get, parameters: request.parameters, onSuccess: onSuccess, onError: onError)
    }
    
    
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
