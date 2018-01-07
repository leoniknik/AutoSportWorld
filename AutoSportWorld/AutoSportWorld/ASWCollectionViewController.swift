//
//  ASWCollectionViewController.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 04.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

//
//  ASWCollectionViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 16.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit
protocol ASWCollectionViewControllerDelegate{
    func setupRightBarItem(avalible:Bool, title:String)
    func sportTypeSelected(moto:Bool, auto:Bool)
    func actionTypeSelected(auto: Bool, watch: Bool, join: Bool)
    func updateSelectedRegions(regionsIDs: [Int])
    func updateSelectedRaceTypes(raceTypeIDs: [Int])
}

class ASWCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ASWSportTypeCollectionViewDataSourceDelegate,ASWActionTypeCollectionViewDataSourceDelegate,ASWRegionsCollectionViewDataSourceDelegate, ASWRaceCategoryCollectionViewDataSourceDelegate {
    func updateSelectedRaceTypes(raceTypeIDs: [Int]) {
        delegate.updateSelectedRaceTypes(raceTypeIDs: raceTypeIDs)
        setupRightBarItem()
    }
    
    
    func updateSelectedRegions(regionsIDs: [Int]) {
        delegate.updateSelectedRegions(regionsIDs: regionsIDs)
        setupRightBarItem()
    }

    
    func actionTypeSelected(auto: Bool, watch: Bool, join: Bool) {
        delegate.actionTypeSelected(auto: auto, watch: watch, join: join)
        setupRightBarItem()
    }
    
    func sportTypeSelected(auto: Bool, moto: Bool) {
        delegate.sportTypeSelected(moto: moto, auto: auto)
        setupRightBarItem()
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    fileprivate let cellSize: CGFloat = 100
    fileprivate let cellMargin: CGFloat = 18
    fileprivate let cellBigMargin: CGFloat = 40
    
    var datasource: ASWCollectionViewDataSource!
    var delegate: ASWCollectionViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "ASWRegionCell", bundle: nil), forCellWithReuseIdentifier: "ASWRegionCell")
        collectionView.register(UINib(nibName: "ASWRaceTypeCell", bundle: nil), forCellWithReuseIdentifier: "ASWRaceTypeCell")

        
        collectionView.delegate = self
        searchBar.delegate = datasource
        collectionView.dataSource = datasource
        //setupUI()
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellSize, height: cellSize)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let screenWidth = UIScreen.main.bounds.size.width
        let requiredWidth = cellSize * 3 + cellMargin * 4
        
        var margin = cellMargin
        
        if screenWidth <= requiredWidth {
            margin = cellBigMargin
        }
        
        if section == 0 {
            return UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        }
        else {
            return UIEdgeInsets(top: 0, left: margin, bottom: 10, right: margin)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 && datasource.selectedItems.count == 0 {
            return CGSize(width: 0, height: 0)
        }
        if section == 1 && datasource.availableItems.count == 0 {
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: self.collectionView.frame.size.width, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let string = datasource.selectedItems[indexPath.item]
            datasource.selectedItems.remove(at: indexPath.item)
            datasource.availableItems.append(string)
        }
        else {
            let string = datasource.availableItems[indexPath.item]
            datasource.availableItems.remove(at: indexPath.item)
            datasource.selectedItems.append(string)
        }
        
        //синхронизация
        datasource.syncItems()
        
        //hideKeyboard()
        
        
        
        collectionView.reloadData()
        datasource.itemSelected()
        setupRightBarItem()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let string = datasource.selectedItems[indexPath.item]
            datasource.selectedItems.remove(at: indexPath.item)
            datasource.availableItems.append(string)
        }
        else {
            let string = datasource.availableItems[indexPath.item]
            datasource.availableItems.remove(at: indexPath.item)
            datasource.selectedItems.append(string)
        }
        
        //синхронизация
        datasource.syncItems()
        
        //hideKeyboard()
        
        
        
        collectionView.reloadData()
        datasource.itemSelected()
        setupRightBarItem()
    }
    

        
       
    
    func setupRightBarItem() {
        if datasource.availableItems.count != 0 {
            delegate.setupRightBarItem(avalible: true, title: "Все")
            selectAllRightBarState = true
        }
        else {
            delegate.setupRightBarItem(avalible: true, title: "Нет")
            selectAllRightBarState = false
        }
    }
 
    var selectAllRightBarState:Bool = true
    
    func rightBarItemTapped() {
        if !selectAllRightBarState {
            for _ in 0 ..< datasource.selectedItems.count {
                let item = datasource.selectedItems[0]
                datasource.selectedItems.remove(at: 0)
                datasource.availableItems.append(item)
            }
        }
        else {
            for _ in 0 ..< datasource.availableItems.count {
                let item = datasource.availableItems[0]
                datasource.availableItems.remove(at: 0)
                datasource.selectedItems.append(item)
            }
        }
        datasource.itemSelected()
        datasource.syncItems()
        hideKeyboard()
        datasource.collectionView.reloadData()
        setupRightBarItem()
    }
    

    
    func hideSearchBar() {
        for constraint in (searchBar.constraints.filter{$0.firstAttribute == .height}){
            constraint.constant = 0
        }

    }
    
    func showSearchBar() {
        //if let constraints =
        for constraint in (searchBar.constraints.filter{$0.firstAttribute == .height}){
            constraint.constant = 56.0
        }

    }
    
    func hideKeyboard() {
        //убираем клавиатуру
        searchBar.resignFirstResponder()

        //подчищаем текст
        searchBar.text = ""
    }
    
}

