//
//  ViewController.swift
//  CVCalendar Demo
//
//  Created by Мак-ПК on 1/3/15.
//  Copyright (c) 2015 GameApp. All rights reserved.
//
import UIKit
import FSCalendar

class ViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    

    
    @IBOutlet weak var calendar: FSCalendar!
    
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

        //calendar.select(self.dateFormatter1.date(from: "2017/8/07"))
        calendar.select(Date())
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
        let date = calendar.currentPage
        NSLog(self.dateFormatter2.string(from: date))
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
    

}
