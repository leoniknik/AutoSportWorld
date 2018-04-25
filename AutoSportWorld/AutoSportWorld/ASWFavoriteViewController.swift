//
//  ASWFavoriteViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 03.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit
import Kingfisher

class ASWFavoriteViewController: UIViewController, ASWEventCellDelegate, ASWFeedsModelDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    let refreshControl = UIRefreshControl()
    var model = ASWFavoriteModel()
    var shoudUpdate: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        model.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.backgroundColor = UIColor.ASWColor.greyBackground
        updateRefreshControl()
        if shoudUpdate {
            model.events.removeAll()
            model.results.removeAll()
            tableView.reloadData()
            setupUI()
            getUpdate()
        }
        shoudUpdate = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setupUI() {
        setupNavbar()
        setupRefreshView()
        self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentOffset.y-self.refreshControl.frame.size.height), animated: false)
        updateRefreshControl()
    }
    
    func setupNavbar() {
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.ASWColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = "Избранное"
        self.navigationController?.navigationBar.tintColor = .white
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
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление", attributes: [:])
    }
    
    @objc func getUpdate() {
        self.refreshControl.beginRefreshing()
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
            self?.tableView.refreshControl = nil
        }
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "ASWEventCell", bundle: nil), forCellReuseIdentifier: "ASWEventCell")
        self.tableView.register(UINib(nibName: "ASWSpacingCell", bundle: nil), forCellReuseIdentifier: "ASWSpacingCell")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func update(cursor: String?) {
        refreshData()
    }
    
    func updateError() {
        DispatchQueue.main.async { [weak self] in
            self?.errorLabel.isHidden = false
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.refreshControl = nil
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
        }
    }
    
    func likeEventTapped(id: Int) {
        
    }
    
    func bookmarkEventTapped(id: Int) {
        model.bookmarkRace(withID: id)
        tableView.reloadRows(at: [IndexPath(item: id * 2 + 1, section: 0)], with: UITableViewRowAnimation.automatic)
    }
    
}

extension ASWFavoriteViewController: UITableViewDataSource {
    
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
        
        var categoryText = race.getRaceCategories()
        if (categoryText.isEmpty) {
            categoryText = "Нет категорий"
        }
        cell.categoriesLabel.text = categoryText
        
        
        cell.timeLabel.text = race.getShortShedule()
        cell.whereLabel.text = race.whereRace
        
        if (race.canJoin ?? false) {
            if let _ = race.jpriceFrom, let _ = race.jpriceTo {
                cell.joinLabel.text = "Покататься - да"
            }
            else if let priceTo = race.jpriceTo, priceTo == 0 {
                cell.joinLabel.text = "Покататься - бесплатно"
            }
            else if let priceFrom = race.jpriceFrom {
                cell.joinLabel.text = "Покататься - от \(priceFrom) р."
            }
            else {
                cell.joinLabel.text = "Покататься - да"
            }
        }
        else {
            cell.joinLabel.text = "Покататься - нет"
        }
        
        if (race.canWatch ?? false) {
            if let _ = race.wpriceFrom, let _ = race.wpriceTo {
                cell.watchLabel.text = "Посмотреть - да"
            }
            else if let priceTo = race.wpriceTo, priceTo == 0 {
                cell.watchLabel.text = "Посмотреть - бесплатно"
            }
            else if let priceFrom = race.wpriceFrom {
                cell.watchLabel.text = "Посмотреть - от \(priceFrom) р."
            }
            else {
                cell.watchLabel.text = "Посмотреть - да"
            }
        }
        else {
            cell.watchLabel.text = "Посмотреть - нет"
        }
        
        cell.likesLabel.text = "Нравится: \(race.likes ?? 0)"
        
        let likeImage = (race.liked ?? false) ? UIImage.likedOn : UIImage.likedOff
        cell.likeImage.image = likeImage
        
    }
    
}

extension ASWFavoriteViewController: UITableViewDelegate {
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
