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
    
    struct RawUserParams{
        var login:String = ""
        var email:String = ""
        var password:String = ""
        
        var auto:Bool = false
        var moto:Bool = false
        
        var autoWatch:Bool = false
        var autoJoin:Bool = false
        var motoWatch:Bool = false
        var motoJoin:Bool = false
        
        var regions:[Int] = [Int]()
        var autoCategories:[Int] = [Int]()
        var motoCategories:[Int] = [Int]()
        
    }
    
    func updateUserLoginInfo(valid: Bool, login: String, email: String, password: String) {
        confirmButton.isEnabled = valid
        rawUser.login = login
        rawUser.email = email
        rawUser.password = password
//        userEntity.login = login
//        userEntity.email = email
//        userEntity.password = password
    }
    
    func updateSelectedRaceTypes(auto:Bool,raceTypeIDs: [Int]) {
        if auto{
            rawUser.autoCategories = raceTypeIDs
        }else{
            rawUser.motoCategories = raceTypeIDs
        }
        //databaseManager.setUserRaceCategories(categoriesIDs: raceTypeIDs, auto: auto)
        confirmButton.isEnabled = raceTypeIDs.count>0
    }
    
    
    func updateSelectedRegions(regionsIDs: [Int]) {
        rawUser.regions = regionsIDs
        //databaseManager.setUserRegions(regionIDs: regionsIDs)
        confirmButton.isEnabled = regionsIDs.count>0
    }
    
    func actionTypeSelected(auto: Bool, watch: Bool, join: Bool) {
        if auto {
            rawUser.autoWatch = watch
            rawUser.autoJoin = join
        }else{
            rawUser.motoWatch = watch
            rawUser.motoJoin = join
        }
        //databaseManager.setUserActions(auto: auto, watch: watch, join: join)
        confirmButton.isEnabled = watch || join
    }
    
    
    func sportTypeSelected(moto: Bool, auto: Bool) {
//        userEntity.auto = auto
//        userEntity.moto = moto
        rawUser.moto = moto
        rawUser.auto = auto
    
        if (auto && moto){
            stepAmaunt = 7
        }else if (auto || moto){
            stepAmaunt = 5
        }
        confirmButton.isEnabled = auto||moto
        setStepLabel()
    }
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var stepAndProgressView: UIView!
    
    
    @IBOutlet weak var rightBarItem: UIBarButtonItem!
    
    @IBOutlet weak var containerView: UIView!
    
    var currentStep:Int = 0
    var stepAmaunt:Int = 5
    var databaseManager = ASWDatabaseManager()
    var rawUser = RawUserParams()
    
    
    
    
    

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
    
    var _regionsDataSource: ASWRegionsCollectionViewDataSource? = nil
    var regionsDataSource: ASWRegionsCollectionViewDataSource{
        get{
            if _regionsDataSource == nil{
                _regionsDataSource = ASWRegionsCollectionViewDataSource(collectionView: registerCollectionViewController.collectionView, selectedRegions: rawUser.regions)
            }else{
                _regionsDataSource?.collectionView = registerCollectionViewController.collectionView
                _regionsDataSource?.setSelectedRegions(regionsIDs: rawUser.regions)
            }
            return _regionsDataSource!
        }
    }
    
    var _autoCategoryDataSource: ASWRaceCategoryCollectionViewDataSource? = nil
    var autoCategoryDataSource: ASWRaceCategoryCollectionViewDataSource{
        get{
            if _autoCategoryDataSource == nil{
                _autoCategoryDataSource = ASWRaceCategoryCollectionViewDataSource(collectionView: registerCollectionViewController.collectionView, selectedRaceCategory: rawUser.autoCategories, auto: true)
            }else{
                _autoCategoryDataSource?.collectionView = registerCollectionViewController.collectionView
                _autoCategoryDataSource?.setSelectedCategories(categoryIDs: rawUser.autoCategories)
            }
            return _autoCategoryDataSource!
        }
    }
    
    var _motoCategoryDataSource: ASWRaceCategoryCollectionViewDataSource? = nil
    var motoCategoryDataSource: ASWRaceCategoryCollectionViewDataSource{
        get{
            if _motoCategoryDataSource == nil{
                _motoCategoryDataSource = ASWRaceCategoryCollectionViewDataSource(collectionView: registerCollectionViewController.collectionView, selectedRaceCategory: rawUser.motoCategories, auto: false)
            }else{
                _motoCategoryDataSource?.collectionView = registerCollectionViewController.collectionView
                _motoCategoryDataSource?.setSelectedCategories(categoryIDs: rawUser.autoCategories)
            }
            return _motoCategoryDataSource!
        }
    }
    
    
    
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
        
        //testcode

//        userEntity.login = "123123"
//        userEntity.email = "edd@dede.ru"
//        userEntity.password = "123123"
//        registerAccountViewController.name = userEntity.login
//        registerAccountViewController.email = userEntity.email
//        registerAccountViewController.password = userEntity.password
        
        rawUser.login = "123123"
        rawUser.email = "edd@dede.ru"
        rawUser.password = "123123"
        registerAccountViewController.name = rawUser.login
        registerAccountViewController.email = rawUser.email
        registerAccountViewController.password = rawUser.password
        
        registerAccountViewController.fillFormFromUserModel()
        
        
        registerAccountViewController.delegate = self
        setupRightBarItem(avalible: false, title: "")
        setStepLabel()
        ASWButtonManager.setupButton(button: confirmButton)
        //confirmButton.isEnabled = false
        
        
    }
    
    func setupUI() {
        
        confirmButton.backgroundColor = UIColor.ASWColor.black
        stepLabel.textColor = UIColor.ASWColor.grey
        //progressView.progressTintColor = UIColor.ASWColor.black
        
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
    
    func setConfirmButtonText(_ final:Bool){
//        DispatchQueue.main.async {
//            [weak self] in
//            if final{
//                self?.confirmButton.setTitle("Завершить регистрацию", for: .normal)
//                self?.confirmButton.setTitle("Завершить регистрацию", for: .disabled)
//            }else{
//                self?.confirmButton.setTitle("Далее", for: .normal)
//                self?.confirmButton.setTitle("Далее", for: .disabled)
//            }
//            self?.view.setNeedsDisplay()
//        }
        if final{
            confirmButton.setTitle("Завершить регистрацию", for: .normal)
            confirmButton.setTitle("Завершить регистрацию", for: .disabled)
        }else{
            confirmButton.setTitle("Далее", for: .normal)
            confirmButton.setTitle("Далее", for: .disabled)
        }
        self.view.setNeedsDisplay()
    }
    
    func login(){
        
        func loginSucsess(){
            
        }
        
        func loginError(){
            
        }
        
    }
    
    func registerUser(){
        
        func registerUserSucsess(){
            
        }
        
        func registerUserError(){
            
        }
        //userEntity = ASWDatabaseManager().createUser(login: userEntity.login, password: userEntity.password)
        //registerUserSucsess()
    }

    func registerUserSucsess(){
        let alert = UIAlertController(title: "Регистрация", message: "Пользователь успешно создан", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        currentStep+=1
        setStep()
        setConfirmButtonText(false)
    }
    
    func checkEmail(){
        
        func sucsessCheck(){
            currentStep+=1
            setStep()
            setConfirmButtonText(false)
        }
        
        func errorCheck(){
            let alert = UIAlertController(title: "Регистрация", message: "Такой email уже зарегистрирован", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        ASWNetworkManager.checkEmail(email: rawUser.email, sucsessFunc: sucsessCheck, errorFunc: errorCheck)
    }
    
    
    @IBAction func performNextStep(_ sender: Any) {
        if(currentStep==0){
            checkEmail()
        } else if(currentStep == 1){
            currentStep+=1
            setStep()
            setConfirmButtonText(false)
        } else if(currentStep == 2){
            currentStep+=1
            setStep()
            setConfirmButtonText(false)
        }else if(currentStep == 3){
            currentStep+=1
            setStep()
            setConfirmButtonText(!(rawUser.auto&&rawUser.moto))
        }else if(currentStep == 4){
            if ((rawUser.auto&&rawUser.moto)){
                currentStep+=1
                setStep()
                setConfirmButtonText(false)
            }else{
                completeRegistration()
            }
        }else if(currentStep == 5){
            currentStep+=1
            setStep()
               setConfirmButtonText(true)
        }else if(currentStep == 6){
            completeRegistration()
        }
        
    }
    
    func completeRegistration(){
        
        let alert = UIAlertController(title: "Регистрация", message: "Регистрация завершена", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func setStep(){
        setStepLabel()
        registerCollectionViewController.searchBar?.text = ""
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
            registerAccountViewController.name = rawUser.login
            registerAccountViewController.email = rawUser.email
            registerAccountViewController.password = rawUser.password
            registerAccountViewController.fillFormFromUserModel()
            registerAccountViewController.delegate = self
            confirmButton.isEnabled = registerAccountViewController.isFormValid()
            setupRightBarItem(avalible: false, title: "")
        }
        
        if(currentStep == 1){
            remove(asChildViewController: registerAccountViewController)
            add(asChildViewController: registerCollectionViewController)
            
            var dataSource = ASWSportTypeCollectionViewDataSource(collectionView: registerCollectionViewController.collectionView, auto: rawUser.auto,moto:rawUser.moto)
            
            registerCollectionViewController.datasource = dataSource
            dataSource.delegate = registerCollectionViewController
            registerCollectionViewController.collectionView.dataSource = dataSource
            registerCollectionViewController.collectionView.delegate = registerCollectionViewController
            registerCollectionViewController.delegate = self
            registerCollectionViewController.setupRightBarItem()
            registerCollectionViewController.hideSearchBar()
            confirmButton.isEnabled = rawUser.auto || rawUser.moto
        }
        
        if (currentStep == 2){
            //regions step
            var selectedRegions = rawUser.regions
            var dataSource: ASWRegionsCollectionViewDataSource!
            //var dataSource = ASWRegionsCollectionViewDataSource(collectionView: registerCollectionViewController.collectionView, selectedRegions: selectedRegions)
            dataSource = regionsDataSource
            
            registerCollectionViewController.datasource = dataSource
            dataSource.delegate = registerCollectionViewController
            registerCollectionViewController.collectionView.dataSource = dataSource
            registerCollectionViewController.collectionView.delegate = registerCollectionViewController
            registerCollectionViewController.searchBar.delegate = dataSource
            registerCollectionViewController.delegate = self
            registerCollectionViewController.setupRightBarItem()
            registerCollectionViewController.showSearchBar()
            confirmButton.isEnabled = selectedRegions.count>0
        }
        
        if (currentStep == 3){
            // auto or moto types
            var selectedRaceTypes = rawUser.auto ? rawUser.autoCategories : rawUser.motoCategories
            
            //var dataSource = ASWRaceCategoryCollectionViewDataSource(collectionView: registerCollectionViewController.collectionView, selectedRaceCategory: selectedRaceTypes, auto: rawUser.auto)
            var dataSource = rawUser.auto ? autoCategoryDataSource : motoCategoryDataSource
            registerCollectionViewController.datasource = dataSource
            dataSource.delegate = registerCollectionViewController
            registerCollectionViewController.collectionView.dataSource = dataSource
            registerCollectionViewController.collectionView.delegate = registerCollectionViewController
            registerCollectionViewController.searchBar.delegate = dataSource
            registerCollectionViewController.delegate = self
            registerCollectionViewController.setupRightBarItem()
            registerCollectionViewController.showSearchBar()
            
            //if (userEntity.auto){
                confirmButton.isEnabled = selectedRaceTypes.count>0
            //}else{
            //    confirmButton.isEnabled = selectedMotoRaceTypes.count>0
            //}
        }
        
        if (currentStep == 4){
            // auto action or moto action or moto type

            if(rawUser.auto && rawUser.moto){
                
                var selectedRaceTypes = rawUser.auto ? rawUser.autoCategories : rawUser.motoCategories
                
                //var dataSource = ASWRaceCategoryCollectionViewDataSource(collectionView: registerCollectionViewController.collectionView, selectedRaceCategory: selectedRaceTypes, auto: false)
                var dataSource = rawUser.auto ? autoCategoryDataSource : motoCategoryDataSource
                registerCollectionViewController.datasource = dataSource
                dataSource.delegate = registerCollectionViewController
                registerCollectionViewController.collectionView.dataSource = dataSource
                registerCollectionViewController.collectionView.delegate = registerCollectionViewController
                registerCollectionViewController.searchBar.delegate = dataSource
                registerCollectionViewController.delegate = self
                registerCollectionViewController.setupRightBarItem()
                registerCollectionViewController.showSearchBar()
                confirmButton.isEnabled = selectedRaceTypes.count>0
            }else {
                var dataSource = ASWActionTypeCollectionViewDataSource(collectionView: registerCollectionViewController.collectionView,auto:rawUser.auto, join: rawUser.auto ? rawUser.autoJoin : rawUser.motoJoin,watch: rawUser.auto ? rawUser.autoWatch : rawUser.motoWatch)
                
                registerCollectionViewController.datasource = dataSource
                dataSource.delegate = registerCollectionViewController
                registerCollectionViewController.collectionView.dataSource = dataSource
                registerCollectionViewController.collectionView.delegate = registerCollectionViewController
                registerCollectionViewController.delegate = self
                registerCollectionViewController.setupRightBarItem()
                registerCollectionViewController.hideSearchBar()
                if(rawUser.auto){
                    confirmButton.isEnabled = rawUser.autoJoin||rawUser.autoWatch
                }else{
                    confirmButton.isEnabled = rawUser.motoJoin||rawUser.motoWatch
                }
            }
        }
        if (currentStep == 5 || currentStep == 6){
            var dataSource:ASWActionTypeCollectionViewDataSource!
            
            if (currentStep == 5){
                dataSource = ASWActionTypeCollectionViewDataSource(collectionView: registerCollectionViewController.collectionView,auto:true, join: rawUser.autoJoin,watch: rawUser.autoWatch)
                confirmButton.isEnabled = rawUser.autoJoin||rawUser.autoWatch
            }else{
                dataSource = ASWActionTypeCollectionViewDataSource(collectionView: registerCollectionViewController.collectionView,auto:true, join: rawUser.motoJoin,watch: rawUser.motoWatch)
                confirmButton.isEnabled = rawUser.motoJoin||rawUser.motoWatch
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
