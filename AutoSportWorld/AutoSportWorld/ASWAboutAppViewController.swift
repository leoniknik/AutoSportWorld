//
//  AboutAppViewController.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 20/08/2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWAboutAppViewController: UIViewController {

    @IBOutlet weak var serviceLabel: UILabel!
    
    @IBOutlet weak var rateButton: UIButton!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var termsOfUseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "О приложении"
        setupUI()
        versionLabel.text = "Версия: \( UIApplication.versionBuild())"
    }
    
    func setupUI(){
        ASWButtonManager.setupButton(button: rateButton)
        serviceLabel.textColor = UIColor.ASWColor.grey
    }
    
    
    @IBAction func rate(_ sender: Any) {
        //UIApplication.shared.openURL(NSURL(string : "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=<iTUNES CONNECT APP ID>")! as URL)
    }

    @IBAction func termsOfUseAction(_ sender: Any) {
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
