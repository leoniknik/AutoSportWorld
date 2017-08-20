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
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var stepAndProgressView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!

    
    fileprivate let cellSize: CGFloat = 100
    fileprivate let cellMargin: CGFloat = 18
    fileprivate let cellBigMargin: CGFloat = 40
    
    var datasource: ASWCollectionViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        searchBar.delegate = datasource
        collectionView.dataSource = datasource
        setupUI()
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
        
        //убираем клавиатуру
        searchBar.resignFirstResponder()
        
        //подчищаем текст
        searchBar.text = ""
        
        collectionView.reloadData()
        
    }
    
    func setupUI() {
//        confirmButton.layer.cornerRadius = 10
//        confirmButton.clipsToBounds = true
        confirmButton.backgroundColor = UIColor.ASWColor.black
        stepLabel.textColor = UIColor.ASWColor.grey
        progressView.progressTintColor = UIColor.ASWColor.yellow
        searchBar.backgroundColor = UIColor.ASWColor.black
        searchBar.barTintColor = UIColor.ASWColor.black
        
        //убираем полоску между хедером и навигейшен баром
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        
    }
    
    func hideStepAndProgressView() {
        //установка высоты вьюхи с прогрессбаром и шагами в 0
        stepLabel.isHidden = true
        progressView.isHidden = true
        if let constraint = (stepAndProgressView.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = 0.0
        }
    }
    
    func hideSearchBar() {
        if let constraint = (searchBar.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = 0.0
        }
    }
    
}
