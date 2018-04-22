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
    
    let items = [["Личные данные", "Пароль"], ["Вконтакте"], ["Регионы", "Вид спорта", "Гонки автоспорта", "Гонки мотоспорта", "Действия"]]
    
    var botomItems = [["Имя, E-mail, телефон", "Сменить"],[],[]]
    let filterItems = [[],[],[],[],[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let user = ASWDatabaseManager().getUser() ?? ASWUserEntity()
        
        var labelsArray = [String]()
        
        var regions = ASWDatabaseManager().getRegionsIds() ?? []
        labelsArray.append(getLabel(array: regions))
        
        var label = ""
        if user.auto && user.moto{
            label = "Автоспорт, Мотоспорт"
        }else{
            if user.moto{
                label = "Мотоспорт"
            }
            if user.auto{
                label = "Автоспорт"
            }
        }
        labelsArray.append(label)
        
        var categories = ASWDatabaseManager().getCategoriesIds(auto: true) ?? []
        labelsArray.append(getLabel(array: categories))
        
        categories = ASWDatabaseManager().getCategoriesIds(auto: false) ?? []
        labelsArray.append(getLabel(array: categories))
        
        label = ""
        if user.watch && user.join{
            label = "Посмотреть, Покататься"
        }else{
            if user.watch{
                label = "Посмотреть"
            }
            if user.join{
                label = "Покататься"
            }
        }
        labelsArray.append(label)
        
        botomItems[2] = labelsArray
    }
    
    func getLabel(array:[Int])->String{
        var label = ""
        if array.count>0 {
            label = ASWConstantsEntity.regions[array[0]] ?? ""
        }
        if array.count>1{
            for i in 1...array.count-1{
                if let name = ASWConstantsEntity.regions[i]{
                    label += ", "+name
                }
            }
        }
        return label
    }
    
    //настройка UI
    func setupUI() {
        view.backgroundColor = UIColor.ASWColor.greyBackground
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
        settingsTable.backgroundColor = UIColor.ASWColor.greyBackground
    }
    
    //настройка красной кнопки внизу экрана
    //    func setupBottomRedButton() -> UIButton {
    //
    //        //создание самой кнопки
    //        let button: UIButton = UIButton(type: .system)
    //        button.backgroundColor = UIColor.red
    //        //Настройка текста внутри кнопки
    //
    //        button.setTitle("Выйти из аккаунта", for: UIControlState.normal)
    //        button.setTitleColor(UIColor.white, for: UIControlState.normal)
    //
    //        button.addTarget(self, action:#selector(exitFromAccount), for: .touchUpInside)
    //
    //        return button
    //    }
    
    func setupBottomRedButton() -> UIButton {
        
        //создание самой кнопки
        let button: UIButton = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        //Настройка текста внутри кнопки
        
        let title = NSAttributedString(string: "Выйти из аккаунта", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.red])
        button.setAttributedTitle(title, for: UIControlState.normal)
        
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
            cell.bottomLine.text = botomItems[indexPath.section][indexPath.item]
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
        
        if indexPath.section == 0 && indexPath.item == 0 {
            let vc = ASWViewControllersManager.ChangeUserDataViewControllers.changeUserInfo
            vc.view.backgroundColor = .white
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 0 && indexPath.item == 1 {
            let vc = ASWViewControllersManager.ChangeUserDataViewControllers.changePassword
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 2 {
            if indexPath.item == 0 {
                let vc = ASWViewControllersManager.ChangeUserDataViewControllers.changeRegionsViewController
                vc.title = "Регионы"
                navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.item == 1 {
                let vc = ASWViewControllersManager.ChangeUserDataViewControllers.changeSportType
                vc.title = "Вид спорта"
                navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.item == 2 {
                let vc = ASWViewControllersManager.ChangeUserDataViewControllers.changeAutoCategories
                vc.title = "Гонки автоспорта"
                navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.item == 3 {
                let vc = ASWViewControllersManager.ChangeUserDataViewControllers.changeMotoCategories
                vc.title = "Гонки мотоспорта"
                navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.item == 4 {
                let vc = ASWViewControllersManager.ChangeUserDataViewControllers.changeActionTypeViewController
                vc.title = "Действия"
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - functions
    
    @objc func exitFromAccount() {
        let storyboard = UIStoryboard(name: "Registration", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "registr")
        vc.hideTabBarView()
        ASWDatabaseManager().unloginAllUsers()
        let nc = UINavigationController(rootViewController: vc)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = nc
    }
    
}
