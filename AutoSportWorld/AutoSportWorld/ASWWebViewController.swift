//
//  ASWWebViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 04.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var race: ASWRace
    
    init(race: ASWRace) {
        self.race = race
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // проверить если нет префикса - его добавить
//        убрать таб бар
        
//        if let string = race.link {
        if let url = URL(string: "https://vk.com/autofest15") {
                let urlRequest = URLRequest(url: url)
                self.webView.loadRequest(urlRequest)
            }
//        }
    }

}
