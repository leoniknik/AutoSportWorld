//
//  ASWFeedViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 20.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWFeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: ASWFeedTableView!
    
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshView()
        setupUI()
    }

    func setupUI() {
    }
    
    func setupRefreshView() {
        //добавление активити для обновления
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление...", attributes: [:])
    }
    
    //обновление данных
    func refreshData(_ sender: Any) {
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
}
