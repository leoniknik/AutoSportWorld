//
//  ASWEventViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 02.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit
import Kingfisher

class ASWEventViewController: ASWViewController {

    @IBOutlet weak var commonLikeView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var raceImage: UIImageView!
    
    //лайки и цена
    @IBOutlet weak var likedCountLabel: UILabel!

    @IBOutlet weak var likeButton: UIButton!
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
        self.hidesBottomBarWhenPushed = true
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
        setupLikeActionForLikesLabel()
    }
    
    func setupLikeActionForLikesLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(like))
//        likedCountLabel.addGestureRecognizer(tapGesture)
        commonLikeView.addGestureRecognizer(tapGesture)
    }
    
    func setupActionsForInfoLabels() {
        let gestureRecognizerMap = UITapGestureRecognizer(target: self, action: #selector(openMap))
        placeLabel.addGestureRecognizer(gestureRecognizerMap)
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
        setupLiked()
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
        guard let urlString = race.imageURL else {return}
        guard let url = URL(string: urlString) else {return}
        
        raceImage.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showFullImage))
        raceImage.isUserInteractionEnabled = true
        raceImage.addGestureRecognizer(tapGestureRecognizer)
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
        if ASWDatabaseManager().checkPermission(){
            model.bookmarkRace(race: race)
            updateCircleView()
        }else{
            presentPermissionAlert()
        }
        
    }
    
    func updateCircleView() {
        if model.checkBookmarkedRace(race: race) {
            bookmarkButton.setImage(UIImage.cardBookmarkOn, for: .normal)
        } else {
            bookmarkButton.setImage(UIImage.cardBookmarkOff, for: .normal)
        }
    }
    
    @IBAction @objc func likeEvent(_ sender: UIButton) {
        if ASWDatabaseManager().checkPermission(){
            like()
        }else{
            presentPermissionAlert()
        }
    }
    
    @objc func like() {
        guard model.canLike() == true else { return }
        
        func sucsessFunc(){
            race.liked = !(race.liked ?? false)
            updateLiked()
        }
        
        if race.liked ?? false {
            model.unlikeEvent(id: race.id ?? "", sucsessFunc: sucsessFunc)
        } else {
            model.likeEvent(id: race.id ?? "", sucsessFunc: sucsessFunc)
        }
    }
    
    func setupLiked() {
        likedCountLabel.text = "Нравится: \(race.likes ?? 0)"
        if race.liked ?? false {
            likeButton.setImage(UIImage.cardLikedOn, for: .normal)
        } else {
            likeButton.setImage(UIImage.cardLikedOff, for: .normal)
        }
    }
    
    func updateLiked() {
        if let liked = race.liked {
            race.liked = !liked
            if race.likes != nil {
                race.likes = race.likes ?? 0 - 1
            } else {
                race.likes = 0
            }
        } else {
            race.liked = true
            race.likes = (race.likes ?? 0) + 1
        }
        
        if race.likes ?? 0 < 0 {
            race.likes = 0
        }
        
        setupLiked()
    }
    
    func updateTitle() {
        fullTitle.text = race.title
        categoriesLabel.text = race.getRaceCategories()
    }
    
    @IBAction func showMap(_ sender: UIButton) {
        openMap()
    }
    
    @objc func openMap() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "map") as? ASWMapViewController else { return }
        vc.isFromEvent = true
        vc.choosenEvents.append(race)
        navigationController?.pushViewController(vc, animated: true)
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
        
        UIView.animate(withDuration: 0.25) {
            if !self.isShowedAdditionalInfo {
                self.additionalInfoButton.transform = CGAffineTransform.identity
            } else {
                self.additionalInfoButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi)
            }
        }
    }
    
    @objc func goBack() {
        if let viewController = navigationController?.previousViewController() as? ASWMapViewController {
            viewController.shouldClear = false
        }
        self.navigationController?.popViewController(animated: false)
    }
    
}
