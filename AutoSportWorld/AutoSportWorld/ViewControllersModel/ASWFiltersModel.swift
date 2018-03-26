//
//  ASWFiltersModel.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 01.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import Foundation

class ASWFiltersModel {
    
    static let defaultValues = [[true], [false, true, false]]
    
    var values: [[Bool]]
    
    init() {
        values = ASWDatabaseManager().getUserFilters() ?? ASWFiltersModel.defaultValues
    }
    
    let service = ASWFiltersService()
    
//    let headers = ["Дата", "Стоимость", "Действие", "Квалификация", "Спорт"]
//
//    let items = [["Сначала ближайшие"], ["Бесплатные", "Сначала подешевле", "Сначала подороже"], ["Покататься", "Посмотреть"], ["Любительские", "Профессиональные"], ["Мотоспорт", "Автоспорт"]]
//
    
    let headers = ["Дата", "Стоимость"]
    
    let items = [["Сначала ближайшие"], ["Бесплатные", "Сначала подешевле", "Сначала подороже"]]
    
    func getTitleForHeaderIn(section: Int) -> String {
        return headers[section]
    }
    
    func getNumberOfRowsIn(section: Int) -> Int {
        return items[section].count
    }
    
    func getNumberOfSections() -> Int {
//        return service.isUserLogedIn() ? 5 : 3
        return 2
    }
    
    func getHeightForFooterIn(section: Int) -> Int {
//        if (service.isUserLogedIn()) {
//            return section == 4 ? 0 : 15
//        }
        return section == 1 ? 0 : 15
    }
    
    func valueChangedFor(_ indexPath: IndexPath) {
        var params = values[indexPath.section]
        if indexPath.section == 0 {
            params[indexPath.item] = !params[indexPath.item]
        } else {
            let newValue = !params[indexPath.item]
            for (index, _) in params.enumerated() {
                params[index] = false
            }
            params[indexPath.item] = newValue
            
            if indexPath.item == 1 {
                params[2] = !newValue
            }
            if indexPath.item == 2 {
                params[1] = !newValue
            }
            
            if indexPath.item == 0 && newValue == false {
                params[1] = !newValue
            }
        }
        values[indexPath.section] = params
        saveFilters()
    }
    
    func saveFilters() {
        ASWDatabaseManager().setUserFilters(values)
    }
    
    func setDefaultFilter() {
        values = ASWFiltersModel.defaultValues
        saveFilters()
    }
    
}
