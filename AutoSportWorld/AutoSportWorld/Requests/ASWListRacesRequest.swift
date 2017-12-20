//
//  ListRacesRequest.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 17.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation
import Alamofire

class ASWListRacesRequest {
    /*
    var limit: Int? // лимит. если отсутствует, используется дефолтный
    
    var preferences: String? // разделенные запятыми параметры, которые стоит взять из настроек пользователя. варианты элементов списка: "regions", "categories"
    
    var level: Int? // "pro" или "nonpro"
    
    var cursor: String? // курсор из предыдущего запроса
    
    var categories: String? // id категорий, разделенные запятыми
    
    var regions: String? // id регионов, разделенные запятыми
    
    var sort: String? /*сортировка (см. сортировка гонок). варианты:
                        old - по убыванию времени начала
                        new - по возрастанию времени начала
                        soon - по возрастанию времени начала, исключая прошедшие
                        cheap - по возрастанию цены, исключая прошедшие
                        costly - по убыванию цены, исключая прошедшие */
    
    var canJoin: Bool? // eсли указан, то can_join гонок в списке должен иметь такое значение
    
    var canWatch: Bool? // если указан, то can_watch гонок в списке должен иметь такое значение
    */
    
    var parameters: Parameters = [:]
    
    init(limit: Int?, preferences: String?, level: Int?, cursor: String?, categories: String?, regions: String?, sort: String?, canJoin: Bool?, canWatch: Bool?) {

        parameters["limit"] = limit
        parameters["preferences"] = preferences
        parameters["level"] = level
        parameters["cursor"] = cursor
        parameters["categories"] = categories
        parameters["regions"] = regions
        parameters["sort"] = sort
        parameters["canJoin"] = canJoin
        parameters["canWatch"] = canWatch
        
    }
    
}
