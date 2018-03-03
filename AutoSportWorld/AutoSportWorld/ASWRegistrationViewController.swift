//
//  ASWRegistrationViewController.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 04.01.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import UIKit

class ASWRegistrationViewController: ASWViewController, ASWCollectionViewControllerDelegate, ASWRegisterAccountViewControllerDelegate {
    public struct RawUserParams{
        var login:String = ""
        var email:String = ""
        var password:String = ""
        
        var auto:Bool = false
        var moto:Bool = false
        
        //var autoWatch:Bool = false
        //var autoJoin:Bool = false
        //var motoWatch:Bool = false
        //var motoJoin:Bool = false
        
        var watch:Bool = false
        var join:Bool = false
        
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
//        if auto {
            //rawUser.autoWatch = watch
            //rawUser.autoJoin = join
//        }else{
            //rawUser.motoWatch = watch
            //rawUser.motoJoin = join
//        }
        //databaseManager.setUserActions(auto: auto, watch: watch, join: join)
        rawUser.watch = watch
        rawUser.join = join
        confirmButton.isEnabled = watch || join
    }
    
    
    func sportTypeSelected(moto: Bool, auto: Bool) {
//        userEntity.auto = auto
//        userEntity.moto = moto
        rawUser.moto = moto
        rawUser.auto = auto
    
        if (auto && moto){
            stepAmaunt = 6
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
    var changeSettings:Bool = false
    var changeSettingsSuccessMessage:String = ""
    
    private lazy var registerAccountViewController: ASWRegisterAccountViewController = {
        var viewController =  ASWViewControllersManager.RegistrationViewControllers.registerAccountViewController
        viewController.hideKeyboardWhenTappedAround()
        return viewController
    }()
    
    private lazy var registerCollectionViewController: ASWCollectionViewController = {
        var viewController = ASWViewControllersManager.RegistrationViewControllers.registerCollectionViewController
        viewController.hideKeyboardWhenTappedAround()
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
        if(changeSettings){
            add(asChildViewController: registerCollectionViewController)
            registerCollectionViewController.delegate = self
            setStep()
            hideStepAndProgressView()
        }else{
            add(asChildViewController: registerAccountViewController)
            
            
            rawUser.login = "testUser@gmail.com"//"123123"
            rawUser.email = "eded\(Int(Date().timeIntervalSince1970*1000))@dede.ru"
            rawUser.password = "123123"
            registerAccountViewController.name = rawUser.login
            registerAccountViewController.email = rawUser.email
            registerAccountViewController.password = rawUser.password
            
            registerAccountViewController.fillFormFromUserModel()
            
            stepLabel.textColor = UIColor.ASWColor.grey
            registerAccountViewController.delegate = self
            setupRightBarItem(avalible: false, title: "")
            setStepLabel()
            //setStep()
        }

//        userEntity.login = "123123"
//        userEntity.email = "edd@dede.ru"
//        userEntity.password = "123123"
//        registerAccountViewController.name = userEntity.login
//        registerAccountViewController.email = userEntity.email
//        registerAccountViewController.password = userEntity.password
//
//        rawUser.login = "Kirill"
//        rawUser.email = "leoniknik@mail.ru"
//        rawUser.password = "123456"
//        registerAccountViewController.name = rawUser.login
//        registerAccountViewController.email = rawUser.email
//        registerAccountViewController.password = rawUser.password
//
//        registerAccountViewController.fillFormFromUserModel()
//
//
//        registerAccountViewController.delegate = self
//        setupRightBarItem(avalible: false, title: "")
//        setStepLabel()
        
        ASWButtonManager.setupButton(button: confirmButton)
        setConfirmButtonText(false)
    }
    
    func setupUI() {
        //stepLabel.textColor = UIColor.ASWColor.grey
    }
    
    func setupRightBarItem(avalible: Bool, title: String) {
        rightBarItem.title = title
        self.navigationItem.rightBarButtonItem?.customView?.isHidden = !avalible
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        if(currentStep==0 || changeSettings){
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
        if(changeSettings){
            confirmButton.setTitle("Сохранить", for: .normal)
            confirmButton.setTitle("Сохранить", for: .disabled)
        }else{
            if final{
                confirmButton.setTitle("Завершить регистрацию", for: .normal)
                confirmButton.setTitle("Завершить регистрацию", for: .disabled)
            }else{
                confirmButton.setTitle("Далее", for: .normal)
                confirmButton.setTitle("Далее", for: .disabled)
            }
        }
        self.view.setNeedsDisplay()
    }
    
    
    func registerUserSucsess(){
        let alert = UIAlertController(title: "Регистрация", message: "Пользователь успешно создан", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: { [weak self] in print("fr")})
    }
    
    func checkEmail(){
        
        func sucsessCheck(parser:ASWValidateLoginParser){
            
            if(parser.valid){
                currentStep+=1
                setStep()
                setConfirmButtonText(false)
            }else{
                
                presentAlert("Регистрация", parser.totalErrorString)
            }
            registerAccountViewController.activityIndicator.stopAnimating()
        }
        
        func errorCheck(parser:ASWErrorParser){
            presentAlert(errorParser: parser)
            registerAccountViewController.activityIndicator.stopAnimating()
            confirmButton.isEnabled = true;
            //presentAlert(error:error){}
                
            
//            if(connectionError){
//                let alert = UIAlertController(title: "Нет сети", message: "Проверьте подключение к интернету и повторите попытку", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            }else{
//                let alert = UIAlertController(title: "Ошибка на сервере", message: "Повторите попытку или попробуйде позже", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            }
            
        }
        
        confirmButton.isEnabled = false;
        registerAccountViewController.activityIndicator.startAnimating()
        ASWNetworkManager.validateLogin(email: rawUser.email, password: rawUser.password, sucsessFunc: sucsessCheck, errorFunc: errorCheck)
    }
    
    
    @IBAction func performNextStep(_ sender: Any) {
        
        //new logic
        // 0-email
        // 1-regions
        // 2-sportType
        //     auto     moto    a+m   - выбор пользователя
        // 3-autoCat_motoCat_autoCat
        // 4-  Act     Act   motoCat
        // 5-                  Act
        
        if(changeSettings){
            confirmChangeSettings()
        }else{
            if(currentStep==0){
                // 0-email
                checkEmail()
            } else if(currentStep == 1){
                // 1-regions
                currentStep+=1
                setStep()
                setConfirmButtonText(false)
            } else if(currentStep == 2){
                // 2-sportType
                currentStep+=1
                setStep()
                setConfirmButtonText(false)
            }else if(currentStep == 3){
                // 3-autoCat_motoCat_autoCat
                currentStep+=1
                setStep()
                setConfirmButtonText(!(rawUser.auto&&rawUser.moto))
            }else if(currentStep == 4){
                // 4-  Act     Act   motoCat
                if ((rawUser.auto&&rawUser.moto)){
                    currentStep+=1
                    setStep()
                    setConfirmButtonText(true)
                }else{
                    completeRegistration()
                }
            }else if(currentStep == 5){
                completeRegistration()
            }
        }
        

    }
    
    
    
    func setStep(){
        setStepLabel()
        registerCollectionViewController.searchBar?.text = ""

        
        //new logic
        // 0-email
        // 1-regions
        // 2-sportType
        //     auto     moto    a+m   - выбор пользователя
        // 3-autoCat_motoCat_autoCat
        // 4-  Act     Act   motoCat
        // 5-                  Act

        
        
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
            setConfirmButtonText(false)
        }
        
        if(currentStep == 1){
            remove(asChildViewController: registerAccountViewController)
            add(asChildViewController: registerCollectionViewController)
            registerCollectionViewController.delegate = self
            
            //regions step
            var selectedRegions = rawUser.regions
            var dataSource: ASWRegionsCollectionViewDataSource! = regionsDataSource
            
            registerCollectionViewController.setupRegionsDatasource(datasource: dataSource, selectedRegions: selectedRegions)
            if dataSource.isEmptyDatasource(){
                registerCollectionViewController.getUpdate()
            }
            confirmButton.isEnabled = selectedRegions.count > 0
            setConfirmButtonText(false)
        }
        
        if (currentStep == 2){
            
            registerCollectionViewController.delegate = self
            registerCollectionViewController.setupSportTypeDatasource(auto: rawUser.auto, moto: rawUser.moto)
            confirmButton.isEnabled = rawUser.auto || rawUser.moto
            setConfirmButtonText(false)
        }
        
        if (currentStep == 3){
            // auto or moto types
            var selectedRaceTypes = rawUser.auto ? rawUser.autoCategories : rawUser.motoCategories
            
            //var dataSource = ASWRaceCategoryCollectionViewDataSource(collectionView: registerCollectionViewController.collectionView, selectedRaceCategory: selectedRaceTypes, auto: rawUser.auto)
            var dataSource = rawUser.auto ? autoCategoryDataSource : motoCategoryDataSource
            registerCollectionViewController.setupRaceCategoriesDatasource(datasource: dataSource, auto: dataSource.auto, selectedRaceCategories: selectedRaceTypes)
            if dataSource.isEmptyDatasource(){
                registerCollectionViewController.getUpdate()
            }
            confirmButton.isEnabled = selectedRaceTypes.count>0
            setConfirmButtonText(false)
        }
        
        if (currentStep == 4){
            if(rawUser.auto && rawUser.moto){
                
                var selectedRaceTypes =  rawUser.motoCategories

                var dataSource =  motoCategoryDataSource
                registerCollectionViewController.setupRaceCategoriesDatasource(datasource: dataSource, auto: dataSource.auto, selectedRaceCategories: selectedRaceTypes)
                if dataSource.isEmptyDatasource(){
                    registerCollectionViewController.getUpdate()
                }
                setConfirmButtonText(false)
                confirmButton.isEnabled = selectedRaceTypes.count>0
            }else {
                //registerCollectionViewController.setupActionTypeDatasource(auto: rawUser.auto, watch: rawUser.auto ? rawUser.autoWatch : rawUser.motoWatch, join: rawUser.auto ? rawUser.autoJoin : rawUser.motoJoin)
                 registerCollectionViewController.setupActionTypeDatasource(auto: rawUser.auto, watch: rawUser.watch, join: rawUser.join)
//                if(rawUser.auto){
//                    confirmButton.isEnabled = rawUser.autoJoin||rawUser.autoWatch
//                }else{
//                    confirmButton.isEnabled = rawUser.motoJoin||rawUser.motoWatch
//                }
                
                confirmButton.isEnabled = rawUser.join||rawUser.watch
                setConfirmButtonText(true)
            }
        }
        if (currentStep == 5){
            var dataSource:ASWActionTypeCollectionViewDataSource!
            
            if (currentStep == 5){

                //registerCollectionViewController.setupActionTypeDatasource(auto: true, watch: rawUser.autoWatch, join: rawUser.autoJoin)
                registerCollectionViewController.setupActionTypeDatasource(auto: true, watch: rawUser.watch, join: rawUser.join)
                //confirmButton.isEnabled = rawUser.autoJoin||rawUser.autoWatch
                confirmButton.isEnabled = rawUser.join||rawUser.watch
                setConfirmButtonText(true)
            }
        }

    }
    
    func setStepLabel(){
        stepLabel.text = "шаг \(currentStep+1) из \(stepAmaunt)"
        progressView.setProgress((Float(currentStep+1)/(Float(stepAmaunt))), animated: true)
    }
    
    
    func completeRegistration(){
        
        func sucsessSignup(parser:ASWSignupParser){
            if(parser.valid){
                var user = ASWDatabaseManager().createUserFrom(login: rawUser.login,
                                                               email: rawUser.email,
                                                               password: rawUser.password,
                                                               auto: rawUser.auto,
                                                               moto: rawUser.moto,
                                                               //autoWatch: rawUser.autoWatch,
                                                               //autoJoin: rawUser.autoJoin,
                                                               //motoWatch: rawUser.motoWatch,
                                                               //motoJoin: rawUser.motoJoin,
                                                                join:rawUser.join,
                                                                watch:rawUser.watch,
                    
                                                               regions: rawUser.regions,
                                                               autoCategories: rawUser.autoCategories,
                                                               motoCategories: rawUser.motoCategories)
                ASWDatabaseManager().setSessionInfo(refresh_token: parser.refresh_token, access_token: parser.access_token, expires_at: parser.expires_at)
                sendUserInfoToServer()
            }else{
                let alert = UIAlertController(title: "Регистрация", message: parser.email, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Error", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        func errorSignup(){
            confirmButton.isEnabled = registerCollectionViewController.datasource.rawSelectedItems.count>0
        }
        
        confirmButton.isEnabled = false
        ASWNetworkManager.signupUser(email: rawUser.email, password: rawUser.password, sucsessFunc: sucsessSignup, errorFunc: errorSignup)
    }
    
    func confirmChangeSettings(){
        
        func sucsessSend(){
            let alert = UIAlertController(title: "Успех", message: self.changeSettingsSuccessMessage, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: goBack))
            self.present(alert, animated: true, completion: nil)
        }
        
        func errorSend(parser:ASWErrorParser){
            presentAlert(errorParser: parser)
        }
    
        var user = ASWDatabaseManager().updateUserFrom(login: rawUser.login,
                                                       email: rawUser.email,
                                                       password: rawUser.password,
                                                       auto: rawUser.auto,
                                                       moto: rawUser.moto,
            join: rawUser.join,
            watch: rawUser.watch,
            regions: rawUser.regions,
            autoCategories: rawUser.autoCategories,
            motoCategories: rawUser.motoCategories)

        confirmButton.isEnabled = false
        ASWDatabaseManager().sendUserInfoToServer(completion: sucsessSend,error:errorSend)
    }
    
    func sendUserInfoToServer(){
        func sucsessSend(){
            goToMainStoryboard()
        }
        func errorSend(parser:ASWErrorParser){
            presentAlert(errorParser: parser)
        }
        
        ASWDatabaseManager().sendUserInfoToServer(completion: sucsessSend,error:errorSend)
    }
    
    
    func goToMainStoryboard(){
        let alert = UIAlertController(title: "Регистрация", message: "Регистрация завершена", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func configForChangeSettings(){
        self.changeSettings = true
        guard let user = ASWDatabaseManager().getUser() else {
            return
        }
        
        rawUser.auto = user.auto
        rawUser.moto = user.moto
        
        rawUser.watch = user.watch
        rawUser.join = user.join
        
        rawUser.autoCategories = ASWDatabaseManager().getCategoriesIds(auto: true) ?? []
        rawUser.motoCategories = ASWDatabaseManager().getCategoriesIds(auto: false) ?? []
        
        rawUser.regions = ASWDatabaseManager().getRegionsIds() ?? []
    }
    
    func configChangeRegions() {
        configForChangeSettings()
        self.currentStep = 1
        self.changeSettingsSuccessMessage = "Изменения успешно сохранены"
    }
    
    func configChangeRaceCategory(auto: Bool){
        configForChangeSettings()
        if auto {
            rawUser.auto = true;
        } else {
            rawUser.moto = true;
        }
        
        if rawUser.auto && rawUser.moto {
            self.currentStep = 4
        }else{
            self.currentStep = 3
        }
        self.changeSettingsSuccessMessage = "Изменения успешно сохранены"
    }
    
    func configChangeSportType(){
        configForChangeSettings()
        self.currentStep = 2
        self.changeSettingsSuccessMessage = "Изменения успешно сохранены"
    }
    
    func configChangeActionType(){
        configForChangeSettings()
        if rawUser.auto && rawUser.moto {
            self.currentStep = 5
        }else{
            self.currentStep = 4
        }
        self.changeSettingsSuccessMessage = "Изменения успешно сохранены"
    }
}
//old logic
// 0-email
// 1-sportType
// 2-regions
//     auto     moto    a+m
// 3-autoCat_motoCat_autoCat
// 4-autoAct_motoAct_motoCat
// 5-                autoAct
// 6-                motoAct


//func setStep(){
//    setStepLabel()
//    registerCollectionViewController.searchBar?.text = ""
//    //old logic
//    // 0-email
//    // 1-sportType
//    // 2-regions
//    //     auto     moto    a+m
//    // 3-autoCat_motoCat_autoCat
//    // 4-autoAct_motoAct_motoCat
//    // 5-                autoAct
//    // 6-                motoAct
//
//    //new logic
//    // 0-email
//    // 1-regions
//    // 2-sportType
//    //     auto     moto    a+m   - выбор пользователя
//    // 3-autoCat_motoCat_autoCat
//    // 4-  Act     Act   motoCat
//    // 5-                  Act
//
//
//
//    if(currentStep == 0){
//        // email step
//
//        remove(asChildViewController: registerCollectionViewController)
//        add(asChildViewController: registerAccountViewController)
//        registerAccountViewController.name = rawUser.login
//        registerAccountViewController.email = rawUser.email
//        registerAccountViewController.password = rawUser.password
//        registerAccountViewController.fillFormFromUserModel()
//        registerAccountViewController.delegate = self
//        confirmButton.isEnabled = registerAccountViewController.isFormValid()
//        setupRightBarItem(avalible: false, title: "")
//    }
//
//    if(currentStep == 1){
//        remove(asChildViewController: registerAccountViewController)
//        add(asChildViewController: registerCollectionViewController)
//        registerCollectionViewController.delegate = self
//        registerCollectionViewController.setupSportTypeDatasource(auto: rawUser.auto, moto: rawUser.moto)
//        confirmButton.isEnabled = rawUser.auto || rawUser.moto
//    }
//
//    if (currentStep == 2){
//        //regions step
//        var selectedRegions = rawUser.regions
//        var dataSource: ASWRegionsCollectionViewDataSource! = regionsDataSource
//
//        registerCollectionViewController.setupRegionsDatasource(datasource: dataSource, selectedRegions: selectedRegions)
//        if dataSource.isEmptyDatasource(){
//            registerCollectionViewController.getUpdate()
//        }
//        confirmButton.isEnabled = selectedRegions.count>0
//    }
//
//    if (currentStep == 3){
//        // auto or moto types
//        var selectedRaceTypes = rawUser.auto ? rawUser.autoCategories : rawUser.motoCategories
//
//        //var dataSource = ASWRaceCategoryCollectionViewDataSource(collectionView: registerCollectionViewController.collectionView, selectedRaceCategory: selectedRaceTypes, auto: rawUser.auto)
//        var dataSource = rawUser.auto ? autoCategoryDataSource : motoCategoryDataSource
//        registerCollectionViewController.setupRaceCategoriesDatasource(datasource: dataSource, auto: dataSource.auto, selectedRaceCategories: selectedRaceTypes)
//        if dataSource.isEmptyDatasource(){
//            registerCollectionViewController.getUpdate()
//        }
//        confirmButton.isEnabled = selectedRaceTypes.count>0
//
//    }
//
//    if (currentStep == 4){
//        if(rawUser.auto && rawUser.moto){
//
//            var selectedRaceTypes =  rawUser.motoCategories
//
//            var dataSource =  motoCategoryDataSource
//            registerCollectionViewController.setupRaceCategoriesDatasource(datasource: dataSource, auto: dataSource.auto, selectedRaceCategories: selectedRaceTypes)
//            if dataSource.isEmptyDatasource(){
//                registerCollectionViewController.getUpdate()
//            }
//
//            confirmButton.isEnabled = selectedRaceTypes.count>0
//        }else {
//            registerCollectionViewController.setupActionTypeDatasource(auto: rawUser.auto, watch: rawUser.auto ? rawUser.autoWatch : rawUser.motoWatch, join: rawUser.auto ? rawUser.autoJoin : rawUser.motoJoin)
//            if(rawUser.auto){
//                confirmButton.isEnabled = rawUser.autoJoin||rawUser.autoWatch
//            }else{
//                confirmButton.isEnabled = rawUser.motoJoin||rawUser.motoWatch
//            }
//        }
//    }
//    if (currentStep == 5 || currentStep == 6){
//        var dataSource:ASWActionTypeCollectionViewDataSource!
//
//        if (currentStep == 5){
//
//            registerCollectionViewController.setupActionTypeDatasource(auto: true, watch: rawUser.autoWatch, join: rawUser.autoJoin)
//            confirmButton.isEnabled = rawUser.autoJoin||rawUser.autoWatch
//        }else{
//            registerCollectionViewController.actionTypeSelected(auto: false, watch: rawUser.motoWatch, join: rawUser.motoJoin)
//            confirmButton.isEnabled = rawUser.motoJoin||rawUser.motoWatch
//        }
//
//    }
//
//}






//        if(currentStep==0){
//            checkEmail()
//        } else if(currentStep == 1){
//            currentStep+=1
//            setStep()
//            setConfirmButtonText(false)
//        } else if(currentStep == 2){
//            currentStep+=1
//            setStep()
//            setConfirmButtonText(false)
//        }else if(currentStep == 3){
//            currentStep+=1
//            setStep()
//            setConfirmButtonText(!(rawUser.auto&&rawUser.moto))
//        }else if(currentStep == 4){
//            if ((rawUser.auto&&rawUser.moto)){
//                currentStep+=1
//                setStep()
//                setConfirmButtonText(false)
//            }else{
//                completeRegistration()
//            }
//        }else if(currentStep == 5){
//            currentStep+=1
//            setStep()
//               setConfirmButtonText(true)
//        }else if(currentStep == 6){
//            completeRegistration()
//        }
//

