//
//  ASWCollectionViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 16.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let cellSize: CGFloat = 100
    fileprivate let cellBigSize: CGFloat = 130
    fileprivate let cellMargin: CGFloat = 18
    
    fileprivate var sectionInsetForSelectedItems: UIEdgeInsets!
    fileprivate var sectionInsetForAvailableItems: UIEdgeInsets!
    
    var datasource: ASWCollectionViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = datasource
        sectionInsetForSelectedItems = UIEdgeInsets(top: 0, left: cellMargin, bottom: 0, right: cellMargin)
        sectionInsetForAvailableItems = UIEdgeInsets(top: 0, left: cellMargin, bottom: cellMargin, right: cellMargin)
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
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 && datasource.selectedItems.count == 0 {
            return CGSize(width: 0, height: 0)
        }
        if section == 1 && datasource.availableItems.count == 0 {
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: self.collectionView.frame.size.width, height: 46)
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
        
        collectionView.reloadData()
        
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}
