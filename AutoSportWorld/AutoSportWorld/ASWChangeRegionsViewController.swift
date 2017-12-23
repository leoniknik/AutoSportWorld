//
//  ASWChangeRegionsViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 12.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWChangeRegionsViewController: ASWCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "ASWRegionCell", bundle: nil), forCellWithReuseIdentifier: "ASWRegionCell")
        datasource = ASWRegionsCollectionViewDataSource(collectionView: collectionView)
        collectionView.dataSource = datasource
        searchBar.delegate = datasource
        setupRightBarItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    override func setupUI() {
        super.setupUI()
        hideStepAndProgressView()
        setupButton()
        navigationItem.title = "Фильтр регионов"
    }
    
    func setupButton() {
        let titleAttributed = NSMutableAttributedString(string: "Сохранить", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 17),NSAttributedStringKey.foregroundColor:UIColor.white])
        confirmButton.setAttributedTitle(titleAttributed, for: .normal)
    }
    
    override func buttonTapped(_ sender: Any) {
        
    }

}

