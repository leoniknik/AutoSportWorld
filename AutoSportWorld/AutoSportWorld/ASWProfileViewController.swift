//
//  ASWProfileController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 17.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuTable: UITableView!
    
    let menuLable = ["Мои настройки", "Написать разработчикам", "О приложении"]
    let menuImages = [#imageLiteral(resourceName: "ic_profil_setting"),#imageLiteral(resourceName: "ic_profil_communications"),#imageLiteral(resourceName: "ic_profil_menu")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTransparentNavBar()
        setupTableView()
    }
    
    func setupTableView() {
        menuTable.delegate = self
        menuTable.dataSource = self
    }

    func setupTransparentNavBar() {
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuLable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as? ASWMenuCell else { return UITableViewCell() }
        cell.menuImageView.image = menuImages[indexPath.item]
        cell.menuTitle.text = menuLable[indexPath.item]
        return cell
    }
}
