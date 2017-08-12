//
//  ASWFeed.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 12.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWFeedTableView: UITableView, UITableViewDataSource, UITableViewDelegate {

    var countOfRows = 0
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        self.register(UINib(nibName: "ASWEventCell", bundle: nil), forCellReuseIdentifier: "ASWEventCell")
        self.register(UINib(nibName: "ASWSpacingCell", bundle: nil), forCellReuseIdentifier: "ASWSpacingCell")
        self.backgroundColor = UIColor.ASWColor.greyBackground
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countOfRows * 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item % 2 != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ASWEventCell", for: indexPath)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ASWSpacingCell", for: indexPath)
            return cell
        }
    }
    
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.deselectRow(at: indexPath, animated: true)
    }
    
    
}
