//
//  ASWSportTypeCollectionViewDataSource.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 04.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

//
//  ASWCollectionViewDataSource.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 16.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//



import UIKit

protocol ASWSportTypeCollectionViewDataSourceDelegate{
    func sportTypeSelected(auto:Bool,moto:Bool)
}

class ASWSportTypeCollectionViewDataSource: ASWCollectionViewDataSource {
    
    var delegate:ASWSportTypeCollectionViewDataSourceDelegate?
    var titles = ["Автоспорт","Мотоспорт"]
    
    var moto = false
    var auto = false
    
    init(collectionView: UICollectionView, userModel:ASWUserEntity) {
        super.init()
        
        self.collectionView = collectionView
        titleForSelectedItems = "Мои виды спорта"
        titleForAvailableItems = "Доступные виды спорта"
        auto = userModel.auto
        moto = userModel.moto
        //        0 - auto
        //        1 - moto
        
        if auto {
            rawSelectedItems.append(ASWCollectionItem(0))
        }else{
            rawAvailableItems.append(ASWCollectionItem(0))
        }
        
        if moto {
            rawSelectedItems.append(ASWCollectionItem(1))
        }else{
            rawAvailableItems.append(ASWCollectionItem(1))
        }
        
        
//        for i in 0...1 {
//            var found = false
//            for item in userModel.sportTypes{
//                if item.id == i{
//                    found = true
//                }
//            }
//            if found {
//                rawSelectedItems.append(ASWCollectionItem(i))
//            }else{
//                rawAvailableItems.append(ASWCollectionItem(i))
//            }
//        }
        
        
        availableItems = rawAvailableItems
        selectedItems = rawSelectedItems
        
        
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        super .collectionView(collectionView, didSelectItemAt: indexPath)
//        
//    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ASWRaceTypeCell", for: indexPath) as! ASWRaceTypeCell
        
     
        
        if indexPath.section == 0 {
            cell.selectCell()

            var image = UIImage.init(named: "ic_auto") ?? UIImage()
            cell.label.text = titles[self.selectedItems[indexPath.item].id]
            
//            if (self.selectedItems[indexPath.item].id == 0){
//                cell.label.text = "Автоспорт"
//                //image =
//            }else{
//                cell.label.text = "Мотоспорт"
//            }
            //cell.label.text = "\(self.selectedItems[indexPath.item].id)"
        }
        else {
            cell.deselectCell()

            var image = UIImage.init(named: "ic_auto") ?? UIImage()
            cell.label.text = titles[self.availableItems[indexPath.item].id]
//            if (self.availableItems[indexPath.item].id == 0){
//                cell.label.text = "Автоспорт"
//                //image =
//            }else{
//                cell.label.text = "Мотоспорт"
//            }
            //cell.label.text = "\(self.availableItems[indexPath.item].id)"
        }
        
        return cell
    }
    
    override func itemSelected(){
        auto = false
        moto = false
        for item in selectedItems{
            if item.id == 0 {
                auto = true
            }
            if item.id == 1 {
                moto = true
            }
        }
        delegate?.sportTypeSelected(auto: auto, moto: moto)
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

