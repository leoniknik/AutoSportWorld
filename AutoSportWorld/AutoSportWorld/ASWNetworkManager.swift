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
    
    static func getEvents(request: ASWListRacesRequest)
    
}

class ASWNetworkManager: ASWNetworkManagerProtocol {
    
    static func getEvents(request: ASWListRacesRequest) {
        
        func onSuccess(json: JSON) -> Void{
            let response = ASWListRacesResponse(json: json)
            NotificationCenter.default.post(name: .eventsCallback, object: nil, userInfo: ["data": response])
        }
        
        func onError(error: Any) -> Void {
            print(error)
        }
        
        ASWNetworkManager.request(URL: ASWUrls.listRacesURL, method: .get, parameters: request.parameters, onSuccess: onSuccess, onError: onError)
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
