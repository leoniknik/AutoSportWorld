//
//  ASWFiltersModel.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 01.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import Foundation

class ASWFiltersModel {
    
    let service = ASWFiltersService()
    
//    let headers = ["Дата", "Стоимость", "Действие", "Квалификация", "Спорт"]
//
//    let items = [["Сначала ближайшие"], ["Бесплатные", "Сначала подешевле", "Сначала подороже"], ["Покататься", "Посмотреть"], ["Любительские", "Профессиональные"], ["Мотоспорт", "Автоспорт"]]
//
    
    let headers = ["Дата", "Стоимость"]
    
    let items = [["Сначала ближайшие"], ["Бесплатные", "Сначала подешевле", "Сначала подороже"]]
    
    var values = [[true], [false, true, false]]
    
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
        
    }
    
}
