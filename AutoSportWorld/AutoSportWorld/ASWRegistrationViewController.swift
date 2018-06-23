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

        var watch:Bool = false
        var join:Bool = false
        
        var regions:[Int] = [Int]()
        var autoCategories:[Int] = [Int]()
        var motoCategories:[Int] = [Int]()
        
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
    var configAllFIlters:Bool = false
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

    func updateUserLoginInfo(valid: Bool, login: String, email: String, password: String) {
        confirmButton.isEnabled = valid
        rawUser.login = login
        rawUser.email = email
        rawUser.password = password
    }

    func updateSelectedRaceTypes(auto:Bool,raceTypeIDs: [Int]) {
        if auto{
            rawUser.autoCategories = raceTypeIDs
        }else{
            rawUser.motoCategories = raceTypeIDs
        }
        confirmButton.isEnabled = raceTypeIDs.count>0
    }


    func updateSelectedRegions(regionsIDs: [Int]) {
        rawUser.regions = regionsIDs
        confirmButton.isEnabled = regionsIDs.count>0
    }

    func actionTypeSelected(auto: Bool, watch: Bool, join: Bool) {
        rawUser.watch = watch
        rawUser.join = join
        confirmButton.isEnabled = watch || join
    }


    func sportTypeSelected(moto: Bool, auto: Bool) {
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
    
    private func add(asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBlackOpaqueNavBar()
        setupLeftBarItem()
        setupUI()
        if changeSettings {
            add(asChildViewController: registerCollectionViewController)
            registerCollectionViewController.delegate = self
            setStep()
            hideStepAndProgressView()
        }else if configAllFIlters {
            self.currentStep = 1
            add(asChildViewController: registerCollectionViewController)
            registerCollectionViewController.delegate = self
            setStep()
            setStepLabel()
        }else {
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
        }
        
        if (rawUser.auto && rawUser.moto){
            stepAmaunt = 6
        }else if (rawUser.auto || rawUser.moto){
            stepAmaunt = 5
        }
        
        ASWButtonManager.setupButton(button: confirmButton)
        setConfirmButtonText(false)
    }
    
    func setupUI() {

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStep()
    }
    
    func setupLeftBarItem() {
        let backButton: UIBarButtonItem
        
        backButton = UIBarButtonItem(image: UIImage.backward, style: .done, target: self, action: #selector(goBack))
        backButton.tintColor = UIColor.white
       
        self.navigationItem.setLeftBarButton(backButton, animated: false)
    }
    
    func setupRightBarItem(avalible: Bool, title: String) {
        rightBarItem.title = title
        self.navigationItem.rightBarButtonItem?.customView?.isHidden = !avalible
    }

    @IBAction func goBack(_ sender: Any) {
        if(currentStep==0 || changeSettings || configAllFIlters){
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
        }else if configAllFIlters {
            if final{
                confirmButton.setTitle("Сохранить", for: .normal)
                confirmButton.setTitle("Сохранить", for: .disabled)
            }else{
                confirmButton.setTitle("Далее", for: .normal)
                confirmButton.setTitle("Далее", for: .disabled)
            }
        }else {
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
            ModalLoadingIndicator.hide()
        }
        
        func errorCheck(parser:ASWErrorParser){
            presentAlert(errorParser: parser)
            ModalLoadingIndicator.hide()
            confirmButton.isEnabled = true;
        }
        
        confirmButton.isEnabled = false;
        ModalLoadingIndicator.show()
        ASWNetworkManager.validateLogin(email: rawUser.email, password: rawUser.password,name:rawUser.login, sucsessFunc: sucsessCheck, errorFunc: errorCheck)
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
            let selectedRegions = rawUser.regions
            let dataSource: ASWRegionsCollectionViewDataSource! = regionsDataSource
            
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
            let selectedRaceTypes = rawUser.auto ? rawUser.autoCategories : rawUser.motoCategories
            let dataSource = rawUser.auto ? autoCategoryDataSource : motoCategoryDataSource
            registerCollectionViewController.setupRaceCategoriesDatasource(datasource: dataSource, auto: dataSource.auto, selectedRaceCategories: selectedRaceTypes)
            if dataSource.isEmptyDatasource(){
                registerCollectionViewController.getUpdate()
            }
            confirmButton.isEnabled = selectedRaceTypes.count>0
            setConfirmButtonText(false)
        }
        
        if (currentStep == 4){
            if(rawUser.auto && rawUser.moto){
                let selectedRaceTypes =  rawUser.motoCategories
                let dataSource =  motoCategoryDataSource
                registerCollectionViewController.setupRaceCategoriesDatasource(datasource: dataSource, auto: dataSource.auto, selectedRaceCategories: selectedRaceTypes)
                if dataSource.isEmptyDatasource(){
                    registerCollectionViewController.getUpdate()
                }
                setConfirmButtonText(false)
                confirmButton.isEnabled = selectedRaceTypes.count>0
            }else {
                registerCollectionViewController.setupActionTypeDatasource(auto: rawUser.auto, watch: rawUser.watch, join: rawUser.join)
                confirmButton.isEnabled = rawUser.join||rawUser.watch
                setConfirmButtonText(true)
            }
        }
        if (currentStep == 5){
            registerCollectionViewController.setupActionTypeDatasource(auto: true, watch: rawUser.watch, join: rawUser.join)
            confirmButton.isEnabled = rawUser.join||rawUser.watch
            setConfirmButtonText(true)
        }
    }
    
    func setStepLabel(){
        if(configAllFIlters){
            stepLabel.text = "шаг \(currentStep) из \(stepAmaunt-1)"
        }else{
            stepLabel.text = "шаг \(currentStep+1) из \(stepAmaunt)"
        }
        
        progressView.setProgress((Float(currentStep+1)/(Float(stepAmaunt))), animated: true)
    }
    
    
    func completeRegistration(){
        if configAllFIlters{
            confirmChangeSettings()
            return
        }
        
        func sucsessSignup(parser:ASWSignupParser){
            if(parser.valid){
                _ = ASWDatabaseManager().createUserFrom(login: rawUser.login,
                                                               email: rawUser.email,
                                                               password: rawUser.password,
                                                               auto: rawUser.auto,
                                                               moto: rawUser.moto,
                                                               join:rawUser.join,
                                                               watch:rawUser.watch,
                                                               regions: rawUser.regions,
                                                               autoCategories: rawUser.autoCategories,
                                                               motoCategories: rawUser.motoCategories)
                if let sessionInfoParser = parser.sessionInfoParser{
                    ASWDatabaseManager().setSessionInfo(refresh_token: sessionInfoParser.refresh_token, access_token: sessionInfoParser.access_token, expires_at: sessionInfoParser.expires_at)}
                
                sendUserInfoToServer()
            }else{
                presentOKAlert("Ошибка", parser.errorString)
            }
        }
        
        func errorSignup(parser:ASWSignupErrorParser){
            confirmButton.isEnabled = registerCollectionViewController.datasource.rawSelectedItems.count>0
            presentAlert(errorParser: parser)
        }
        
        confirmButton.isEnabled = false
        ASWNetworkManager.signupUser(email: rawUser.email, password: rawUser.password, name:rawUser.login, sucsessFunc: sucsessSignup, errorFunc: errorSignup)
    }
    
    func confirmChangeSettings(){
        
        func sucsessSend(){
            ModalLoadingIndicator.hide()
            presentOKAlert("Успех", self.changeSettingsSuccessMessage){
                if self.configAllFIlters {
                    DispatchQueue.main.async { [weak self] in
                        self?.openMainStoryboard()
                    }
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
        }
        
        func errorSend(parser:ASWErrorParser){
            ModalLoadingIndicator.hide()
            presentAlert(errorParser: parser){
                func sucsessFunc(parser:ASWUserInfoGetParser){
                    ASWDatabaseManager().setUserInfo(parser:parser)
                    ModalLoadingIndicator.hide()
                }
                
                func errorFunc(parser:ASWErrorParser){
                   ModalLoadingIndicator.hide()
                }
                ASWNetworkManager.getUserInfo(sucsessFunc: sucsessFunc, errorFunc: errorFunc)
            }
            
        }
    
        _ = ASWDatabaseManager().updateUserFrom(login: rawUser.login,
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
        ModalLoadingIndicator.show()
        ASWDatabaseManager().sendUserInfoToServer(completion: sucsessSend,error:errorSend)
    }
    
    func sendUserInfoToServer(){
        func sucsessSend(){
            DispatchQueue.main.async { [weak self] in
                self?.openMainStoryboard()
            }
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
        //new logic
        // 0-email
        // 1-regions
        // 2-sportType
        //     auto     moto    a+m   - выбор пользователя
        // 3-autoCat_motoCat_autoCat
        // 4-  Act     Act   motoCat
        // 5-                  Act
        configForChangeSettings()
        let user = ASWDatabaseManager().getUser()
        
        rawUser.auto = auto || user?.auto ?? false;
        
        rawUser.moto = !auto || user?.moto ?? false;
        
        
        if rawUser.auto && rawUser.moto {
            if(auto){
                self.currentStep = 3
            }else{
                self.currentStep = 4
            }
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
    
    func configForAllFilters(){
        self.configAllFIlters = true
        
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
        
        self.currentStep = 1;
        
        self.changeSettingsSuccessMessage = "Изменения успешно сохранены"
    }
}
