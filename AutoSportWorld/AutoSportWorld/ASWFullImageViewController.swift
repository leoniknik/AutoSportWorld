//
//  ASWFullImageViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 04.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit
import Kingfisher

class ASWFullImageViewController: UIViewController {

    @IBOutlet weak var eventImage: UIImageView!
    
    var race: ASWRace
    
    init(race: ASWRace) {
        self.race = race
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let urlString = race.imageURL else {return}
        guard let url = URL(string: urlString) else {return}
        eventImage.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
    }

    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
