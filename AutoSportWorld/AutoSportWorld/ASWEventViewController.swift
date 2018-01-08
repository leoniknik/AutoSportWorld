//
//  ASWEventViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 02.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWEventViewController: UIViewController {

    @IBOutlet weak var raceImage: UIImageView!
    
    
    // расписание
    @IBOutlet weak var sheduleView: UIView!
    @IBOutlet weak var timeImage: UIImageView!
    @IBOutlet weak var sheduleLabel: UILabel!
    
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
        setupUI()
        setupRace()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // проверка избранного
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.ASWColor.greyBackground
        setupNavItem()
        setupShedule()
    }
    
    func setupRace() {
        if let image = race.image {
            raceImage.image = image
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showFullImage))
            raceImage.isUserInteractionEnabled = true
            raceImage.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    func setupShedule() {
        if (sheduleLabel.text!.isEmpty) {
            sheduleView.isHidden = true
        }
    }
    
    @objc func showFullImage() {
        let viewController = ASWFullImageViewController(race: race)
        self.present(viewController, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupNavItem() {
        self.navigationItem.title = "Событие"
        
        let backButton = UIBarButtonItem(image: UIImage.backward, style: .done, target: self, action: #selector(goBack))
        self.navigationItem.setLeftBarButton(backButton, animated: false)
        
        let shareButton = UIBarButtonItem(image: UIImage.share, style: .done, target: self, action: #selector(shareEvent))
        let favoriteButton = UIBarButtonItem(image: UIImage.cardBookmarkOff, style: .done, target: self, action: #selector(setFavorite))
        
        self.navigationItem.setRightBarButtonItems([favoriteButton, shareButton], animated: true)
        
    }
    
    @objc func shareEvent() {
        
        let textToShare = """
            \(race.title ?? "")\n
            \(race.getRaceCategories())\n
            \(race.getFullShedule())\n
            \(race.whereRace ?? "")
        """
        
        let objectsToShare = [textToShare]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @objc func setFavorite() {
        
    }
    
    @IBAction func showMap(_ sender: UIButton) {
        
    }
    
    @IBAction func showSite(_ sender: UIButton) {
        let viewController = ASWWebViewController(race: race)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func showAdditionalInformation(_ sender: UIButton) {
        
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: false)
    }
    
}
