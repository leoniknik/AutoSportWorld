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
    
    //    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewForMap: UIView!
    @IBOutlet weak var collectionViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var zoomLevel: Float = 8.0
    var zoomLevelMax: Float = 5.0
    var markers = [GMSMarker]()
    var lastItem: Int = 0
    
    var choosenEvents = [ASWRace]() 
    
    var isFromEvent = false
    
    enum LocationMarker: String {
        case off = "ic_location_one"
        case on = "ic_location_one_on"
    }
    
    var shouldClear = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumLineSpacing = 0
        collectionView.register(UINib(nibName:"ASWMapAndCalendarCell", bundle: nil), forCellWithReuseIdentifier:"ASWMapAndCalendarCell")
        setupLocationManager()
        setupUI()
        setupMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shouldClear && !isFromEvent {
            choosenEvents = []
            setupMapSize()
            addAllMarker()
        }
        if isFromEvent {
            let event = choosenEvents[0]
            if let marker = addMarker(forEvent: event) {
                add(imageName: .on, forMarker: marker)
                markers.append(marker)
                guard let latitude = event.latitude, let longitude = event.longitude else { return }
                let camera = GMSCameraPosition.camera(withLatitude: latitude,
                                                      longitude: longitude,
                                                      zoom: zoomLevelMax)
                if mapView.isHidden {
                    mapView.isHidden = false
                    mapView.camera = camera
                } else {
                    mapView.animate(to: camera)
                }
            }
        }
        shouldClear = true
    }
    
    func addAllMarker() {
        mapView.clear()
        markers.removeAll()
        
        let request: ASWListRacesRequest
        
        if ASWDatabaseManager().getUser() != nil {
            let preferences =  "regions,categories,can_join,can_watch"
            request = ASWListRacesRequest(limit: nil, preferences: preferences, level: nil, cursor: nil, categories: nil, regions: nil, sort: nil, canJoin: nil, canWatch: nil, search: nil)
        } else {
            request = ASWListRacesRequest(limit: nil, preferences: nil, level: nil, cursor: nil, categories: nil, regions: nil, sort: nil, canJoin: nil, canWatch: nil, search: nil)
        }
        ModalLoadingIndicator.show()
        ASWNetworkManager.getEventsWithCompletion(request: request) { [weak self] (result) in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                switch result {
                case .success(let data):
                    guard let tbc = self.tabBarController as? ASWTabBarController else { return }
                    tbc.events = data.races
                    for event in tbc.events {
                        if let marker = self.addMarker(forEvent: event) {
                            self.markers.append(marker)
                        }
                    }
                    ModalLoadingIndicator.hide()
                case .error(let error):
                    print(error)
                    ModalLoadingIndicator.hide()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func setupMapSize() {
        if choosenEvents.count == 0 {
            collectionViewConstraint.constant = 0
        } else {
            collectionViewConstraint.constant = 78
        }
    }
    
    //    func zoomOnFirstMarker() {
    //        guard let myTBC = tabBarController as? ASWTabBarController else { return }
    //        guard let _ = markers.first else { return }
    //        if myTBC.events.count > 1 {
    //            updateColoredMarkers(0)
    //            zoom(onItem: 0)
    //        } else {
    //
    //        }
    //    }
    
    func setupUI() {
        pageControl.setupPageControl()
        setupNavbar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupNavbar() {
        //убираем полоску между хедером и навигейшен баром
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.ASWColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        
        if isFromEvent {
            addBackButton()
        }
    }
    
    @objc func showFilters() {
        let viewController = ASWFiltersViewController()
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return choosenEvents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isFromEvent {
            let race = choosenEvents[indexPath.item]
            let viewController = ASWEventViewController(race: race)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ASWMapAndCalendarCell", for: indexPath) as? ASWMapAndCalendarCell
            else { return UICollectionViewCell() }
        let event = choosenEvents[indexPath.row]
        cell.titleLabel.text = event.title
        cell.categories.text = event.getRaceCategories()
        var canWatch: String = ""
        var canJoin: String = ""
        var place: String = ""
        if event.canJoin ?? false {
            canJoin = "Покататься; "
        }
        if event.canWatch ?? false {
            canWatch = "Посмотреть; "
        }
        if let placeTemp = event.whereRace {
            place = placeTemp + "; "
        }
        cell.descriptionLabel.text = place + canWatch + canJoin
        
        
        if cell.categories.text?.isEmpty ?? false {
            cell.categories.text = "Категории не указаны"
        }
        if cell.descriptionLabel.text?.isEmpty ?? false {
            cell.descriptionLabel.text = "Описание не указано"
        }
        if cell.titleLabel.text?.isEmpty ?? false {
            cell.titleLabel.text = "Заголовок не указан"
        }
        if isFromEvent {
            cell.arrowView.isHidden = true
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 74)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        guard let myTBC = tabBarController as? ASWTabBarController else { return }
        let width: CGFloat = self.collectionView.frame.size.width
        let newItem = Int(self.collectionView.contentOffset.x / width)
//        guard myTBC.events.count > newItem else {
//            return
//        }
        zoom(onItem: newItem)
    }
    
    
    func zoom(onItem item: Int) {
        guard let myTBC = tabBarController as? ASWTabBarController else { return }
        let event = myTBC.events[item]
        guard let latitude = event.latitude, let longitude = event.longitude else { return }
        let camera = GMSCameraPosition.camera(withLatitude: latitude,
                                              longitude: longitude,
                                              zoom: zoomLevelMax)
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }
    
    
    func setupMap() {
        var camera: GMSCameraPosition
        if isFromEvent {
            camera = GMSCameraPosition.camera(withLatitude: choosenEvents[0].latitude ?? 55.7558, longitude: choosenEvents[0].longitude ?? 37.6173, zoom: zoomLevel)
        } else {
            camera = GMSCameraPosition.camera(withLatitude:  55.7558, longitude: 37.6173, zoom: zoomLevel)
        }
        mapView = GMSMapView.map(withFrame: viewForMap.frame, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewForMap.addSubview(mapView)
        mapView.delegate = self
    }
    
    
    func addMarker(forEvent event: ASWRace) -> GMSMarker? {
        guard let latitude = event.latitude, let longitude = event.longitude else { return nil }
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = event.title
        add(imageName: .off, forMarker: marker)
        marker.map = mapView
        return marker
    }
    
    
    func add(imageName name: LocationMarker, forMarker marker: GMSMarker) {
        let markerImage = UIImage(named: name.rawValue)?.withRenderingMode(.alwaysOriginal)
        let markerView = UIImageView(image: markerImage)
        marker.iconView = markerView
    }
    
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.delegate = self
    }
    
    func updateColoredMarkers(_ marker: GMSMarker) {
        markers.forEach({ (marker) in
            add(imageName: .off, forMarker: marker)
        })
        add(imageName: .on, forMarker: marker)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.item
        //        let width: CGFloat = self.collectionView.frame.size.width
        //        let newItem = Int(self.collectionView.contentOffset.x / width)
        //        if indexPath.item == 0 && newItem == 0 {
        //            updateColoredMarkers(0)
        //            zoom(onItem: 0)
        //        }
        //    }
    }
    
    func showEvents(marker: GMSMarker) {
        guard let myTBC = tabBarController as? ASWTabBarController else { return }
        for event in myTBC.mapEvents {
            if event.latitude == marker.position.latitude, event.longitude == marker.position.longitude {
                if !isFromEvent {
                    choosenEvents = event.events
                }
                pageControl.numberOfPages = choosenEvents.count
                collectionView.reloadData()
                setupMapSize()
                return
            }
        }
        pageControl.numberOfPages = choosenEvents.count
        choosenEvents = []
        collectionView.reloadData()
        setupMapSize()
    }
    
}


extension ASWMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location: CLLocation = locations.last else { return }
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
        //            mapView.isHidden = false
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


extension ASWMapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let coordinate = CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude)
        mapView.animate(toLocation: coordinate)
        mapView.animate(toZoom: zoomLevel)
        updateColoredMarkers(marker)
        showEvents(marker: marker)
        return false
    }
    
    
}
