//
//  ASWMyEventsViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 11.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWMyEventsViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var eventsTable: ASWFeedTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTable()
    }
    
    func setupUI() {
        setupHeaderView()
        setupNavigationBar()
    }
    
    func setupHeaderView() {
        headerView.backgroundColor = UIColor.ASWColor.black
    }
    
    func setupNavigationBar() {
        //убираем полоску между хедером и навигейшен баром
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setupTable() {
        eventsTable.countOfRows = 2
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
