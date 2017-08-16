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
        titleForSelectedItems = "Мои регионы"
        titleForSelectedItems = "Доступные регионы"
        datasource = ASWRegionsCollectionViewDataSource()
        collectionView.dataSource = datasource
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let header = super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    return header
    }
}

