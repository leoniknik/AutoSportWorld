//
//  ASWDatabaseManager.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 02.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import Foundation
import RealmSwift

class ASWDatabaseManager {
    
    func getUser() -> ASWUserEntity? {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "isLogedIn == true")
        return realm.objects(ASWUserEntity.self).filter(predicate).first
    }
    
    func getRaceBy(id: Int) -> ASWRaceEntity? {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "id == \(id)")
        return realm.objects(ASWRaceEntity.self).filter(predicate).first
    }
    
    func getRaceIds() -> [Int]? {
        
        guard let user = getUser() else {
            return nil
        }

        return user.favoriteRaces.map{$0.id}
    }
    
    func createTestUser() {
        
        let testUser = ASWUserEntity()
        testUser.id = 0
        testUser.isLogedIn = true
        self.save(object: testUser)
    }
    
    func bookmarkRace(withID id: Int) {
        let realm = try! Realm()
        
        guard let user = getUser() else {
            return
        }
        
        let predicate = NSPredicate(format: "id == \(id)")
        
        //если у пользователя есть уже в заметках эта гонка
        if let race = user.favoriteRaces.filter(predicate).first {
            for (index, item) in user.favoriteRaces.enumerated() {
                if item == race {
                    try! realm.write {
                        user.favoriteRaces.remove(at: index)
                    }
                    break
                }
            }
        }
        else {
            //если такая гонка есть в базе данных, например у других пользователей
            if let race = getRaceBy(id: id) {
                try! realm.write {
                    user.favoriteRaces.append(race)
                 }
            }
            else {
                let race: ASWRaceEntity = ASWRaceEntity()
                race.id = id
                try! realm.write {
                    user.favoriteRaces.append(race)
                }
            }
        }
    }
    
    func checkBookmarkedRace(withID id: Int) -> Bool {
        
        guard let user = getUser() else {
            return false
        }
        
        let predicate = NSPredicate(format: "id == \(id)")

        guard let _ = user.favoriteRaces.filter(predicate).first else {
            return false
        }
        
        return true
    }
    
    private func save(object: Object){
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(object, update: true)
        }
    }
    
    private func delete(object: Object){
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(object)
        }
    }
}
