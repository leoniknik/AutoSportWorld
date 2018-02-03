//
//  ASWEventViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 02.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWEventViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var raceImage: UIImageView!
    
    //лайки и цена
    @IBOutlet weak var likedCountLabel: UILabel!
    @IBOutlet weak var likedImage: UIImageView!
    @IBOutlet weak var blueCircle: UIView!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    //титулы
    @IBOutlet weak var fullTitle: UILabel!
    
    @IBOutlet weak var categoriesLabel: UILabel!
    
    // расписание
    @IBOutlet weak var sheduleView: UIView!
    @IBOutlet weak var timeImage: UIImageView!
    @IBOutlet weak var sheduleLabel: UILabel!
    
    //инфа
    @IBOutlet weak var qualificationLabel: UILabel!
    @IBOutlet weak var wpriceLabel: UILabel!
    @IBOutlet weak var jpriceLabel: UILabel!
    
    //доп инфа
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var placeButton: UIButton!
    @IBOutlet weak var additionalInformationLabel: UILabel!
    @IBOutlet weak var additionalInfoButton: UIButton!
    
    @IBOutlet weak var additionalInfoView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    
    //внешние вью
    @IBOutlet weak var placeExtrernalView: UIView!
    @IBOutlet weak var siteExternalView: UIView!
    @IBOutlet weak var addExternalView: UIView!
    
    
    var race: ASWRace
    var isShowedAdditionalInfo = false
    
    let model = ASWEventModel()
    
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
        setupActionsForInfoLabels()
        setupBlueCircle()
    }

    
    func setupActionsForInfoLabels() {
        let gestureRecognizerSite = UITapGestureRecognizer(target: self, action: #selector(showWebView))
        siteLabel.addGestureRecognizer(gestureRecognizerSite)
        let gestureRecognizerInfo = UITapGestureRecognizer(target: self, action: #selector(updateAddInfo))
        additionalInformationLabel.addGestureRecognizer(gestureRecognizerInfo)
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.ASWColor.greyBackground
        setupNavItem()
        setupShedule()
        updateCircleView()
        updateLiked()
        updateTitle()
        setupInfo()
    }
    
    func setupInfo() {
        qualificationLabel.text = "Квалицикация - \(race.level ?? "неизвестно")"
        jpriceLabel.text = race.getJoinDescription()
        wpriceLabel.text = race.getWatchDescription()
        
        if let text = race.whereRace {
            placeLabel.text = text
        } else {
            placeExtrernalView.isHidden = true
            placeExtrernalView.frame = CGRect(x: placeExtrernalView.frame.origin.x, y: placeExtrernalView.frame.origin.y, width: placeExtrernalView.frame.width, height: 0)
        }
        
        race.link = "vk.com/autofest15"
        
        if let text = race.link {
            siteLabel.text = text
        } else {
            siteExternalView.isHidden = true
            siteExternalView.frame = CGRect(x: siteExternalView.frame.origin.x, y: siteExternalView.frame.origin.y, width: siteExternalView.frame.width, height: 0)
        }

        infoLabel.text = ""
        infoLabel.isHidden = true
//        if race.textRace != nil {
//            addExternalView.isHidden = true
//        }
    }
    
    
    
    func setupBlueCircle() {
        blueCircle.layer.cornerRadius = blueCircle.frame.width / 2
        blueCircle.clipsToBounds = true
        
        bookmarkButton.addTarget(self, action: #selector(setFavorite), for: .touchUpInside)
        
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
        sheduleLabel.text = race.getFullShedule()
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
        self.navigationItem.setRightBarButtonItems([shareButton], animated: false)
        
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
        model.bookmarkRace(race: race)
        updateCircleView()
    }
    
    func updateCircleView() {
        if model.checkBookmarkedRace(race: race) {
            bookmarkButton.setBackgroundImage(UIImage.cardBookmarkOn, for: .normal)
        } else {
            bookmarkButton.setBackgroundImage(UIImage.cardBookmarkOff, for: .normal)
        }
    }
    
    func updateLiked() {
        likedCountLabel.text = "Нравится: \(race.likes ?? 0)"
        if race.liked ?? false {
            likedImage.image = UIImage.cardLikedOn
        } else {
            likedImage.image = UIImage.cardLikedOff
        }
    }
    
    func updateTitle() {
        fullTitle.text = race.title
        categoriesLabel.text = race.getRaceCategories()
    }
    
    @IBAction func showMap(_ sender: UIButton) {
        
    }
    
    @IBAction func showSite(_ sender: UIButton) {
        showWebView()
    }
    
    @objc func showWebView() {
        let viewController = ASWWebViewController(race: race)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func showAdditionalInformation(_ sender: UIButton) {
        updateAddInfo()
    }
    
    @objc func updateAddInfo() {
        guard let text = race.textRace else { return }
        if !isShowedAdditionalInfo {
            infoLabel.text = text
            infoLabel.isHidden = false
            isShowedAdditionalInfo = true
        } else {
            infoLabel.text = ""
            infoLabel.isHidden = true
            isShowedAdditionalInfo = false
        }
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: false)
    }
    
}
