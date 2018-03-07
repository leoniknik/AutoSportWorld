//
//  ASWCalendarViewController.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 20/08/2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//
import UIKit
import FSCalendar


class ASWCalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet weak var prevMonthButton: UIButton!
    
    @IBOutlet weak var nextMonthButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var textSize = 26
    
    fileprivate let borderWidth = CGFloat(1)
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
    
    var datesWithEvent = ["2017-10-29","2017-11-01","2017-11-03"]
    var datesWithMultipleEvents = ["2017-11-04","2017-11-05","2017-11-06"]

    //    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
    //        calendar.allowsMultipleSelection = false
    //        var cell = calendar.cell(for: date, at: monthPosition)
    //        cell?.backgroundColor = UIColor.gray
    //        return true
    //    }
    //
    //    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
    //
    //        var cell = calendar.cell(for: date, at: monthPosition)
    //        cell?.backgroundColor = UIColor.white
    //        return true
    //    }
    
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        _ = setTodayCell(cell: cell, date: date, selected: false, at: monthPosition)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        var cell = calendar.cell(for: date, at: monthPosition)
        cell = setTodayCell(cell: cell!, date: date,selected: true, at: monthPosition)
        currentDate = date
        
        setupCollectionView()
        collectionView.reloadData()
    }
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {

        if let cell = calendar.cell(for: date, at: monthPosition){
        
            _ = setTodayCell(cell: cell, date: date,selected: false, at: monthPosition)
            
        }

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setTodayCell(cell:FSCalendarCell,date:Date,selected:Bool, at monthPosition: FSCalendarMonthPosition)->FSCalendarCell{
        cell.contentView.layer.borderWidth = 0
        cell.contentView.layer.cornerRadius = 10.0
        cell.contentView.clipsToBounds = true
        cell.clipsToBounds = true
        cell.titleLabel.textColor = UIColor.black
        
        if(selected && dateFormatter1.string(from: date) == dateFormatter1.string(from: Date())){
            //выделена сегодняшняя ячейка
            //ширина ячейки
            cell.contentView.layer.borderWidth = borderWidth
            cell.contentView.backgroundColor = UIColor.white
            cell.titleLabel.textColor = UIColor.black
            cell.titleLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(textSize))
            //cell.imageView.isHidden = true
        }
        else{
            if(selected){
                //выделена ячейка
                cell.contentView.layer.borderWidth = borderWidth
                cell.contentView.backgroundColor = UIColor.gray
                cell.titleLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(textSize))
                cell.titleLabel.textColor = UIColor.white
                cell.eventIndicator.color = UIColor.white
            }
            else{
                
                if(dateFormatter1.string(from: date) == dateFormatter1.string(from: Date())){
                    //сегодняшняя ячейка
                    cell.contentView.layer.borderWidth = borderWidth
                    cell.titleLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(textSize))
                    cell.backgroundColor = UIColor.white
                    cell.titleLabel.textColor = UIColor.black
                    cell.eventIndicator.color = UIColor.black
                }else if (gregorian.component(.month, from: calendar.currentPage) == gregorian.component(.month, from: date)){
                    //текущий месяц
                    cell.contentView.backgroundColor = UIColor.white
                    cell.titleLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(textSize))
                    let dateString = self.dateFormatter2.string(from: date)
                    let count = eventsDictionary[date]?.count ?? 0
                    if count > 0 {
                        cell.contentView.layer.borderWidth = borderWidth
                        cell.contentView.backgroundColor = UIColor.ASWColor.greyBackground
                        cell.titleLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(textSize))
                        cell.backgroundColor = UIColor.white
                        cell.titleLabel.textColor = UIColor.black
                    }else{
                        cell.titleLabel.textColor = UIColor.black
                    }
                    
                    cell.eventIndicator.color = UIColor.black
                }else{
                    //прошлый месяц
                    cell.contentView.backgroundColor = UIColor.white
                    cell.titleLabel.textColor = UIColor.ASWColor.grey
                    cell.eventIndicator.color = UIColor.ASWColor.grey
                    cell.titleLabel.font = UIFont.systemFont(ofSize: CGFloat(textSize))
                }
            }
        }
        
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textSize = 17//ASWConstants.isIPhone5 ? 17 : 26
        setupNavbar()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName:"ASWMapAndCalendarCell", bundle: nil), forCellWithReuseIdentifier:"ASWMapAndCalendarCell")
        
        calendar.delegate = self
        calendar.dataSource = self
        calendar.allowsMultipleSelection = false
        calendar.swipeToChooseGesture.isEnabled = false
        
        //бекграунд
        calendar.backgroundColor = UIColor.white
        
        //first day = monday
        calendar.firstWeekday = 0
        calendar.appearance.headerMinimumDissolvedAlpha = 0;
        
        // kill native title
        calendar.appearance.headerTitleFont = calendar.appearance.headerTitleFont.withSize(0)
        
        //font for cells
        //calendar.appearance.titleFont.withSize(26)
        
        //дни недели
        calendar.appearance.weekdayFont.withSize(CGFloat(textSize))
        calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: CGFloat(textSize))
        calendar.appearance.weekdayTextColor = UIColor.ASWColor.grey;
        
        calendar.appearance.borderRadius = 0// квадрат
        
        //today cell color
        calendar.appearance.todayColor = UIColor.white
        
        //setup next prev month buttons
        prevMonthButton.setTitleColor(UIColor.ASWColor.grey, for: [])
        nextMonthButton.setTitleColor(UIColor.ASWColor.grey, for: [])
        
        
        
        calendar.appearance.borderSelectionColor = UIColor.gray.withAlphaComponent(0)
        calendar.appearance.selectionColor = UIColor.gray.withAlphaComponent(0)
        calendar.appearance.todaySelectionColor = UIColor.gray.withAlphaComponent(0)
        
        
        // events
        calendar.appearance.eventDefaultColor = UIColor.ASWColor.black
        calendar.appearance.eventSelectionColor = UIColor.white
        
        calendar.layer.cornerRadius = 10.0
        calendar.clipsToBounds = true
        //titleView.layer.cornerRadius = 10.0
        //titleView.clipsToBounds = true
        
        //calendar.select(Date())
        self.calendar.setCurrentPage(Date(), animated: false)
        updateMonthLabel()
        
        
        //test code
//        v.backgroundColor=UIColor.clear
        v.layer.cornerRadius = 10.0
        v.clipsToBounds = true
//        v.layer.borderColor = UIColor.red.cgColor
//        v.layer.borderWidth = 1
//        calendar.layer.borderColor = UIColor.red.cgColor
        
        self.view.backgroundColor = UIColor.ASWColor.greyBackground
        v.backgroundColor = UIColor.clear
        
        ubvl.backgroundColor = UIColor.ASWColor.greyBackground
        ubvr.backgroundColor = UIColor.ASWColor.greyBackground
        
        ufvl.backgroundColor = UIColor.white
        ufvr.backgroundColor = UIColor.white
        
        collectioViewHeightConstraint.constant = 0
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(eventCallback(_:)), name: .eventCallback, object: nil)
        self.getEvents(forDate: Date())
        self.setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getEvents(forDate: currentDate)
        //calendar.select(Date())
        //calendar.select(Date(timeIntervalSince1970:1546250981))
    }
    
    
    var currentDate:Date = Date()
    
    func todayItemClicked(sender: AnyObject) {
        self.calendar.setCurrentPage(Date(), animated: false)
    }
    
    //date selected
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        currentDate = date
        collectionView.reloadData()
        NSLog(self.dateFormatter2.string(from: date))
    }
    
    //month change
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        updateMonthLabel()
        getEvents(forDate: calendar.currentPage)
        self.calendar.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter2.string(from: date)
        let count = eventsDictionary[date]?.count ?? 0
        if count > 1{
            return 3
        }else if count == 1{
            return 1
        }else{
            return 0
        }
        
    }
    
    func updateMonthLabel(){
        let date = calendar.currentPage
        monthLabel.text = monthLabeldateFormatter.string(from: date)
        
        var mf = DateFormatter()
        var months = mf.standaloneMonthSymbols;
        months = ["Январь", "Февраль", "Март", "Апрель", "Май","Июнь","Июль","Август","Сентябрь","Октябрь","Ноябрь","Декабрь"]
        monthLabel.text = months![date.month()]+" \(date.year())"
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

    @IBOutlet weak var v: UIView!
    
    @IBOutlet weak var ubvl: UIView!
    @IBOutlet weak var ubvr: UIView!
    @IBOutlet weak var ufvl: UIView!
    @IBOutlet weak var ufvr: UIView!
    
    func setupNavbar() {
        //убираем полоску между хедером и навигейшен баром
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.ASWColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"ic_tune"), style: .plain, target: self, action: #selector(showFilters))
    }
    
    @objc func showFilters() {
        let viewController = ASWFiltersViewController()
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    
    var eventsDictionary: Dictionary<Date,[ASWRace]> = Dictionary<Date,[ASWRace]>()
    var currentMonthRacesCountChange = true
    
    func getEvents(forDate date:Date){
        let currentMonth = date.firstDayOfMonth()
        let from = currentMonth.minusMonth(1)
        let to = currentMonth.addMonth(2)
        
        func success(parser:ASWCalendarRacesParser){
            let races = parser.racesParser.races
            for race: ASWRace in races{
                if let fromEpic = race.times?.first?.start{
                    let raceDate  = Date(timeIntervalSince1970:Double(fromEpic)).removeTimeStamp()
                    if eventsDictionary[raceDate] == nil {
                        eventsDictionary[raceDate] = [ASWRace]()
                    }
                    
                    var dateRaces = eventsDictionary[raceDate]
                    
                    let contains = eventsDictionary[raceDate]?.contains(where: {element in return race.id == element.id}) ?? false
                    
                    if(!contains){
                        dateRaces?.append(race)
                        currentMonthRacesCountChange = true
                    }
                    
                    eventsDictionary[raceDate] = dateRaces
                }
            }
            
            if currentMonthRacesCountChange {
                currentMonthRacesCountChange = false
                DispatchQueue.main.async {
                    [weak self] in
                    self?.collectionView.reloadData()
                    self?.calendar.reloadData()
                }
                
                
            }
        }
        
        func error(parser:ASWErrorParser){
            
        }
        ASWNetworkManager.getCalendarRaces(from: from, to: to, sucsessFunc: success, errorFunc: error)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventsDictionary[currentDate.removeTimeStamp()]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let race = eventsDictionary[currentDate.removeTimeStamp()]?[indexPath.item]{
            let viewController = ASWEventViewController(race: race)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ASWMapAndCalendarCell", for: indexPath) as? ASWMapAndCalendarCell
            else {
                return UICollectionViewCell()
                
        }
        
        let eventShort = eventsDictionary[currentDate.removeTimeStamp()]?[indexPath.item] ?? ASWRace()
        var event = eventShort
        if let eventID = eventShort.id{
            if let fullEvent = fullEvents[eventID] {
                event = fullEvent
            }else{
                ASWNetworkManager.getEvent(request: ASWRaceRequest(raceID: Int(eventID) ?? 0))
            }
        }
        
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 74)
    }
    
    var fullEvents:Dictionary<String,ASWRace> = Dictionary<String,ASWRace>()
    
    @IBOutlet weak var collectioViewHeightConstraint: NSLayoutConstraint!
    
    func setupCollectionView(){
        let count = eventsDictionary[currentDate]?.count ?? 0
        UIView.animate(withDuration: 0.5, animations: {
//            self.collectionView.heightAnchor.constraint(equalToConstant: count>0 ? 74 : 0).isActive = true
            //self.collectioViewHeightConstraint.constant = count>0 ? 100 : 0
            self.collectionView.alpha = count>0 ? 1 : 0
            self.collectionView.setNeedsLayout()
        })
    }
    
    @objc func eventCallback(_ notification: Notification) {
        if let response = (notification.userInfo?["data"] as? ASWRaceParser) {
            fullEvents[response.item.id ?? "nil"] = response.item
            DispatchQueue.main.async {
                [weak self] in self?.collectionView.reloadData()
                self?.setupCollectionView()
            }
        }
    }
}

