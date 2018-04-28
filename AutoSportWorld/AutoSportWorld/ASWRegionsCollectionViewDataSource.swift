//
//  ASWRegionsCollectionViewDataSource.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 16.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

protocol ASWRegionsCollectionViewDataSourceDelegate:ASWCollectionViewDataSourceDelegate{
    func updateSelectedRegions(regionsIDs:[Int])
}

class ASWRegionsCollectionViewDataSource: ASWCollectionViewDataSource {
    
    var delegate:ASWRegionsCollectionViewDataSourceDelegate?
    var selectedRegions:[Int] = [Int]()
    var regions = [ASWRaceRegion]()
    
    
    init(collectionView: UICollectionView, selectedRegions:[Int]) {
        super.init()
        self.selectedRegions = selectedRegions
        NotificationCenter.default.addObserver(self, selector: #selector(regionsCallback(_:)), name: .regionsCallback, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(regionsCallbackError(_:)), name: .regionsCallbackError, object: nil)
        
        self.collectionView = collectionView
        titleForSelectedItems = ["Выбранные регионы","",""]
        titleForAvailableItems = ["Выберите интересующий регион","",""]
        
        rawAvailableItems = []
        
        availableItems = rawAvailableItems
        selectedItems = rawSelectedItems
        
        //ASWNetworkManager.getRegions()
    }
    
    override func updateData() {
        super.updateData()
        ASWNetworkManager.getRegions()
    }
    
    @objc func regionsCallback(_ notification: Notification) {
        if let response = (notification.userInfo?["data"] as? ASWListRegionsParser) {
            rawAvailableItems  = []
            regions = response.regions
            setSelectedRegions(regionsIDs: selectedRegions)
            delegate?.dataReceived()
            isLoading = false
        }
    }
    
    func setSelectedRegions(regionsIDs:[Int]){
        selectedRegions = regionsIDs
        rawAvailableItems = []
        rawSelectedItems = []
        for region in regions{
            var id = Int(region.id ?? "0") ?? 0
            var string = "\(region.codes)\(region.name)\(region.centerCity)"
            var collectionItem = ASWCollectionItem(id,string)
            
            if(selectedRegions.contains(id)){
                rawSelectedItems.append(collectionItem)
            }else{
                rawAvailableItems.append(collectionItem)
            }
        }
        
        availableItems = rawAvailableItems
        selectedItems = rawSelectedItems
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView?.reloadData()
            //self?.delegate?.updateSelectedRegions(regionsIDs: self?.selectedRegions ?? [Int]())
        }
    }
    
    @objc func regionsCallbackError(_ notification: Notification) {
        delegate?.networkErrorOccured()
        isLoading = false
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ASWRegionCell", for: indexPath) as! ASWRegionCell
        
        
        
        if indexPath.section == 0 {
            cell.selectCell(indexPath: indexPath)
            var id = String(self.selectedItems[indexPath.item].id)
            if let item = regions.first(where: { $0.id == id }){
                cell.regionNumber.text = item.codes
                cell.name.text = item.name
            }else{
                cell.regionNumber.text = "error"
            }
            
        }
        else {
            cell.deselectCell()
            var id = String(self.availableItems[indexPath.item].id)
            if let item = regions.first(where: { $0.id == id }){
                cell.regionNumber.text = item.codes
                cell.name.text = item.name
            }else{
                cell.regionNumber.text = "error"
            }
        }
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty{
        availableItems = searchText.isEmpty ? rawAvailableItems : rawAvailableItems.filter { (item: ASWCollectionItem) -> Bool in
            
            return item.searchString.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        selectedItems = searchText.isEmpty ? rawSelectedItems : rawSelectedItems.filter { (item: ASWCollectionItem) -> Bool in
           
            return item.searchString.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }}else{
            selectedItems = rawSelectedItems
            availableItems = rawAvailableItems
        }

        collectionView.reloadData()    }
    
    override func itemSelected() {
        var selectedIDs = [Int]()
        for item in rawSelectedItems{
            selectedIDs.append(item.id)
        }
        delegate?.updateSelectedRegions(regionsIDs: selectedIDs)
    }
    
}


