//
//  ASWMapViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 18.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit
import GoogleMaps

class ASWMapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewForMap: UIView!
    
    var events: [ASWEvent] = []
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var zoomLevel: Float = 8.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName:"ASWMapAndCalendarCell", bundle: nil), forCellWithReuseIdentifier:"ASWMapAndCalendarCell")
        setupLocationManager()
        setupUI()
        setupMap()
        
        //временный код
        var event = ASWEvent()
        event.latitude = 55.3
        event.longitude = 37.4
        event.title = "1"
        events.append(event)
        
        event = ASWEvent()
        event.latitude = 55.1
        event.longitude = 37.6
        event.title = "2"
        events.append(event)
        
    }
    
    func setupUI() {
       pageControl.hidesForSinglePage = true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = events.count
        mapView.clear()
        for event in events {
            addMarker(forEvent: event)
        }
        updateColoredMarkers()
        return events.count
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
        let previousPage = pageControl.currentPage
        let newPage = Int(self.collectionView.contentOffset.x / pageWidth)
        pageControl.currentPage = newPage
        if previousPage != newPage {
            updateColoredMarkers()
        }
    }
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude:  55.7558, longitude: 37.6173, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: viewForMap.frame, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewForMap.addSubview(mapView)
    }
    
    
    func addMarker(forEvent event: ASWEvent) {
        let marker = GMSMarker()
        event.mapMarker = marker
        marker.position = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
        marker.title = event.title
        marker.map = mapView
    }
    
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.delegate = self
    }
    
    
    func updateColoredMarkers() {
        let coloredIndex = pageControl.currentPage
        for index in 0 ..< events.count {
            var color = UIColor.ASWColor.black
            if index == coloredIndex {
                color = UIColor.ASWColor.yellow
            }
            if let marker = events[index].mapMarker {
                marker.icon = GMSMarker.markerImage(with: color)
            }
        }
    }
    
}


extension ASWMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location: CLLocation = locations.last!
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
