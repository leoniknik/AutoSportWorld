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
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "О приложении"
        setupUI()
        
    }
    
    func setupUI(){
        rateButton.layer.cornerRadius = 10
        rateButton.clipsToBounds=true
        rateButton.layer.borderWidth = 1
        rateButton.layer.borderColor = UIColor.ASWColor.pink.cgColor
        rateButton.setTitleColor(UIColor.ASWColor.pink, for: .normal)
        serviceLabel.textColor = UIColor.ASWColor.grey
    }
    
    
    @IBAction func rate(_ sender: Any) {
        //UIApplication.shared.openURL(NSURL(string : "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=<iTUNES CONNECT APP ID>")! as URL)
    }


    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
