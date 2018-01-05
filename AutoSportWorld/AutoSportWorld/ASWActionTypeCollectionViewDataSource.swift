//
//  ASWActionTypeCollectionViewDataSource.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 05.01.2018.
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

protocol ASWActionTypeCollectionViewDataSourceDelegate{
    func actionTypeSelected(auto:Bool,watch:Bool,join:Bool)
}

class ASWActionTypeCollectionViewDataSource: ASWCollectionViewDataSource {
    
    
    var delegate:ASWActionTypeCollectionViewDataSourceDelegate?
    var auto:Bool = false
    
    var watch:Bool = false
    var join:Bool = false

    var titles = ["Посмотреть","Покаткаться"]
    init(collectionView: UICollectionView, userModel:ASWUserEntity) {
        super.init()
        auto = false
        self.collectionView = collectionView
        titleForSelectedItems = "Мои действия"
        titleForAvailableItems = "Доступные действия"

        if(auto){
            watch = userModel.autoWatch
            join = userModel.autoJoin
        }else{
            watch = userModel.motoWatch
            join = userModel.motoJoin
        }
        
        
        //        0 - watch
        //        1 - join
        
        
            
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
        
        
        
        if indexPath.section == 0 {
            cell.selectCell()
            
            var image = UIImage.init(named: "ic_auto") ?? UIImage()
            cell.label.text = titles[self.selectedItems[indexPath.item].id]
//            if (self.selectedItems[indexPath.item].id == 0){
//                cell.label.text = watchTitle
//                //image =
//            }else{
//                cell.label.text = joinTitle
//            }
            //cell.label.text = "\(self.selectedItems[indexPath.item].id)"
        }
        else {
            cell.deselectCell()
            cell.label.text = titles[self.availableItems[indexPath.item].id]
            var image = UIImage.init(named: "ic_auto") ?? UIImage()
            
//            if (self.availableItems[indexPath.item].id == 0){
//                cell.label.text = watchTitle
//                //image =
//            }else{
//                cell.label.text = joinTitle
//            }
            //cell.label.text = "\(self.availableItems[indexPath.item].id)"
        }
        
        return cell
    }
    
    override func itemSelected(){
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


