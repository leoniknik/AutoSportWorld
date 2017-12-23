//
//  ASWFeedViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 20.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWFeedViewController: UIViewController, ASWFeedsModelDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var errorLabel: UILabel!
    
    let refreshControl = UIRefreshControl()
    var model: ASWFeedsModelProtocol = ASWFeedsModel()

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
    }
    
    
    func setupUI() {
        setupNavbar()
    }
    
    func setupNavbar() {
        searchBar.backgroundColor = UIColor.ASWColor.black
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        //убираем полоску между хедером и навигейшен баром
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.ASWColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationItem.title = "Лента новостей"
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
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление...", attributes: [:])
    }
    
    func getUpdate() {
        self.errorLabel.isHidden = true
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.model.updateEvents()
        }
    }
    
    //обновление данных
    func refreshData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "ASWEventCell", bundle: nil), forCellReuseIdentifier: "ASWEventCell")
        self.tableView.register(UINib(nibName: "ASWSpacingCell", bundle: nil), forCellReuseIdentifier: "ASWSpacingCell")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func update() {
        refreshData()
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
        }
    }
    
}

extension ASWFeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getNumberOfEvents() * 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item % 2 != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ASWEventCell", for: indexPath) as! ASWEventCell
            let race = model.getEvent(forIndex: indexPath.item / 2)
            configureEvent(cell: cell, race: race)
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
            let categoryText = " ".fla
        }

    }
    
}

extension ASWFeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item % 2 != 0 {
            return 187
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
}








