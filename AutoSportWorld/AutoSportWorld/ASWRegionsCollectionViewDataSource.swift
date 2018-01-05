//
//  ASWRegionsCollectionViewDataSource.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 16.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWRegionsCollectionViewDataSource: ASWCollectionViewDataSource {
    
    init(collectionView: UICollectionView) {
        super.init()
        
        self.collectionView = collectionView
        
        titleForSelectedItems = "Мои регионы"
        titleForAvailableItems = "Доступные регионы"
        
        rawAvailableItems =
            
            [ASWCollectionItem(0),ASWCollectionItem(1),ASWCollectionItem(2),ASWCollectionItem(3),ASWCollectionItem(4),ASWCollectionItem(5),ASWCollectionItem(6),ASWCollectionItem(7),ASWCollectionItem(8),ASWCollectionItem(9),ASWCollectionItem(10)]
        
        availableItems = rawAvailableItems
        selectedItems = rawSelectedItems
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ASWRegionCell", for: indexPath) as! ASWRegionCell
        
        if indexPath.section == 0 {
            cell.selectCell()
            cell.regionNumber.text = "\(self.selectedItems[indexPath.item].id)"
        }
        else {
            cell.deselectCell()
            cell.regionNumber.text = "\(self.availableItems[indexPath.item].id)"
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
    
}


//class ASWRegionsCollectionViewDataSource: ASWCollectionViewDataSource {
//
//    init(collectionView: UICollectionView) {
//        super.init()
//
//        self.collectionView = collectionView
//
//        titleForSelectedItems = "Мои регионы"
//        titleForAvailableItems = "Доступные регионы"
//
//        rawAvailableItems = [ASWCollectionItem(0),ASWCollectionItem(1),ASWCollectionItem(2),ASWCollectionItem(3),ASWCollectionItem(4),ASWCollectionItem(5),ASWCollectionItem(6),ASWCollectionItem(7),ASWCollectionItem(8),ASWCollectionItem(9),ASWCollectionItem(10)]
//
//        availableItems = rawAvailableItems
//        selectedItems = rawSelectedItems
//
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ASWRegionCell", for: indexPath) as! ASWRegionCell
//
//        if indexPath.section == 0 {
//            cell.selectCell()
//            cell.regionNumber.text = "\(self.selectedItems[indexPath.item].id)"
//        }
//        else {
//            cell.deselectCell()
//            cell.regionNumber.text = "\(self.availableItems[indexPath.item].id)"
//        }
//
//        return cell
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        availableItems = searchText.isEmpty ? rawAvailableItems : rawAvailableItems.filter { (item: ASWCollectionItem) -> Bool in
//            let string = "\(item.id)"
//            return string.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
//        }
//
//        selectedItems = searchText.isEmpty ? rawSelectedItems : rawSelectedItems.filter { (item: ASWCollectionItem) -> Bool in
//            let string = "\(item.id)"
//            return string.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
//        }
//
//        collectionView.reloadData()
//    }
//
//}

