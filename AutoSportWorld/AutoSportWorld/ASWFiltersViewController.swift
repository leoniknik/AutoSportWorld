//
//  ASWFiltersViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 23.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWFiltersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let model = ASWFiltersModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ASWColor.greyBackground
        tableView.backgroundColor = UIColor.ASWColor.greyBackground
    }
    
    override func viewDidLayoutSubviews() {
        setupTableView()
        setupNavItem()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupNavItem() {
        self.navigationItem.title = "Сортировка"

        let backButton = UIBarButtonItem(image: UIImage.backward, style: .done, target: self, action: #selector(goBack))
        self.navigationItem.setLeftBarButton(backButton, animated: false)
    }
    
    @objc func goBack() {
        if let viewController = self.navigationController?.previousViewController() as? ASWFavoriteViewController {
            viewController.shoudUpdate = false
        }
        self.navigationController?.popViewController(animated: false)
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "ASWFilterCell", bundle: nil), forCellReuseIdentifier: "ASWFilterCell")
//        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        
        //настройка футера для таблицы
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 90))
        let button = setupBottomRedButton()
        button.frame = CGRect(x: 0, y: customView.bounds.minY + 40, width: customView.bounds.width, height: customView.bounds.height - 40)
        customView.addSubview(button)
        customView.backgroundColor = UIColor.ASWColor.greyBackground
        tableView.tableFooterView = customView
    }
    
    //настройка красной кнопки внизу экрана
    func setupBottomRedButton() -> UIButton {
        
        //создание самой кнопки
        let button: UIButton = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        //Настройка текста внутри кнопки
        
        let title = NSAttributedString(string: "Значения по умолчанию", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.red])
        button.setAttributedTitle(title, for: UIControlState.normal)
        
        //button.addTarget(self, action:#selector(exitFromAccount), for: .touchUpInside)
        
        return button
    }
}


extension ASWFiltersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.getTitleForHeaderIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getNumberOfRowsIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ASWFilterCell", for: indexPath) as! ASWFilterCell
        cell.switchView.isOn = model.values[indexPath.section][indexPath.item]
        cell.indexPath = indexPath
        cell.delegate = self
        cell.titleView.text = model.items[indexPath.section][indexPath.item]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(model.getHeightForFooterIn(section: section))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //установка цвета заголовка секции
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.ASWColor.lightGrey
    }
}

extension UINavigationController {
    
    ///Get previous view controller of the navigation stack
    func previousViewController() -> UIViewController?{
        
        let lenght = self.viewControllers.count
        
        let previousViewController: UIViewController? = lenght >= 2 ? self.viewControllers[lenght-2] : nil
        
        return previousViewController
    }
    
}

extension ASWFiltersViewController: ASWFilterCellDelegate {
    func valueChanged(indexPath: IndexPath) {
        model.valueChangedFor(indexPath)
    }
}
