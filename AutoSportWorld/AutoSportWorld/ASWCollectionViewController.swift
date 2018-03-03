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
    func updateSelectedRaceTypes(auto:Bool, raceTypeIDs: [Int])
}

class ASWCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ASWSportTypeCollectionViewDataSourceDelegate,ASWActionTypeCollectionViewDataSourceDelegate,ASWRegionsCollectionViewDataSourceDelegate, ASWRaceCategoryCollectionViewDataSourceDelegate {
    
    func dataReceived() {
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
            if(self?.datasource.isEmptyDatasource()) ?? false{
                self?.view.showASWErrorView(retryAction: self?.getUpdate ?? {})
                //self?.errorLabel.text = "Нет данных"
                //self?.errorLabel.isHidden = false
            }else{
                //self?.errorLabel.isHidden = true
            }
            self?.setupRightBarItem()
            self?.collectionView.reloadData()
        }
    }
    
    func networkErrorOccured() {
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
            //self?.errorLabel.text = "Ошибка сетевого подключения"
            //self?.errorLabel.isHidden = false
            self?.view.showASWErrorView(retryAction: self?.getUpdate ?? {})
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        errorLabel.isHidden = true
    }
    
    func updateSelectedRaceTypes(auto: Bool, raceTypeIDs: [Int]) {
        delegate.updateSelectedRaceTypes(auto:auto, raceTypeIDs: raceTypeIDs)
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
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    fileprivate let cellSize: CGFloat = 100
    fileprivate let cellMargin: CGFloat = 18
    fileprivate let cellBigMargin: CGFloat = 40
    
    var datasource: ASWCollectionViewDataSource!
    var delegate: ASWCollectionViewControllerDelegate!
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        collectionView.register(UINib(nibName: "ASWRegionCell", bundle: nil), forCellWithReuseIdentifier: "ASWRegionCell")
        collectionView.register(UINib(nibName: "ASWRaceTypeCell", bundle: nil), forCellWithReuseIdentifier: "ASWRaceTypeCell")
        
        
        collectionView.delegate = self
        searchBar.delegate = datasource
        collectionView.dataSource = datasource
        setupRefreshView()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        
    }
    
    
    func setupRefreshView() {
        self.collectionView.alwaysBounceVertical = true;
        //добавление активити для обновления
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(getUpdate), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление", attributes: [:])
    }
    
    @objc func getUpdate() {
        self.errorLabel.isHidden = true
        DispatchQueue.main.async {
            [weak self] in
            self?.collectionView.setContentOffset(CGPoint(x: 0, y: (self?.collectionView.contentOffset.y) ?? CGFloat(0) - ((self?.refreshControl.frame.size.height) ?? CGFloat(0))), animated: false)
            self?.refreshControl.beginRefreshing()
            self?.collectionView.refreshControl?.beginRefreshing()
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.datasource.updateData()
        }
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
    
    //    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    //        if indexPath.section == 0 {
    //            let string = datasource.selectedItems[indexPath.item]
    //            datasource.selectedItems.remove(at: indexPath.item)
    //            datasource.availableItems.append(string)
    //        }
    //        else {
    //            let string = datasource.availableItems[indexPath.item]
    //            datasource.availableItems.remove(at: indexPath.item)
    //            datasource.selectedItems.append(string)
    //        }
    //
    //        //синхронизация
    //        datasource.syncItems()
    //
    //        //hideKeyboard()
    //
    //
    //
    //        collectionView.reloadData()
    //        datasource.itemSelected()
    //        setupRightBarItem()
    //    }
    
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
                for i in 0 ..< datasource.rawSelectedItems.count{
                    let rawItem = datasource.rawSelectedItems[0]
                    if(rawItem.id == item.id){
                        datasource.rawSelectedItems.remove(at: i)
                        datasource.rawAvailableItems.append(rawItem)
                        break
                    }
                }
                datasource.availableItems.append(item)
            }
        }
        else {
            for _ in 0 ..< datasource.availableItems.count {
                let item = datasource.availableItems[0]
                datasource.availableItems.remove(at: 0)
                for i in 0 ..< datasource.rawAvailableItems.count{
                    let rawItem = datasource.rawAvailableItems[0]
                    if(rawItem.id == item.id){
                        datasource.rawAvailableItems.remove(at: i)
                        datasource.rawSelectedItems.append(rawItem)
                        break
                    }
                }
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
        //        for view in searchBar.subviews {
        //            for subview in view.subviews {
        //                if subview is UITextField {
        //                    let textField: UITextField = subview as! UITextField
        //                    textField.backgroundColor = UIColor.white
        //                }else{
        //                    subview.backgroundColor = .black
        //                }
        //            }
        //        }
        searchBar.backgroundColor = UIColor.ASWColor.black
        for constraint in (searchBar.constraints.filter{$0.firstAttribute == .height}){
            constraint.constant = 56.0
        }
        
    }
    
    func hideKeyboard() {
        //убираем клавиатуру
        searchBar.resignFirstResponder()
        
        //подчищаем текст
        //searchBar.text = ""
    }
    
    func setupRegionsDatasource(datasource:ASWRegionsCollectionViewDataSource?,selectedRegions:[Int]){
        if datasource == nil{
            self.datasource = ASWRegionsCollectionViewDataSource(collectionView: self.collectionView, selectedRegions: selectedRegions)
        }else{
            self.datasource = datasource
            (self.datasource as! ASWRegionsCollectionViewDataSource).setSelectedRegions(regionsIDs: selectedRegions)
        }

        (self.datasource as! ASWRegionsCollectionViewDataSource).delegate = self
        collectionView.dataSource = self.datasource
        collectionView.delegate = self
        searchBar.delegate = self.datasource
        setupRightBarItem()
        showSearchBar()
        if(!(datasource?.isLoading ?? false)){
            self.refreshControl.endRefreshing()
        }
        
    }
    
    func setupRaceCategoriesDatasource(datasource:ASWRaceCategoryCollectionViewDataSource?,auto:Bool,selectedRaceCategories:[Int]){
        if datasource == nil{
            self.datasource = ASWRaceCategoryCollectionViewDataSource(collectionView: self.collectionView, selectedRaceCategory: selectedRaceCategories, auto: auto)
             (self.datasource as! ASWRaceCategoryCollectionViewDataSource).auto = auto
        }else{
            self.datasource = datasource
            (self.datasource as! ASWRaceCategoryCollectionViewDataSource).setSelectedCategories(categoryIDs: selectedRaceCategories)
        }
        
        (self.datasource as! ASWRaceCategoryCollectionViewDataSource).delegate = self
        collectionView.dataSource = self.datasource
        collectionView.delegate = self
        searchBar.delegate = self.datasource
        setupRightBarItem()
        showSearchBar()
        
    }
    
    func setupSportTypeDatasource(auto: Bool,moto:Bool){
        self.datasource = ASWSportTypeCollectionViewDataSource(collectionView: self.collectionView, auto: auto, moto: moto)
        
        (self.datasource as! ASWSportTypeCollectionViewDataSource).delegate = self
        collectionView.dataSource = self.datasource
        collectionView.delegate = self
        searchBar.delegate = nil
        setupRightBarItem()
        hideSearchBar()
        DispatchQueue.main.async {
            [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func setupActionTypeDatasource(auto: Bool,watch:Bool,join:Bool){
        
        self.datasource = ASWActionTypeCollectionViewDataSource(collectionView: self.collectionView,auto:auto, join: join,watch: watch)
        
        (self.datasource as! ASWActionTypeCollectionViewDataSource).delegate = self
        collectionView.dataSource = self.datasource
        collectionView.delegate = self
        searchBar.delegate = nil
        setupRightBarItem()
        hideSearchBar()
        DispatchQueue.main.async {
            [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func setupDatasource(){
       
    }
    
}

