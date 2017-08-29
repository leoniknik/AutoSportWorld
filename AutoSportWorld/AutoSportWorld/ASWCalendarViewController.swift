//
//  ViewController.swift
//  CVCalendar Demo
//
//  Created by Мак-ПК on 1/3/15.
//  Copyright (c) 2015 GameApp. All rights reserved.
//
import UIKit
import FSCalendar



class ASWCalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
   
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    fileprivate lazy var monthLabeldateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var datesWithEvent = ["2017-08-01","2017-08-02","2017-08-03"]
    var datesWithMultipleEvents = ["2017-08-04","2017-08-05","2017-08-06"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.delegate = self
        calendar.dataSource = self
        calendar.allowsMultipleSelection = false
        calendar.swipeToChooseGesture.isEnabled = false
        calendar.backgroundColor = UIColor.white
        
        //first day = monday
        calendar.firstWeekday = 0
        calendar.appearance.headerMinimumDissolvedAlpha = 0;
        calendar.appearance.headerTitleFont = calendar.appearance.headerTitleFont.withSize(0)
        calendar.appearance.titleFont.withSize(26)
         calendar.appearance.weekdayFont.withSize(26)
        
        self.title = "Календарь событий"
       
        calendar.select(Date())
        updateMonthLabel()
        
        
        //collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName:"ASWMapAndCalendarCell", bundle: nil), forCellWithReuseIdentifier:"ASWMapAndCalendarCell")
        //setupLocationManager()
        setupUI()
        //setupMap()
        
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
        collectionView.reloadData()
    }


    
    var events: [ASWEvent] = []

    
    func setupUI() {
        pageControl.hidesForSinglePage = true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = events.count
        //mapView.clear()
        
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
        
    }

   
    func todayItemClicked(sender: AnyObject) {
        self.calendar.setCurrentPage(Date(), animated: false)
    }
    
    //date selected
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        NSLog(self.dateFormatter2.string(from: date))
    }
   
    //month change
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        updateMonthLabel()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter2.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return 1
            
        }
        if self.datesWithMultipleEvents.contains(dateString) {
            return 3
        }
        return 0
    }
    
    func updateMonthLabel(){
        let date = calendar.currentPage
        monthLabel.text = monthLabeldateFormatter.string(from: date)
    }
    
    @IBAction func previousMonth(_ sender: Any) {
        var date = calendar.currentPage
        date = Calendar.current.date(byAdding: .month, value: -1, to: date)!
        calendar.setCurrentPage(date, animated: true)
    }
    

   
    @IBAction func nextMonth(_ sender: Any) {
        var date = calendar.currentPage
        date = Calendar.current.date(byAdding: .month, value: 1, to: date)!
        calendar.setCurrentPage(date, animated: true)
    }

    

}
