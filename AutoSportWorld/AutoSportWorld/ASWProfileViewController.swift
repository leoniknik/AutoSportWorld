//
//  ASWProfileController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 17.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWProfileViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var regButton: UIButton!
    @IBOutlet weak var menuTable: UITableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewForAuth: UIView!
    @IBOutlet weak var viewForUnauth: UIView!
    @IBOutlet weak var ematilLabel: UILabel!
    @IBOutlet weak var bigText: UILabel!
    
    let menuLable = ["Мои настройки", "Написать разработчикам", "О приложении"]
    let menuImages = [#imageLiteral(resourceName: "ic_profil_setting"),#imageLiteral(resourceName: "ic_profil_communications"),#imageLiteral(resourceName: "ic_profil_menu")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupTransparentNavBar()
    }
    
    func setupTableView() {
        menuTable.delegate = self
        menuTable.dataSource = self
    }
    
    func setupUI() {
        setupButton()
        if let user = ASWDatabaseManager().getUser() {
            topConstraint.constant = 0
            viewForAuth.isHidden = false
            viewForUnauth.isHidden = true
            ematilLabel.text = user.email
            bigText.isHidden = true
        } else {
            viewForAuth.isHidden = true
            viewForUnauth.isHidden = false
            topConstraint.constant = 21
            bigText.isHidden = false
        }
    }
    
    func setupButton() {
        regButton.layer.cornerRadius = 10
        regButton.clipsToBounds = true
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
    
    func openAboutApp() {
        let storyboard = UIStoryboard(name: "AboutApp", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "aboutApp")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func openContacts() {
        let storyboard = UIStoryboard(name: "AboutApp", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "developers")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        
    }
    
    func openSettings() {
        performSegue(withIdentifier: "toSettings", sender: nil)
    }
    
}

extension ASWProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item == 2 {
            openAboutApp()
        } else if indexPath.item == 1 {
            openContacts()
        } else if indexPath.item == 0 {
            openSettings()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
