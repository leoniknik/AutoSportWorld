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
//ALThreeCircleSpinner для ожидания

import UIKit

class ASWSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settingsTable: UITableView!
    
    let sections = ["Информация о пользователе", "Социальные сети", "Фильтры"]
    
    let items = [["Личные данные", "Пароль"], ["Вконтакте"], ["Регионы", "Категории гонок","Гонки автоспорта", "Гонки мотоспорта", "Действия"]]
    let botomItems = [["Имя, E-mail, телефон", "Сменить"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
    
    //настройка UI
    func setupUI() {
        setupSettingsTable()
        setupBlackOpaqueNavBar()
        addBackButton(animated: true)
        navigationController?.navigationBar.tintColor = .white
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupNavbar() {
        //убираем полоску между хедером и навигейшен баром
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.ASWColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    //настройка таблицы
    func setupSettingsTable() {
        
        settingsTable.dataSource = self
        settingsTable.delegate = self
        
        //настройка футера (отступа) для таблицы
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 75))
        let button = setupBottomRedButton()
        button.frame = CGRect(x: customView.bounds.minX, y: customView.bounds.minY + 25, width: customView.bounds.width, height: customView.bounds.height - 25)
        customView.addSubview(button)
        customView.backgroundColor = UIColor.ASWColor.greyBackground
        settingsTable.tableFooterView = customView
    }
    
    //настройка красной кнопки внизу экрана
    func setupBottomRedButton() -> UIButton {
        
        //создание самой кнопки
        let button: UIButton = UIButton(type: .system)
        button.backgroundColor = UIColor.red
        //Настройка текста внутри кнопки
        
        button.setTitle("Выйти из аккаунта", for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        button.addTarget(self, action:#selector(exitFromAccount), for: .touchUpInside)
        
        return button
    }

    // MARK: - Table view data source

    //количество секций
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    //названия для секций
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    //установка цвета заголовка секции
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.ASWColor.grey
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ASWSettingsUserDataCell", for: indexPath) as! ASWSettingsUserDataCell
            cell.infoLabel.text = items[indexPath.section][indexPath.item]
            cell.bottomLine.text = botomItems[indexPath.section][indexPath.item]
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ASWSettingsSocialNetworkCell", for: indexPath) as! ASWSettingsSocialNetworkCell
            cell.socialTextLabel.text = items[indexPath.section][indexPath.item]
            return cell
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ASWSettingsUserDataCell", for: indexPath) as! ASWSettingsUserDataCell
            cell.infoLabel.text = items[indexPath.section][indexPath.item]
//            cell.bottomLine.text = botomItems[indexPath.section][indexPath.item]
            return cell
        }
        else {
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
    
    //высота ячеек
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    //выбор ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 && indexPath.item == 0 {
            performSegue(withIdentifier: ASWSegueRouter.changeRegions, sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - functions
    
    @objc func exitFromAccount() {
        
    }
    
}
