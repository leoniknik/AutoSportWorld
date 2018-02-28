//
//  ASWFeedViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 20.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit
import Kingfisher

class ASWFeedViewController: UIViewController, ASWEventCellDelegate, ASWFeedsModelDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var errorLabel: UILabel!
    
    let refreshControl = UIRefreshControl()
    var model: ASWFeedsModelProtocol = ASWFeedsModel()
    
    var cursor: String? = "0"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshView()
        setupTableView()
        setupUI()
        model.delegate = self
        self.refreshControl.beginRefreshing()
        self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentOffset.y-self.refreshControl.frame.size.height), animated: false)
        getUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateRefreshControl()
        tableView.reloadData()
    }
    
    func setupUI() {
        self.tableView.backgroundColor = UIColor.ASWColor.greyBackground
        setupNavbar()
    }
    
    func setupNavbar() {
        searchBar.backgroundColor = UIColor.ASWColor.black
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        //убираем полоску между хедером и навигейшен баром
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.ASWColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = "Лента новостей"
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"ic_tune"), style: .plain, target: self, action: #selector(showFilters))
    }
    
    @objc func showFilters() {
        let viewController = ASWFiltersViewController()
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    func setupRefreshView() {
        //добавление активити для обновления
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(getUpdate), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление", attributes: [:])
    }
    
    @objc func getUpdate() {
        self.errorLabel.isHidden = true
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.model.updateEvents(cursor: nil)
        }
    }
    
    //обновление данных
    func refreshData() {
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ASWEventCell", bundle: nil), forCellReuseIdentifier: "ASWEventCell")
        tableView.register(UINib(nibName: "ASWSpacingCell", bundle: nil), forCellReuseIdentifier: "ASWSpacingCell")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func update(cursor: String?) {
        self.cursor = cursor
        refreshData()
        guard let myTBC = tabBarController as? ASWTabBarController else { return }
        myTBC.events = model.events
    }
    
    func updateTabBarController() {
        
    }
    
    func updateError() {
        if (self.model.getEvents().count == 0) {
            DispatchQueue.main.async { [weak self] in
                self?.errorLabel.isHidden = false
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
        else {
            DispatchQueue.main.async { [weak self] in
                self?.createAlert()
            }
        }
    }
    
    func createAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Не удалось подключиться к серверу", preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            switch action.style{
            case .default:
                self.tableView.refreshControl?.endRefreshing()
            case .cancel:
                self.tableView.refreshControl?.endRefreshing()
            case .destructive:
                self.tableView.refreshControl?.endRefreshing()
            }}))
    }
    
    func updateRefreshControl() {
        if (self.tableView.refreshControl?.isRefreshing ?? false) {
            let offset = self.tableView.contentOffset
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.refreshControl?.beginRefreshing()
            self.tableView.contentOffset = offset
            self.tableView.prefetchDataSource = self
        }
    }
    
    func likeEventTapped(id: Int) {
        
        let race = model.getEvent(forIndex: id)
        
        func sucsessFunc(){
            race.liked = !(race.liked ?? false)
            tableView.reloadRows(at: [IndexPath(item: id * 2 + 1, section: 0)], with: UITableViewRowAnimation.automatic)
        }
        
        if race.liked ?? false {
            model.unlikeEvent(id: id, sucsessFunc: sucsessFunc)
        } else {
            model.likeEvent(id: id, sucsessFunc: sucsessFunc)
        }
        
    }
    
    func bookmarkEventTapped(id: Int) {
        model.bookmarkRace(withID: id)
        tableView.reloadRows(at: [IndexPath(item: id * 2 + 1, section: 0)], with: UITableViewRowAnimation.automatic)
    }
    
}

extension ASWFeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getNumberOfEvents() * 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item % 2 != 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ASWEventCell", for: indexPath) as! ASWEventCell
            
            // установка id ячейки
            cell.id = indexPath.item / 2
            
            //подписываемся на нажатия кнопок
            cell.delegate = self
            
            //загрузка картинки в ячейку
            let race = model.getEvent(forIndex: indexPath.item / 2)
            cell.eventImage.kf.indicatorType = .activity
            
            //конфигурация ячейки
            configureEvent(cell: cell, race: race)
            
            // проставляем иконку избранное у ячейки
            if (model.checkBookmarkedRace(withID: indexPath.item / 2)) {
                cell.bookmarkButton.setImage(UIImage.bookmarkOn, for: .normal)
            }
            else {
                cell.bookmarkButton.setImage(UIImage.bookmarkOff, for: .normal)
            }
            
            //пагинация
            if ((model.getEvents().count - 3 - indexPath.item / 2 == 0) && self.cursor != nil) {
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    self?.model.updateEvents(cursor: self?.cursor)
                }
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ASWSpacingCell", for: indexPath)
            return cell
        }
    }
    
    
    //конфигурация ячейки
    func configureEvent(cell: ASWEventCell, race: ASWRace) {
        
        cell.eventTitle.text = race.shortTitle
        
        if let categories = race.categories {
            var categoryText = categories.map({"\($0.name ?? "")"}).joined(separator: "; ")
            if (categoryText.isEmpty) {
                categoryText = "Нет категорий"
            }
            cell.categoriesLabel.text = categoryText
        }
        
        cell.timeLabel.text = race.getShortShedule()
        cell.whereLabel.text = race.whereRace
        
        cell.joinLabel.text = race.getJoinDescription()
        cell.watchLabel.text = race.getWatchDescription()
        
        cell.likesLabel.text = "Нравится: \(race.likes ?? 0)"
        
        let likeImage = (race.liked ?? false) ? UIImage.likedOn : UIImage.likedOff
        cell.likeButton.setBackgroundImage(likeImage, for: .normal)

    }
    
}

extension ASWFeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item % 2 != 0 {
            return 166
        }
        else {
            return 8
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.item % 2 != 0 {
            return indexPath
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.item % 2 != 0 {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let race = model.getEvent(forIndex: indexPath.item / 2)
        let viewController = ASWEventViewController(race: race)
        self.navigationController?.pushViewController(viewController, animated: false)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let race = model.getEvent(forIndex: indexPath.item / 2)
        guard let urlString = race.imageURL else {return}
        guard let url = URL(string: urlString) else {return}
        if let cell = cell as? ASWEventCell {
            cell.eventImage.kf
                .setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ASWEventCell {
            cell.eventImage.kf.cancelDownloadTask()
        }
    }
}

extension ASWFeedViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let indexes = indexPaths.map { $0.row / 2 }
        let urls = indexes.flatMap {
            URL(string: model.getEvent(forIndex: $0).imageURL ?? "")
        }

        ImagePrefetcher(urls: urls).start()
    }
}
