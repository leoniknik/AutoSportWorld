//
//  RulesViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 25.03.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWRulesViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        textLabel.text = """
        Команда RxProject не несет ответственности за контент, который размещен в приложении «Мир автоспорта». Мы предоставляем администраторам (заказчику) техническую возможность размещать и хранить информацию на серверах третьих лиц. Чтобы получить возможность размещать и хранить свой контент заказчик принимает условия пользовательского соглашения, в соответствии с которым обязуется не создавать и не размещать незаконный контент.
        
        Мы уважаем права и интересы правообладателей, а также пользователей наших сервисов. У вас есть возможность отправить возникшие жалобы на почту info@rxproject.ru, в теме письма укажите «Жалоба. Мир автоспорта». Жалобы должны быть обоснованными и содержать необходимую информацию для принятия решения о мерах реагирования.
        """
        scrollView.bottomAnchor.constraint(equalTo: textLabel.bottomAnchor).isActive = true
        addBackButton()
        setupBlackOpaqueNavBar()
        title = "Условия использования"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
