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
    
    let headers = ["Дата", "Стоимость", "Действие", "Квалификация", "Спорт"]
    
    let items = [["Сначала новые", "Сначала старые"], ["Бесплатные", "Сначала подешевле", "Сначала подороже"], ["Покататься", "Посмотреть"], ["Любительские", "Профессиональные"], ["Мотоспорт", "Автоспорт"]]
    
    func getTitleForHeaderIn(section: Int) -> String {
        return headers[section]
    }
    
    func getNumberOfRowsIn(section: Int) -> Int {
        return items[section].count
    }
    
    func getNumberOfSections() -> Int {
        return service.isUserLogedIn() ? 5 : 3
    }
    
    func getHeightForFooterIn(section: Int) -> Int {
        if (service.isUserLogedIn()) {
            return section == 4 ? 0 : 15
        }
        return section == 2 ? 0 : 15
    }
    
}
