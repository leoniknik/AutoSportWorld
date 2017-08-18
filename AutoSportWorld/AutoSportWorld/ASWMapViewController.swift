//
//  ASWMapViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 18.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit
import MapKit

class ASWMapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName:"ASWMapAndCalendarCell", bundle: nil), forCellWithReuseIdentifier:"ASWMapAndCalendarCell")
        
        pageControl.hidesForSinglePage = true
        pageControl.numberOfPages = 3
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ASWMapAndCalendarCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 110)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = self.collectionView.frame.size.width
        self.pageControl.currentPage = Int(self.collectionView.contentOffset.x / pageWidth)
    }
    
}
