//
//  ASWRegionsCollectionViewDataSource.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 16.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWRegionsCollectionViewDataSource: ASWCollectionViewDataSource {
    
    override init() {
        super.init()
        
        titleForSelectedItems = "Мои регионы"
        titleForAvailableItems = "Доступные регионы"
        
        self.availableItems = [ASWCollectionItem("0"),ASWCollectionItem("1"),ASWCollectionItem("2"),ASWCollectionItem("3"),ASWCollectionItem("4"),ASWCollectionItem("5"),ASWCollectionItem("6"),ASWCollectionItem("7"),ASWCollectionItem("8"),ASWCollectionItem("9"),ASWCollectionItem("10")]
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ASWRegionCell", for: indexPath) as! ASWRegionCell
        
        if indexPath.section == 0 {
            cell.selectCell()
            cell.regionNumber.text = self.selectedItems[indexPath.item].temp
        }
        else {
            cell.deselectCell()
            cell.regionNumber.text = self.availableItems[indexPath.item].temp
        }
        
        return cell
    }
    
}
