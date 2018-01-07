//
//  ASWRegistrationViewController.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 04.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

//
//  ASWCollectionViewController.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 16.08.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//


// remake backstep
// make forwardstep



import UIKit

class ASWRegistrationViewController: UIViewController, ASWCollectionViewControllerDelegate, ASWRegisterAccountViewControllerDelegate {
    
    func updateUserLoginInfo(valid: Bool, login: String, email: String, password: String) {
        confirmButton.isEnabled = valid
        userEntity.login = login
        userEntity.email = email
        userEntity.password = password
    }
    
    func updateSelectedRaceTypes(raceTypeIDs: [Int]) {
        //updates
    }
    
    
    func updateSelectedRegions(regionsIDs: [Int]) {
        // updates
    }
    
    func actionTypeSelected(auto: Bool, watch: Bool, join: Bool) {
        if auto {
            userEntity.autoWatch = watch
            userEntity.autoJoin = join
        }else{
            userEntity.motoWatch = watch
            userEntity.motoJoin = join
        }
    }
    
    
    func sportTypeSelected(moto: Bool, auto: Bool) {
        userEntity.auto = auto
        userEntity.moto = moto
        
        if (auto && moto){
            stepAmaunt = 7
        }else if (auto || moto){
            stepAmaunt = 5
        }else{
            stepAmaunt = 2
        }
        
        setStepLabel()
    }
    
    
    
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var stepAndProgressView: UIView!
    
    
    @IBOutlet weak var rightBarItem: UIBarButtonItem!
    
    @IBOutlet weak var containerView: UIView!
    
    var currentStep:Int = 0
    var stepAmaunt:Int = 2
    
    var userEntity = ASWUserEntity()
    

    
    private lazy var registerAccountViewController: ASWRegisterAccountViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Registration", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "rg") as! ASWRegisterAccountViewController
        return viewController
    }()
    
    private lazy var registerCollectionViewController: ASWCollectionViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Registration", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "rr") as! ASWCollectionViewController
        return viewController
    }()
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        add(asChildViewController: registerAccountViewController)
        registerAccountViewController.delegate = self
        setupRightBarItem(avalible: false, title: "")
        setStepLabel()
        ASWButtonManager.setupButton(button: confirmButton)
        confirmButton.isEnabled = false
    }
    
    func setupUI() {
        
        confirmButton.backgroundColor = UIColor.ASWColor.black
        stepLabel.textColor = UIColor.ASWColor.grey
        progressView.progressTintColor = UIColor.ASWColor.yellow
        
        //
        //важно вынести в отдельную функцию
        //убираем полоску между хедером и навигейшен баром
        //navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //navigationController?.navigationBar.shadowImage = UIImage()
        //searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    }
    
    func setupRightBarItem(avalible: Bool, title: String) {
        rightBarItem.title = title
        self.navigationItem.rightBarButtonItem?.customView?.isHidden = !avalible
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        if(currentStep==0){
            navigationController?.popViewController(animated: true)
        }else{
            currentStep-=1
            setStep()
        }
    }
    
    
    
    @IBAction func rightBarItemTapped(_ sender: Any) {
        registerCollectionViewController.rightBarItemTapped()
    }
    
    func hideStepAndProgressView() {
        
        stepLabel.isHidden = true
        progressView.isHidden = true
        if let constraint = (stepAndProgressView.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = 0.0
        }
    }
    
    
    @IBAction func performNextStep(_ sender: Any) {
        if(currentStep==0){
            //if(registerAccountViewController.isFormValid()){
            currentStep+=1
            setStep()
            //}
        } else if(currentStep == 1){
            currentStep+=1
            setStep()
        } else if(currentStep == 2){
            currentStep+=1
            setStep()
        }else if(currentStep == 3){
            currentStep+=1
            setStep()
        }else if(currentStep == 4){
            currentStep+=1
            setStep()
        }else if(currentStep == 5){
            currentStep+=1
            setStep()
        }else if(currentStep == 6){
            //registerUser
        }
        
    }
    
    func setStep(){
        setStepLabel()
        
        // 0-email
        // 1-sportType
        // 2-regions
        //     auto     moto    a+m
        // 3-autoCat_motoCat_autoCat
        // 4-autoAct_motoAct_motoCat
        // 5-                autoAct
        // 6-                motoAct
        
        
        if(currentStep == 0){
            // email step
            
            remove(asChildViewController: registerCollectionViewController)
            add(asChildViewController: registerAccountViewController)
            registerAccountViewController.name = userEntity.login
            registerAccountViewController.email = userEntity.email
            registerAccountViewController.password = userEntity.password
            registerAccountViewController.fillFormFromUserModel()
            registerAccountViewController.delegate = self
            confirmButton.isEnabled = registerAccountViewController.isFormValid()
            setupRightBarItem(avalible: false, title: "")
        }
        
        if(currentStep == 1){
            // sporttype step
            //userEntity = registerAccountViewController.userModel
            remove(asChildViewController: registerAccountViewController)
            add(asChildViewController: registerCollectionViewController)
            
            var dataSource = ASWSportTypeCollectionViewDataSource(collectionView: registerCollectionViewController.collectionView, userModel: userEntity)
            
            registerCollectionViewController.datasource = dataSource
            dataSource.delegate = registerCollectionViewController
            registerCollectionViewController.collectionView.dataSource = dataSource
            registerCollectionViewController.collectionView.delegate = registerCollectionViewController
            registerCollectionViewController.delegate = self
            registerCollectionViewController.setupRightBarItem()
            registerCollectionViewController.hideSearchBar()
        }
        
        if (currentStep == 2){
            //regions step
            var dataSource = ASWRegionsCollectionViewDataSource(collectionView: registerCollectionViewController.collectionView, selectedRegions: [Int]())
            
            
            registerCollectionViewController.datasource = dataSource
            dataSource.delegate = registerCollectionViewController
            registerCollectionViewController.collectionView.dataSource = dataSource
            registerCollectionViewController.collectionView.delegate = registerCollectionViewController
            registerCollectionViewController.searchBar.delegate = dataSource
            registerCollectionViewController.delegate = self
            registerCollectionViewController.setupRightBarItem()
            registerCollectionViewController.showSearchBar()
            
        }
        
        if (currentStep == 3){
            // auto or moto types
            var dataSource = ASWRaceCategoryCollectionViewDataSource(collectionView: registerCollectionViewController.collectionView, selectedRaceCategory: [Int](), auto: userEntity.auto)
            registerCollectionViewController.datasource = dataSource
            dataSource.delegate = registerCollectionViewController
            registerCollectionViewController.collectionView.dataSource = dataSource
            registerCollectionViewController.collectionView.delegate = registerCollectionViewController
            registerCollectionViewController.searchBar.delegate = dataSource
            registerCollectionViewController.delegate = self
            registerCollectionViewController.setupRightBarItem()
            registerCollectionViewController.showSearchBar()
        }
        
        if (currentStep == 4){
            // auto action or moto action or moto type

            if(userEntity.auto && userEntity.moto){
                var dataSource = ASWRaceCategoryCollectionViewDataSource(collectionView: registerCollectionViewController.collectionView, selectedRaceCategory: [Int](), auto: false)
                registerCollectionViewController.datasource = dataSource
                dataSource.delegate = registerCollectionViewController
                registerCollectionViewController.collectionView.dataSource = dataSource
                registerCollectionViewController.collectionView.delegate = registerCollectionViewController
                registerCollectionViewController.searchBar.delegate = dataSource
                registerCollectionViewController.delegate = self
                registerCollectionViewController.setupRightBarItem()
                registerCollectionViewController.showSearchBar()
            }else {
                var dataSource = ASWActionTypeCollectionViewDataSource(collectionView: registerCollectionViewController.collectionView,auto:userEntity.auto, userModel: userEntity)
                
                registerCollectionViewController.datasource = dataSource
                dataSource.delegate = registerCollectionViewController
                registerCollectionViewController.collectionView.dataSource = dataSource
                registerCollectionViewController.collectionView.delegate = registerCollectionViewController
                registerCollectionViewController.delegate = self
                registerCollectionViewController.setupRightBarItem()
                registerCollectionViewController.hideSearchBar()
            }
        }
        if (currentStep == 5 || currentStep == 6){
            var dataSource:ASWActionTypeCollectionViewDataSource!
            
            if (currentStep == 5){
                dataSource = ASWActionTypeCollectionViewDataSource(collectionView: registerCollectionViewController.collectionView,auto:true, userModel: userEntity)
            }else{
                dataSource = ASWActionTypeCollectionViewDataSource(collectionView: registerCollectionViewController.collectionView,auto:false, userModel: userEntity)
            }
            
            registerCollectionViewController.datasource = dataSource
            dataSource.delegate = registerCollectionViewController
            registerCollectionViewController.collectionView.dataSource = dataSource
            registerCollectionViewController.collectionView.delegate = registerCollectionViewController
            registerCollectionViewController.delegate = self
            registerCollectionViewController.setupRightBarItem()
            registerCollectionViewController.hideSearchBar()
        }

    }
    
    func setStepLabel(){
        stepLabel.text = "шаг \(currentStep+1) из \(stepAmaunt)"
        progressView.setProgress((Float(currentStep+1)/(Float(stepAmaunt))), animated: true)
    }
    
    

}
