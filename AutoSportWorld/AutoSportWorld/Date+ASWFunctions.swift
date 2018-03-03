//
//  Date+ASWFunctions.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 03.03.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import Foundation
extension Date {
    func lastDayOfMonth() -> Date {
        let calendar = Calendar.current
        let dayRange = calendar.range(of: .day, in: .month, for: self)
        let dayCount = dayRange!.count
        var comp = calendar.dateComponents([.year, .month, .day], from: self)
        
        comp.day = dayCount
        
        return calendar.date(from: comp) ?? self
    }
    
    func firstDayOfMonth() -> Date {
        let calendar: Calendar = Calendar.current
        var components: DateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        components.setValue(1, for: .day)
        return calendar.date(from: components) ?? self  
    }
    
    func addMonth(_ count: Int?)->Date{
        var amaunt = 1
        
        if let cnt = count{
            amaunt = cnt
        }
        
        return Calendar.current.date(byAdding: .month, value: amaunt, to: Date()) ?? self
    }
    
    func minusMonth(_ count: Int?)->Date{
        if let cnt = count{
            return addMonth(-cnt)
        }else{
            return addMonth(-1)
        }
    }
    
    func removeTimeStamp() -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            return self
        }
        return date
    }

}
