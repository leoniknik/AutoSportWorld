//
//  ASWImageDownloader.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 02.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWImageDownloader {
    
    let session = URLSession.shared
    let operationQueue = OperationQueue()
    
    init() {
        operationQueue.qualityOfService = .userInitiated
    }
    
    deinit {
        operationQueue.cancelAllOperations()
    }
    
    func send(url: String, completionHandler: @escaping (UIImage) -> Void) {
        guard let requestURL = URL(string: url) else {
            return
        }
        
        let task = session.dataTask(with: requestURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            guard let data = data, let image: UIImage = UIImage(data: data) else {
                return
            }
            
            completionHandler(image)
        }
        
        //task.resume()
    }
    
    func sendWithQueue(url: String, completionHandler: @escaping (UIImage) -> Void) {
        guard let requestURL = URL(string: url) else {
            return
        }
        
        let task = session.dataTask(with: requestURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            guard let data = data, let image: UIImage = UIImage(data: data) else {
                return
            }
            
            completionHandler(image)
        }
        
        operationQueue.addOperation {
            //task.resume()
        }
    }
}
