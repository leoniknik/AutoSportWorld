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
    
    func unloginAllUsers(){
        let realm = try! Realm()
        for user in realm.objects(ASWUserEntity.self){
            user.isLogedIn = false
            save(object: user)
        }
    }
    
    func loginUser(login:String,password:String)->ASWUserEntity{
        unloginAllUsers()
        let realm = try! Realm()
        let predicate = NSPredicate(format: "email == \(login)")
        if let user = realm.objects(ASWUserEntity.self).filter(predicate).first{
            user.password = password
            save(object: user)
            return user
        }else{
            return createUser(login:login,password:password)
        }
    }
    
    func createUser(login:String,password:String)->ASWUserEntity{
        unloginAllUsers()
        
        var user = ASWUserEntity()
        user.id =  Int(Date().timeIntervalSince1970)
        user.email = login
        user.password = password
        user.isLogedIn = true
        save(object: user)
        
        return user
    }
    
    func updateUserInfoFromServer(){
        // some info
    }
    
    func getUserBy(id:Int) -> ASWUserEntity? {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "id == \(id)")
        return realm.objects(ASWUserEntity.self).filter(predicate).first
    }
    
    func setUserRegions(regionIDs:[Int]){
        let realm = try! Realm()
        
        guard let user = getUser() else{
            return
        }
        
        for (index, item) in user.regions.enumerated() {
            try! realm.write {
                user.regions.remove(objectAtIndex: index)
            }
        }
        
        for id in regionIDs{
            if let region = getRegionBy(id: id) {
                try! realm.write {
                    user.regions.append(region)
                }
            }
            else {
                let region = ASWRegionEntity()
                region.id = id
                save(object: region)
                try! realm.write {
                    user.regions.append(region)
                }
            }
        }
    }
    
    func setUserRaceCategories(categoriesIDs:[Int], auto:Bool){
        let realm = try! Realm()
        
        guard let user = getUser() else{
            return
        }
        
        if auto {
            for (index, item) in user.autoCategories.enumerated() {
                try! realm.write {
                    user.regions.remove(objectAtIndex: index)
                }
            }
        }else{
            for (index, item) in user.motoCategories.enumerated() {
                try! realm.write {
                    user.regions.remove(objectAtIndex: index)
                }
            }
        }
        
        if auto{
            for id in categoriesIDs{
                if let category = getCategoryBy(id: id) {
                    try! realm.write {
                        user.autoCategories.append(category)
                    }
                }
                else {
                    let category = ASWRaceCategoryEntity()
                    category.id = id
                    save(object: category)
                    try! realm.write {
                        user.autoCategories.append(category)
                    }
                }
            }
        }else{
            for id in categoriesIDs{
                if let category = getCategoryBy(id: id) {
                    try! realm.write {
                        user.motoCategories.append(category)
                    }
                }
                else {
                    let category = ASWRaceCategoryEntity()
                    category.id = id
                    save(object: category)
                    try! realm.write {
                        user.motoCategories.append(category)
                    }
                }
            }
        }
        
        
    }
    
    func setUserSportTypes(auto:Bool,moto:Bool){
        let realm = try! Realm()
        
        guard let user = getUser() else{
            return
        }
        
        try! realm.write {
            user.auto = auto
            user.moto = moto
        }
    }
    
    func setUserActions(auto:Bool,watch:Bool,join:Bool){
        let realm = try! Realm()
        
        guard let user = getUser() else{
            return
        }
        
        try! realm.write {
            if auto {
                user.autoWatch = watch
                user.autoJoin = join
            }else{
                user.motoWatch = watch
                user.motoJoin = join
            }
        }
    }
    
    func saveUser(user:ASWUserEntity){
        save(object: user)
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
        
        return user.favoriteRaces.map{ $0.id }
    }
    
    func getRegionBy(id: Int) -> ASWRegionEntity? {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "id == \(id)")
        return realm.objects(ASWRegionEntity.self).filter(predicate).first
    }
    
    func getCategoryBy(id: Int) -> ASWRaceCategoryEntity? {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "id == \(id)")
        return realm.objects(ASWRaceCategoryEntity.self).filter(predicate).first
    }
    
    func getRegionsIds() -> [Int]? {
        guard let user = getUser() else {
            return nil
        }
        return user.regions.map{ $0.id }
    }
    
    func getCategoriesIds(auto:Bool) -> [Int]? {
        guard let user = getUser() else {
            return nil
        }
        
        return auto ? user.autoCategories.map{ $0.id } : user.motoCategories.map{ $0.id }
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
                        user.favoriteRaces.remove(objectAtIndex: index)
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
