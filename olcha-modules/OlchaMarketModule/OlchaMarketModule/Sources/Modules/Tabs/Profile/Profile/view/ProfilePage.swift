//
//  ProfilePage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 06/09/22.
//

import UIKit
import Combine
import OlchaUI
import OlchaAuth
import OlchaUtils
import OlchaBalance
import OlchaVerification

class ProfilePage: BaseViewController {
    
    weak var coordinator: ProfileCoordinatorProtocol?
    
    var selectItem: OlchaBalanceRoom.Section = .balance
    
    lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: UserRoom.self)
        table.registerClass(forCell: OlchaBalanceRoom.self)
        table.registerClass(forCell: ProfileMenuRoom.self)
        table.registerClass(forCell: ReferalRoom.self)
        table.registerClass(forCell: EnterLoginRoom.self)
        table.configure()
        return table
    }()
    
    var userSections: [Section] {
        var sections = [Section]()
        
        sections.append(.user)
        sections.append(.balans)
        sections.append(contentsOf: additonalSections)
        sections.append(contentsOf: [
            .personalData,
            .oneIdGuide,
            .myOrders,
            .searchOrder,
            .returnOrder,
            .location,
            .favourites,
            .compare,
            .myReviews,
            .myQuestions,
            .notifications,
            .settings,
            .logout,
            .delete,
            .referal
        ])
        
        return sections
    }
    
    var guestSections: [Section] {
        var sections = [Section]()
        sections.append(.login)
        sections.append(contentsOf: additonalSections)
        
        sections.append(contentsOf: [
            .compare,
            .searchOrder,
            .favourites,
            .settings,
        ])
        return sections
    }
    
    var additonalSections: [Section] = []
    
    var actualSections: [Section] {
        AuthGlobalDefaults.isUser() ? userSections : guestSections
    }
    
    private var bag = Set<AnyCancellable>()
    
    let pushFillBalance = PassthroughSubject<Bool, Never>()
    let balanceFilledObserver = PassthroughSubject<Void, Never>()
    
    let viewModel = ProfilePageViewModel()
    let verificationViewModel: VerificationViewModel
    let balanceViewModel: BalanceViewModel
    
    var input: Input
    var shouldOpenPersonalDataAfterStepLoad = false
    
    init(
        input: Input = .init(),
        verificationViewModel: VerificationViewModel,
        balanceViewModel: BalanceViewModel
    ) {
        self.input = input
        self.verificationViewModel = verificationViewModel
        self.balanceViewModel = balanceViewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        super.setupViews()
        container.addSubview(table)
        table.addSubview(refreshControl)
    }
    
    override func autolayout() {
        super.autolayout()
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        super.configureViews()
        navigation.configure(style: .center)
        languageUpdated()
    }
    
    override func languageUpdated() {
        navigation.setTitle("profile".localized())
        table.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        initialRequest()
    }
    
    override func initialRequest() {
        viewModel.loadUserData(withIndicator: true)
        viewModel.loadBonus(withIndicator: true)
        balanceViewModel.loadBalance()
        verificationViewModel.loadStep()
        OlchaVerificationDIContainer.shared.authCreditViewModel().verifyCredit()
    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        viewModel
            .$user
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                input.user = data
                table.reloadData()
                if AuthGlobalDefaults.isUser(),
                   AuthGlobalDefaults.notification.fcm_token != "",
                   data != nil {
                    self.viewModel.loadUserSettings()
                    self.viewModel.registerNotification()
                }
            }.store(in: &bag)
        
        let userPublishers = Publishers.CombineLatest(verificationViewModel.$step, viewModel.userIndicator)
        userPublishers
            .sink(receiveValue: { [weak self] (step, userIndicator) in
                guard let self else { return }
                let isLoading = step == .loading || userIndicator
                input.verification = step.value
                input.userSkeleton.isAnimating = isLoading
                table.reloadData()

                guard shouldOpenPersonalDataAfterStepLoad else { return }
                switch step {
                case .success(let verificationData):
                    shouldOpenPersonalDataAfterStepLoad = false
                    openPersonalData(with: verificationData)
                case .failure(let error):
                    shouldOpenPersonalDataAfterStepLoad = false
                    showError(text: error?.message)
                default:
                    break
                }
            })
            .store(in: &bag)
        
        let cardPublishers = Publishers.CombineLatest3(viewModel.userIndicator, balanceViewModel.$balance, viewModel.bonusIndicator)
        cardPublishers
            .sink(receiveValue: { [weak self] (userIndicator, balance, bonusIndicator) in
                guard let self else { return }
                let isLoading = userIndicator || balance == .loading || bonusIndicator
                input.balance = balance.value?.platformBalance
                input.cardSkeleton.isAnimating = isLoading
                table.reloadData()
            })
            .store(in: &bag)
        
        pushFillBalance
            .sink { [weak self] canOpen in
                guard let self = self else { return }
                self.coordinator?.pushFillBalance(balanceFilled: balanceFilledObserver)
            }.store(in: &bag)
        
        balanceFilledObserver
            .sink { [weak self] isFilled in
                guard let self else { return }
                balanceViewModel.loadBalance()
            }.store(in: &bag)
        
        viewModel
            .$bonus
            .sink { [weak self] data in
                guard let self = self,
                      let data = data else { return }
                input.bonus = data
                table.reloadData()
            }.store(in: &bag)
        
        viewModel
            .$settings
            .sink { [weak self] sections in
                guard let self = self else { return }
                self.additonalSections = sections
                self.table.reloadData()
            }.store(in: &bag)
        
        AuthGlobalDefaults.userTypeChanged.sink { [weak self] isChanged in
            guard let self = self, isChanged else { return }
            table.reloadData()
        }.store(in: &bag)
        
        CartViewModel
            .shared
            .$favouritesCount
            .sink { [weak self] count in
                guard let self = self else { return }
                table.reloadData()
            }.store(in: &bag)
    }
    
    public override func refreshList(_ sender: AnyObject) {
        input.reset()
        initialRequest()
        refreshControl.endRefreshing()
    }

}
