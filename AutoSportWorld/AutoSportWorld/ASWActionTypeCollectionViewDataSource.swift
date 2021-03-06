//
//  ASWActionTypeCollectionViewDataSource.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 05.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

protocol ASWActionTypeCollectionViewDataSourceDelegate{
    func actionTypeSelected(auto:Bool,watch:Bool,join:Bool)
}

class ASWActionTypeCollectionViewDataSource: ASWCollectionViewDataSource {
    
    
    var delegate:ASWActionTypeCollectionViewDataSourceDelegate?
    var auto:Bool = false
    
    var watch:Bool = false
    var join:Bool = false

    var titles = ["Посмотреть","Покататься"]
    init(collectionView: UICollectionView, auto:Bool, join:Bool, watch:Bool) {
        super.init()
        self.auto = auto
        self.collectionView = collectionView
        self.watch = watch
        self.join = join

        if(auto){
            
            titleForSelectedItems = ["Выбранные действия ","",""]
            titleForAvailableItems = ["Выберите интересующее действие","",""]
        }else{
            
            titleForSelectedItems = ["Выбранные действия","",""]
            titleForAvailableItems = ["Выберите интересующее действие","",""]
        }

            if watch {
                rawSelectedItems.append(ASWCollectionItem(0))
            }else{
                rawAvailableItems.append(ASWCollectionItem(0))
            }
            
            if join {
                rawSelectedItems.append(ASWCollectionItem(1))
            }else{
                rawAvailableItems.append(ASWCollectionItem(1))
            }
        availableItems = rawAvailableItems
        selectedItems = rawSelectedItems
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ASWRaceTypeCell", for: indexPath) as! ASWRaceTypeCell
        
        var id = 0
        
        if indexPath.section == 0 {
            cell.selectCell(indexPath: indexPath)
            cell.label.text = titles[self.selectedItems[indexPath.item].id]
            id = self.selectedItems[indexPath.item].id
        }
        else {
            cell.deselectCell()
            cell.label.text = titles[self.availableItems[indexPath.item].id]
            id = self.availableItems[indexPath.item].id
        }
        
        if id == 0 {
            cell.image.image = auto ? UIImage.autoWatch : UIImage.motoWatch
        }else{
            cell.image.image = auto ? UIImage.autoJoin : UIImage.motoJoin
        }
        
        return cell
    }
    
    override func itemSelected(){
        watch = false
        join = false
        for item in selectedItems{
            if item.id == 0 {
                watch = true
            }
            if item.id == 1 {
                join = true
            }
        }
        delegate?.actionTypeSelected(auto: auto, watch: watch, join: join)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        availableItems = searchText.isEmpty ? rawAvailableItems : rawAvailableItems.filter { (item: ASWCollectionItem) -> Bool in
            let string = titles[item.id]
            
            
            return string.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        selectedItems = searchText.isEmpty ? rawSelectedItems : rawSelectedItems.filter { (item: ASWCollectionItem) -> Bool in
            let string = titles[item.id]
            return string.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        collectionView.reloadData()
    }
    
}


