//
//  ASWChangeRegionsViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 12.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWChangeRegionsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionVIew: UICollectionView!
    
    var cellSize: CGFloat = 100
    var cellBigSize: CGFloat = 130
    var cellMargin: CGFloat = 18
    
    var sectionInsetForSelectedItems: UIEdgeInsets!
    var sectionInsetForAvailableItems: UIEdgeInsets!
    
    var availableItems: [String] = ["0","1","2","3","4","5","6","7","8","9","10"]
    var selectedItems: [String] = []
    
    let titleForSelectedItems: String = "Мои регионы"
    let titleForAvailableItems: String = "Доступные регионы"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionVIew.delegate = self
        collectionVIew.dataSource = self
        collectionVIew.register(UINib(nibName: "ASWRegionCell", bundle: nil), forCellWithReuseIdentifier: "ASWRegionCell")
        sectionInsetForSelectedItems = UIEdgeInsets(top: 0, left: cellMargin, bottom: 0, right: cellMargin)
        sectionInsetForAvailableItems = UIEdgeInsets(top: 0, left: cellMargin, bottom: cellMargin, right: cellMargin)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return selectedItems.count
        }
        else {
            return availableItems.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ASWRegionCell", for: indexPath) as! ASWRegionCell
        if indexPath.section == 0 {
            cell.selectCell()
            //настройка ячейки
            cell.regionNumber.text = "\(selectedItems[indexPath.item])"
        }
        else {
            cell.deselectCell()
            //настройка ячейки
            cell.regionNumber.text = "\(availableItems[indexPath.item]))"
            
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.size.width
        let requiredWidth = cellSize * 3 + cellMargin * 4
        
        if screenWidth <= requiredWidth {
            return CGSize(width: cellSize + 30, height: cellSize + 30)
        }
        else {
            return CGSize(width: cellSize, height: cellSize)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return sectionInsetForSelectedItems
        }
        else {
            return sectionInsetForAvailableItems
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: "ASWCollectionReusableView", for: indexPath) as! ASWCollectionReusableView
            if indexPath.section == 0 {
                headerView.header.text = titleForSelectedItems + " (\(selectedItems.count))"
            }
            else {
                headerView.header.text = titleForAvailableItems + " (\(availableItems.count))"
            }
            headerView.header.textColor = UIColor.ASWColor.grey
            return headerView
        default:
            assert(false, "Unexpected element kind")
            
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let string = selectedItems[indexPath.item]
            selectedItems.remove(at: indexPath.item)
            availableItems.append(string)
          //  availableItems.sort(by: sortingRegions(value1:value2:))
        }
        else {
            let string = availableItems[indexPath.item]
            availableItems.remove(at: indexPath.item)
            selectedItems.append(string)
           // selectedItems.sort(by: sortingRegions(value1:value2:))
        }
        
        //обработка нажатия
        collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 && selectedItems.count == 0 {
            return CGSize(width: 0, height: 0)
        }
        if section == 1 && availableItems.count == 0 {
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: self.view.frame.width, height: 46)
    }
    
    func sortingRegions(value1: String, value2: String) -> Bool {
        return value1 < value2
    }
    

    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

