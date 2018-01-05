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

protocol ASWRaceCategoryCollectionViewDataSourceDelegate{
    func updateSelectedRaceTypes(raceTypeIDs:[Int])
}

class ASWRaceCategoryCollectionViewDataSource: ASWCollectionViewDataSource {
    
    var delegate:ASWRaceCategoryCollectionViewDataSourceDelegate?
    var selectedRaceCategory:[Int] = [Int]()
    var raceCategories = [ASWRaceCategory]()
    
    
    init(collectionView: UICollectionView, selectedRaceCategory:[Int]) {
        super.init()
        self.selectedRaceCategory = selectedRaceCategory
        
        NotificationCenter.default.addObserver(self, selector: #selector(regionsCallback(_:)), name: .regionsCallback, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(regionsCallbackError(_:)), name: .regionsCallbackError, object: nil)
        
        self.collectionView = collectionView
        
        titleForSelectedItems = "Мои регионы"
        titleForAvailableItems = "Доступные регионы"
        
        rawAvailableItems = []
        
        availableItems = rawAvailableItems
        selectedItems = rawSelectedItems
        
        //ASWNetworkManager.getRegions()
    }
    
    @objc func regionsCallback(_ notification: Notification) {
//        if let response = (notification.userInfo?["data"] as? ASWListRegionsParser) {
//            rawAvailableItems  = []
//            regions = response.regions
//            for region in response.regions{
//                var id = Int(region.id ?? "0") ?? 0
//                var collectionItem = ASWCollectionItem(id)
//
//                if(selectedRegions.contains(id)){
//                    //if let item = userEntity.autoRegions.first(where: { $0.id == id }){
//                    rawSelectedItems.append(collectionItem)
//                }else{
//                    rawAvailableItems.append(collectionItem)
//                }
//            }
//        }
//        availableItems = rawAvailableItems
//        selectedItems = rawSelectedItems
//        weak var weakself = self
//        DispatchQueue.main.async {
//            weakself?.collectionView?.reloadData()
//        }
//
//
//
}
    
    @objc func regionsCallbackError(_ notification: Notification) {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ASWRegionCell", for: indexPath) as! ASWRegionCell
        
        
        
        if indexPath.section == 0 {
            cell.selectCell()
            var id = String(self.selectedItems[indexPath.item].id)
            if let item = raceCategories.first(where: { $0.id == id }){
                cell.regionNumber.text = id
                cell.name.text = item.name
            }else{
                cell.regionNumber.text = id
            }
            
        }
        else {
            cell.deselectCell()
            var id = String(self.availableItems[indexPath.item].id)
            if let item = raceCategories.first(where: { $0.id == id }){
                cell.regionNumber.text = id
                cell.name.text = item.name
            }else{
                cell.regionNumber.text = id
            }
        }
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        availableItems = searchText.isEmpty ? rawAvailableItems : rawAvailableItems.filter { (item: ASWCollectionItem) -> Bool in
            let string = "\(item.id)"
            return string.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        selectedItems = searchText.isEmpty ? rawSelectedItems : rawSelectedItems.filter { (item: ASWCollectionItem) -> Bool in
            let string = "\(item.id)"
            return string.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        collectionView.reloadData()
    }
    
    override func itemSelected() {
        var selectedIDs = [Int]()
        for item in rawSelectedItems{
            selectedIDs.append(item.id)
        }
        delegate?.updateSelectedRaceTypes(raceTypeIDs: selectedIDs)
    }
    
}


