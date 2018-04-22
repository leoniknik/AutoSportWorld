//
//  ASWCollectionViewDataSource.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 16.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

protocol ASWCollectionViewDataSourceDelegate{
    func dataReceived()
    func networkErrorOccured()
}

class ASWCollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var collectionView: UICollectionView!
    var isSearching: Bool = false
    
    var rawAvailableItems: [ASWCollectionItem] = []
    var rawSelectedItems: [ASWCollectionItem] = []
    
    var availableItems: [ASWCollectionItem] = []
    var selectedItems: [ASWCollectionItem] = []
    
    var titleForSelectedItems: [String] = ["","",""]
    var titleForAvailableItems: [String] = ["","",""]
    
    var isLoading: Bool = false
    
    var queue = OperationQueue.init()
    
    override init() {
        queue.qualityOfService = .userInitiated
    }
    
    func updateData(){
        isLoading = true
    }
    
    func isEmptyDatasource()->Bool{
        return rawSelectedItems.count == 0 && rawAvailableItems.count == 0
    }
    
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
            
            headerView.header.lineBreakMode = .byWordWrapping
            headerView.header.numberOfLines = 2
            headerView.header.textAlignment = .center
            
            if indexPath.section == 0 {
                
                var ending = titleForSelectedItems[2] + " (\(self.selectedItems.count))"
                let title = ASWAtributedString.getAtributedString(begining: titleForSelectedItems[0], bold: titleForSelectedItems[1], end: ending,color:UIColor.ASWColor.grey)
                headerView.header.attributedText = title
            }
            else {
                var ending = titleForAvailableItems[2] + " (\(self.availableItems.count))"
                let title = ASWAtributedString.getAtributedString(begining: titleForAvailableItems[0], bold: titleForAvailableItems[1], end: ending, color: UIColor.ASWColor.grey)
                headerView.header.attributedText = title
//                headerView.header.text = self.titleForAvailableItems + " (\(self.availableItems.count))"
            }
            
            //headerView.header.text = "11111 222222   3333333 444444 555555 66666 888888 9999999 9999999"
            
           // headerView.header.textColor = UIColor.ASWColor.grey
            return headerView
        default:
            assert(false, "Unexpected element kind")
            return UICollectionReusableView()
        }
    }
    
    func itemSelected(){
        
    }
    
    func syncItems() {
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
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //isSearching = true
    }
}
