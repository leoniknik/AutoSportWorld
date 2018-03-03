//
//  ASWRaceTypeCollectionViewDataSource.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 05.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//


//
//  ASWRegionsCollectionViewDataSource.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 16.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit
import Kingfisher

protocol ASWRaceCategoryCollectionViewDataSourceDelegate:ASWCollectionViewDataSourceDelegate{
    func updateSelectedRaceTypes(auto:Bool,raceTypeIDs:[Int])
}

class ASWRaceCategoryCollectionViewDataSource: ASWCollectionViewDataSource {
    
    var delegate:ASWRaceCategoryCollectionViewDataSourceDelegate?
    var selectedRaceCategory:[Int] = [Int]()
    var raceCategories = [ASWRaceCategory]()
    var auto:Bool = false
    
    private let imageService = ASWImageDownloader()
    
    init(collectionView: UICollectionView, selectedRaceCategory:[Int], auto:Bool) {
        super.init()
        self.selectedRaceCategory = selectedRaceCategory
        
        NotificationCenter.default.addObserver(self, selector: #selector(raceCategoryCallback(_:)), name: .raceCategoryCallback, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(raceCategoryCallbackError(_:)), name: .raceCategoryCallbackError, object: nil)
        
        self.collectionView = collectionView
        self.auto = auto
        
        if(auto){
            titleForSelectedItems = ["Выбранные виды ","автогонок",""]
            titleForAvailableItems = ["Выберите интересующий вид ","автогонок",""]
        }else{
            titleForSelectedItems = ["Выбранные виды ","мотогонок",""]
            titleForAvailableItems = ["Выберите интересующий вид ","мотогонок",""]
        }
        
        
        rawAvailableItems = []
        
        availableItems = rawAvailableItems
        selectedItems = rawSelectedItems
        
        //ASWNetworkManager.getRaceTypes(type: auto ? "auto" : "moto")
    }
    
    override func updateData() {
        super.updateData()
        ASWNetworkManager.getRaceTypes(type: auto ? "auto" : "moto")
    }
    
    @objc func raceCategoryCallback(_ notification: Notification) {
        if let response = (notification.userInfo?["data"] as? ASWListCategoryParser) {
            if let category = response.categories.first{
                if(category.auto == auto){
                    rawAvailableItems  = []
                    raceCategories = response.categories
                    setSelectedCategories(categoryIDs: selectedRaceCategory)
                    delegate?.dataReceived()
                    isLoading = false;
                }
            }
            
        }
    }
    
    func setSelectedCategories(categoryIDs:[Int]){
        rawAvailableItems = []
        rawSelectedItems = []
        selectedRaceCategory = categoryIDs
        for category in raceCategories{
            var id = Int(category.id ?? "0") ?? 0
            var string = "\(category.name)"
            var collectionItem = ASWCollectionItem(id,string)
            
            if(selectedRaceCategory.contains(id)){
                //if let item = userEntity.autoRegions.first(where: { $0.id == id }){
                rawSelectedItems.append(collectionItem)
            }else{
                rawAvailableItems.append(collectionItem)
            }
        }
        
        availableItems = rawAvailableItems
        selectedItems = rawSelectedItems
        DispatchQueue.main.async { [weak self] in
            self?.collectionView?.reloadData()
            self?.delegate?.updateSelectedRaceTypes(auto:self?.auto ?? false, raceTypeIDs: self?.selectedRaceCategory ?? [Int]())
        }
    }
    
    @objc func raceCategoryCallbackError(_ notification: Notification) {
        isLoading = false
        delegate?.networkErrorOccured()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ASWRaceTypeCell", for: indexPath) as! ASWRaceTypeCell
        
        
        var item:ASWRaceCategory? = nil
        
        if indexPath.section == 0 {
            cell.selectCell()
            var id = String(self.selectedItems[indexPath.item].id)
            item = raceCategories.first(where: { $0.id == id })
        }
        else {
            cell.deselectCell()
            var id = String(self.availableItems[indexPath.item].id)
            item = raceCategories.first(where: { $0.id == id })
        }
        
        if  let curItem = item {
            cell.label.text = curItem.name
            
            if let image = curItem.image {
               cell.image.image = image
            }
            else {
                let ciImage = CIImage(image: #imageLiteral(resourceName: "auto"))
                let grayscale = ciImage?.applyingFilter("CIColorControls",
                                                        parameters: [ kCIInputSaturationKey: 0.0 ])
          
                cell.image.image = UIImage(ciImage: grayscale!)
                
                //UIImage( grayscale!)
                
                cell.image.kf.setImage(with: URL(string:curItem.imageUrl ?? "")!, completionHandler: {
                    (image, error, cacheType, imageUrl) in
                    if let img = image{
                        //DispatchQueue.main.async {
                            //[weak self] in
                            curItem.image = img
                        //}
                    }
                })
                
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    ImageDownloader.default.downloadImage(with: URL(string:curItem.imageUrl ?? "")!, options: [], progressBlock: nil) {
//                        (image, error, url, data) in
//                        if let img = image{
//                            curItem.image = img
//
//                            DispatchQueue.main.async { [weak self] in
//                                //self?.collectionView.reloadData()
//                                //cell.image.image = img
//                            }
//                        }
//                    }
                
                    
                    
                    
                    
                    //                    self?.imageService.send(url: curItem.imageUrl!, completionHandler: { (image) in
                    //                        curItem.image = image
                    //                        DispatchQueue.main.async { [weak self] in
                    //
                    ////                            if indexPath.section <= 1 {
                    ////                                if(indexPath.section == 0){
                    ////                                    if(self?.availableItems.count ?? 0 <= indexPath.row){
                    ////                                        self?.collectionView.reloadItems(at: [indexPath])
                    ////                                    }
                    ////                                }else{
                    ////                                    if(self?.selectedItems.count ?? 0 <= indexPath.row){
                    ////                                        self?.collectionView.reloadItems(at: [indexPath])
                    ////                                    }
                    ////                                }
                    ////                            }
                    //                            self?.collectionView.reloadData()
                    //
                    //
                    ////                            if cell != nil{
                    ////                                //self?.collectionView.reloadItems(at: [indexPath])
                    ////                                self?.collectionView.reloadData()
                    ////                            }
                    //
                    //                        }
                    //                    })
                    
//                }
         }
        }else{
            cell.label.text = ""
        }
        
        return cell
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        availableItems = searchText.isEmpty ? rawAvailableItems : rawAvailableItems.filter { (item: ASWCollectionItem) -> Bool in
            
            return item.searchString.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        selectedItems = searchText.isEmpty ? rawSelectedItems : rawSelectedItems.filter { (item: ASWCollectionItem) -> Bool in
            
            return item.searchString.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        collectionView.reloadData()
    }
    
    override func itemSelected() {
        var selectedIDs = [Int]()
        for item in rawSelectedItems{
            selectedIDs.append(item.id)
        }
        delegate?.updateSelectedRaceTypes(auto:auto, raceTypeIDs: selectedIDs)
    }
}




