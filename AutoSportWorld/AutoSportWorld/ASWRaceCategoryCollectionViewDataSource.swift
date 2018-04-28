//
//  ASWRaceTypeCollectionViewDataSource.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 05.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
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
            cell.selectCell(indexPath: indexPath)
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
      
                cell.image.kf.setImage(with: URL(string:curItem.imageUrl ?? "")!, completionHandler: {
                    (image, error, cacheType, imageUrl) in
                    if let img = image{
                        curItem.image = img
                    }
                })
                let ciImage = CIImage(image: #imageLiteral(resourceName: "auto"))
                if #available(iOS 11.0, *) {
                    let grayscale = ciImage?.applyingFilter("CIColorControls")
                    cell.image.image = UIImage(ciImage: grayscale!)
                } else {
                    cell.image.image = #imageLiteral(resourceName: "auto")
                }
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




