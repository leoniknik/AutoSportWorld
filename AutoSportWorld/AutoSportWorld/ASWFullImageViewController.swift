//
//  ASWFullImageViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 04.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventImage.image = race.image
    }

    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
