//
//  ASWSettingsViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 07.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//


//transition button (awesome swift) из логина на 1 экран
//для избранного и лайк (awesome swift) DOFavoriteButton
//paralaxview для image
//floatLabelFields для логина и пароля
//анимационный таб бар animated-tab-bar
//PasswordTextField для пароля
//SSBouncyButton
//для формы SwiftValidator
//пароль GenericPasswordRow
//DGRunkeeperSwitch

import UIKit

class ASWSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settingsTable: UITableView!
    
    let sections = ["Данные пользователя", "Социальные сети", "Настройка фильтров"]
    
    let items = [["Имя", "Эл.адрес", "Телефон", "Сменить пароль"], ["Вконтакте", "Одноклассники", "Facebook"], ["Регионы", "Категории гонок", "Действия"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTable.dataSource = self
        settingsTable.delegate = self
        setupUI()
    }
    
    //настройка UI
    func setupUI() {
        //настройка цвета фона navigationbar
        navigationController?.navigationBar.barTintColor = UIColor.green
        //настройка красной кнопки внизу экрана
        setupBottomRedButton()
    }
    
    //настройка красной кнопки внизу экрана
    func setupBottomRedButton() {
        //создание самой кнопки
        let button: UIButton = UIButton()
        button.backgroundColor = UIColor.red
        //Настройка текста внутри кнопки
        button.setTitle("Выйти из аккаунта", for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        //определение местоположения кнопки (низ экрана)
        let x: CGFloat = 25
        let y = self.view.frame.size.height - 60
        button.layer.frame = CGRect(x: x, y: y, width: self.view.frame.size.width - 50, height: 45)
        
        self.view.addSubview(button)
        
//        button.addTarget(self, action:#selector(self.buttonClicked), forControlEvents: .TouchUpInside)
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ASWSettingsUserDataCell", for: indexPath)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ASWSettingsSocialNetworkCell", for: indexPath)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ASWSettingsFilterCell", for: indexPath)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == 1 || section == 0 {
            return 25
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 35
        }
        return 25
    }
    
    //MARK: - IBAction
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
