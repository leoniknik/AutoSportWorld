//
//  ASWCollectionViewDataSource.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 16.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWCollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    var collectionView: UICollectionView!
    var isSearching: Bool = false
    
    var rawAvailableItems: [ASWCollectionItem] = []
    var rawSelectedItems: [ASWCollectionItem] = []
    
    var availableItems: [ASWCollectionItem] = []
    var selectedItems: [ASWCollectionItem] = []
    
    var titleForSelectedItems: String = ""
    var titleForAvailableItems: String = ""
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return selectedItems.count
        }
        else {
            return availableItems.count
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: "ASWCollectionReusableView", for: indexPath) as! ASWCollectionReusableView
            if indexPath.section == 0 {
                headerView.header.text = self.titleForSelectedItems + " (\(self.selectedItems.count))"
            }
            else {
                headerView.header.text = self.titleForAvailableItems + " (\(self.availableItems.count))"
            }
            headerView.header.textColor = UIColor.ASWColor.grey
            return headerView
        default:
            assert(false, "Unexpected element kind")
            
        }
    }
    
    func itemSelected(){
        
    }
    
    func syncItems() {
        
        guard isSearching else {
            rawAvailableItems = availableItems
            rawSelectedItems = selectedItems
            return
        }
        
        for availableItem in availableItems {
            if let index = rawSelectedItems.index(where: { $0.id == availableItem.id }){
                rawSelectedItems.remove(at: index)
                rawAvailableItems.append(availableItem)
            }
        }
        
        for selectedItem in selectedItems {
            if let index = rawAvailableItems.index(where: { $0.id == selectedItem.id }){
                rawAvailableItems.remove(at: index)
                rawSelectedItems.append(selectedItem)
            }
        }
        
        availableItems = rawAvailableItems
        selectedItems = rawSelectedItems
        isSearching = false
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
}
