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
    
    func checkPermission()->Bool{
        return getUser() != nil
    }
    
    func getUser() -> ASWUserEntity? {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "isLogedIn == true")
        return realm.objects(ASWUserEntity.self).filter(predicate).first
    }
    
    func unloginAllUsers(){
        let realm = try! Realm()
        for user in realm.objects(ASWUserEntity.self){
            try! realm.write {
                user.isLogedIn = false
            }
        }
    }
    
    func loginUser(login:String,password:String)->ASWUserEntity{
        unloginAllUsers()
        let realm = try! Realm()
        let predicate = NSPredicate(format: "email == '\(login)'")
        if (realm.objects(ASWUserEntity.self).filter(predicate).count>1){
            for user in realm.objects(ASWUserEntity.self).filter(predicate){
                realm.delete(user)
            }
            return createUserFrom(login:login,password:password)
        } else if let user = realm.objects(ASWUserEntity.self).filter(predicate).first{
            //try! realm.write {
                //user.password = password
            //}
            return user
        }else{
            return createUserFrom(login:login,password:password)
        }
    }
    
    func loginUser(parser:ASWLoginSucsessParser)->ASWUserEntity{
        unloginAllUsers()
        let realm = try! Realm()
        let predicate = NSPredicate(format: "email == '\(parser.email)'")
        if let user = realm.objects(ASWUserEntity.self).filter(predicate).first{
            try! realm.write {
                //user.password = parser.password
                user.isLogedIn = true
            }
            save(object: user)
            let sessionInfoParser = parser.sessionInfoParser
                setSessionInfo(refresh_token: sessionInfoParser.refresh_token, access_token: sessionInfoParser.access_token, expires_at: sessionInfoParser.expires_at)
            
            
            return user
        }else{
            let user = createUserFrom(login:parser.email,password:parser.password)
            let sessionInfoParser = parser.sessionInfoParser
            setSessionInfo(refresh_token: sessionInfoParser.refresh_token, access_token: sessionInfoParser.access_token, expires_at: sessionInfoParser.expires_at)
            
            return user
        }
    }
    
    func createUserFrom(login: String, password:String) -> ASWUserEntity {
        unloginAllUsers()
        
        let user = ASWUserEntity()
        user.id =  Int(Date().timeIntervalSince1970*1000)
        user.email = login
        user.isLogedIn = true
        save(object: user)
        return user
    }
    
    func updateUserFrom(login:String,
                        email:String,
                        password:String,
                        auto:Bool,
                        moto:Bool,
                        join:Bool,
                        watch:Bool,
                        regions:[Int],
                        autoCategories:[Int],
                        motoCategories:[Int])->ASWUserEntity{
        
        let user = getUser() ?? ASWUserEntity()
        let realm = try! Realm()
        try! realm.write {
            user.email = login
            user.isLogedIn = true
            user.login = login
            user.auto=auto
            user.moto=moto
            user.watch = watch
            user.join = join
        }
        save(object: user)
        
        setUserRegions(regionIDs: regions)
        if user.auto{
            setUserRaceCategories(categoriesIDs: autoCategories, auto: true)
        }else{
            setUserRaceCategories(categoriesIDs: [], auto: true)
        }
        
        if user.moto{
            setUserRaceCategories(categoriesIDs: motoCategories, auto: false)
        }else{
            setUserRaceCategories(categoriesIDs: [], auto: false)
        }
        
        
        return user
    }
    func createUserFrom(login:String,
                        email:String,
                        password:String,
                        auto:Bool,
                        moto:Bool,
                        join:Bool,
                        watch:Bool,
                        regions:[Int],
                        autoCategories:[Int],
                        motoCategories:[Int])->ASWUserEntity{

        unloginAllUsers()
        
        let user = loginUser(login:login,password:password)
        let realm = try! Realm()
        try! realm.write {
            user.email = email
            user.isLogedIn = true
            user.login = login
            user.auto=auto
            user.moto=moto
            user.watch = watch
            user.join = join
        }
        save(object: user)
        
        setUserRegions(regionIDs: regions)
        setUserRaceCategories(categoriesIDs: autoCategories, auto: true)
        setUserRaceCategories(categoriesIDs: motoCategories, auto: false)
        return user
    }
    
    func setSessionInfo(refresh_token:String,access_token:String,expires_at:Int){
        let realm = try! Realm()
        let user = getUser()!
        try! realm.write {
            user.refresh_token = refresh_token
            user.access_token = access_token
            user.expires_at = expires_at
        }
    }
    
    func setUserPrivateInfo(name:String,phone:String){
        let realm = try! Realm()
        let user = getUser()!
        try! realm.write {
            user.phone = phone
            user.login = name
        }
    }
    
    func setUserInfo(parser:ASWUserInfoGetParser){
        let realm = try! Realm()
        let user = getUser()!
        try! realm.write {
            user.join = parser.canJoin
            user.watch = parser.canWatch
            user.auto = parser.categoriesParser.autoCategoryIDs.count > 0
            user.moto = parser.categoriesParser.motoCategoryIDs.count > 0
        }
        
        setUserRaceCategories(categoriesIDs: parser.categoriesParser.autoCategoryIDs, auto: true)
        setUserRaceCategories(categoriesIDs: parser.categoriesParser.motoCategoryIDs, auto: false)
        setUserRegions(regionIDs: parser.regionsParser.regionsIDs)
    }
    
    func sendUserInfoToServer(completion:@escaping ()->Void,error:@escaping (ASWErrorParser)->Void){
        func sucsess(parser:ASWUserInfoSendParser){
            completion()
        }
        
        func error(parser:ASWErrorParser){
            error(parser)
        }
        
        guard let user = getUser() else{
            return
        }
        
        var categories = [String]()
        if(user.auto){
            categories.append(contentsOf: getStringCategoriesIds(auto: true) ?? [String]())
        }
        if user.moto{
            categories.append(contentsOf: getStringCategoriesIds(auto: false) ?? [String]())
        }
        
//        var categories = getStringCategoriesIds(auto: true) ?? [String]()
//        categories.append(contentsOf: getStringCategoriesIds(auto: false) ?? [String]())
        ASWNetworkManager.sendUserInfo(regions: getStringRegionsIds() ?? [String](), categories: categories, watch: user.watch, join: user.join, sucsessFunc: sucsess, errorFunc: error)
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

        try! realm.write {
            user.regions.removeAll()
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
    
    func setUserFilters(_ values: [[Bool]]) {
        let realm = try! Realm()
        
        guard let user = getUser() else{
            return
        }
        
        try! realm.write {
            if values[0][0] == true {
                user.dataFilter = 1
            } else {
                user.dataFilter = 0
            }
            user.costFilter = -1
            if values[1][0] == true {
                user.costFilter = 0
            }
            if values[1][1] == true {
                user.costFilter = 1
            }
            if values[1][2] == true {
                user.costFilter = 2
            }
        }
    }
    
    func getUserFilters() -> [[Bool]]? {
        guard let user = getUser() else{
            return nil
        }
        
        var values = [[true], [false, false, false]]
        if user.dataFilter == 1 {
            values[0][0] = true
        } else {
            values[0][0] = false
        }
        if user.costFilter == -1 {
            values[1] = [false, false, false]
        }
        if user.costFilter == 0 {
            values[1] = [true, false, false]
        }
        if user.costFilter == 1 {
            values[1] = [false, true, false]
        }
        if user.costFilter == 2 {
            values[1] = [false, false, true]
        }
        return values
    }
    
    func setUserRaceCategories(categoriesIDs:[Int], auto:Bool){
        let realm = try! Realm()
        
        guard let user = getUser() else{
            return
        }
        
        if auto {
            try! realm.write {
                user.autoCategories.removeAll()
            }
            
        }else{
            try! realm.write {
                user.motoCategories.removeAll()
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
            user.watch = watch
            user.join = join
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
    
    func getStringRegionsIds() -> [String]? {
        guard let user = getUser() else {
            return nil
        }
        return user.regions.map{ String($0.id) }
    }
    
    func getCategoriesIds(auto:Bool) -> [Int]? {
        guard let user = getUser() else {
            return nil
        }
        
        return auto ? user.autoCategories.map{ $0.id } : user.motoCategories.map{ $0.id }
    }
    
    func getStringCategoriesIds(auto:Bool) -> [String]? {
        guard let user = getUser() else {
            return nil
        }
        
        return auto ? user.autoCategories.map{ String($0.id) } : user.motoCategories.map{ String($0.id) }
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
