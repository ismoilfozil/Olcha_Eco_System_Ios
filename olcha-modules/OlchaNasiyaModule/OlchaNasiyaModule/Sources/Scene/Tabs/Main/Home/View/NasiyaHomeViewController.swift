//
//  NasiyaHomeViewController.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import UIKit
import Combine
import OlchaUI
import OlchaBilling
import OlchaUtils
import OlchaAuth
import OlchaCommon
import OlchaVerification

public class NasiyaHomeViewController: BaseViewController<NasiyaNavigationBar> {

    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: ResetLimitRoom.self)
        table.registerClass(forCell: NasiyaBannerRoom.self)
        table.registerClass(forCell: EmptyNextPaymentRoom.self)
        table.registerClass(forCell: InstallmentRoom.self)
        table.registerClass(forCell: AmountBannersRoom.self)
        table.configure()
        return table
    }()
    
    private lazy var verifyView: VerifyView = {
        let view = VerifyView()
        view.isHidden = isVerified
        return view
    }()
    
    public weak var coordinator: NasiyaHomeCoordinatorProtocol?
    
    public var sections: [Section] {
        var sections: [Section] = []
        sections.append(contentsOf: [
            .balance,
            input.limit?.request_status?.getStatus() == .approved ? nil : .limit,
            .banner,
            .nextPayments,
            .emptyPlaceholder,
            .footerIndicator
        ].compactMap({ $0 }))
        return sections
    }
    
    private var tooltips: [NasiyaHomeViewControllerTooltip] {
        if !isVerified {
            return [.verifyButton(in: verifyView.continueButton)]
        } else {
            if output.filters.installments.models.isEmpty {
                guard let resetView: ResetLimitRoom = table.cell(at: 0, in: 1) else {
                    return []
                }
                return [.resetButton(in: resetView.container)]
            }
            
            return [
                .menuButton(in: navigationBar.leftButton),
                .notificationButton(in: navigationBar.rightButton),
            ]
        }
    }
    
    private var isVerified: Bool {
        if Config.isDebug {
            return true//AuthGlobalDefaults.user.isVerified ?? false
        } else {
            return AuthGlobalDefaults.user.isVerified ?? false
        }
    }
    
    private let tooltipManager = TooltipManager()
    
    var input = Input()
    var output = Output()
    
    let installmentViewModel: InstallmentViewModel
    let billingViewModel: BillingViewModel
    let profileViewModel: ProfileViewModel
    let homeViewModel: NasiyaHomeViewModel
    let commonViewModel: CommonViewModel
    let verificationViewModel: VerificationViewModel
    
    public init(
        installmentViewModel: InstallmentViewModel,
        billingViewModel: BillingViewModel,
        profileViewModel: ProfileViewModel,
        homeViewModel: NasiyaHomeViewModel,
        commonViewModel: CommonViewModel,
        verificationViewModel: VerificationViewModel,
        input: Input = .init(),
        output: Output = .init()
    ) {
        self.installmentViewModel = installmentViewModel
        self.billingViewModel = billingViewModel
        self.profileViewModel = profileViewModel
        self.homeViewModel = homeViewModel
        self.commonViewModel = commonViewModel
        self.verificationViewModel = verificationViewModel
        self.input = input
        self.output = output
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tooltipManager.didViewAppear = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tooltipManager.destroy()
    }
    
    public override func setupViews() {
        container.addSubview(table)
        container.addSubview(verifyView)
        table.addSubview(refreshControl)
    }
    
    public override func autolayout() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        verifyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func setupObservers() {
        OlchaVerificationDIContainer.shared.authCreditViewModel().$isVerified
            .combineLatest(installmentViewModel.$installments)
            .sink(receiveValue: { [weak self] (verified, installments) in
                guard let self else { return }
                output.filters.installments.models.append(installments.value?.orders, output.filters.installments.paging)
                output.filters.installments.paging.finished(paginator: installments.value?.paginator)
                verifyView.setup(isVerified: isVerified)
                let isLoading = installments == .loading || verified == .loading
                verifyView.updateSkeleton(isLoading: isLoading)
                output.filters.installments.paging.isLoading = isLoading
                input.ordersSkeleton.initialSkeleton(isAnimating: isLoading, output.filters.installments.paging)
                if !isLoading, !tooltipManager.didSetupTooltips {
                    table.reloadData(delay: 0.3) {
                        guard let topView = self.topView, !self.tooltipManager.didSetupTooltips else { return }
                        self.tooltipManager.setup(tooltips: self.tooltips, darkView: topView)
                    }
                }
            }).store(in: &bag)
        
        handle(verificationViewModel.$step,
               success: { [weak self] data in
            guard let self else { return }
            input.verification = data
            verifyView.setup(status: input.verification?.status)
            if isVerified {
                table.reloadData()
            }
        })
        
        handle(homeViewModel.$limit, withError: false, success: { [weak self] data in
            guard let self = self else { return }
            input.limit = data
            table.reloadData()
        })

        handle(homeViewModel.$requestLimitState, showLoader: true, withError: false) { [weak self] data in
            guard let self = self else { return }
            showLimitToaster(message: data?.message)
        } failure: { [weak self] error in
            guard let self = self else { return }
            showLimitToaster(message: error?.message)
        }
        
        handle(billingViewModel.$balances,
               withError: false,
               success: { [weak self] data in
            guard let self = self else { return }
            input.balances = data?.collection ?? []
            table.reloadData()
        })
        
        handle(profileViewModel.$user, success: { [weak self] data in
            guard let self = self else { return }
            self.input.user = data
        })
        
        handle(commonViewModel.$banners) { [weak self] data in
            guard let self else { return }
            input.banners = data?.banners ?? []
            table.reloadData()
        } loading: { [weak self] isLoading in
            guard let self else { return }
            input.bannersSkeleton.isAnimating = isLoading
            table.reloadData()
        }

        output.balanceFilled.sink { [weak self] in
            guard let self = self else { return }
            billingViewModel.loadAllBalances(reflection_alias: ReflectionType.nasiya_all_balance)
        }.store(in: &bag)
        
        output.pushFillBalance.sink { [weak self] balance in
            guard let self = self else { return }
            pushFillBalance(balance: balance)
        }.store(in: &bag)
        
        output.bannerClickObserver.sink { [weak self] data in
            guard let self = self else { return }
            bannerObserver(action: data?.getAction())
        }.store(in: &bag)
        
        navigationBar.rightButton.clicked { [weak self] in
            guard let self = self else { return }
            coordinator?.pushNotifications()
        }
        
        navigationBar.leftButton.clicked { [weak self] in
            guard let self = self else { return }
            coordinator?.presentMenu()
        }
        
        verifyView.setContinueButton { [weak self] in
            guard let self else { return }
            coordinator?.pushVerificationFlow()
        }
    }
    
    public override func initialRequest() {
        OlchaVerificationDIContainer.shared.authCreditViewModel().verifyCredit()
        billingViewModel.loadAllBalances(reflection_alias: ReflectionType.nasiya_all_balance)
        profileViewModel.loadUserData()
        homeViewModel.loadLimit()
        commonViewModel.loadBanners()
        verificationViewModel.loadStep()
        installmentViewModel.loadInstallments(filter: output.filters)
    }
    
    public func loadMore(_ index: Int) {
        guard canLoad(index: index,
                      paging: output.filters.installments.paging,
                      list: output.filters.installments.models) else { return }
        
        installmentViewModel.loadInstallments(filter: output.filters)
    }

    public func pushFillBalance(balance: BillingCollectionItem) {
        coordinator?.pushFillBalance(balance: balance) { [weak self] in
            guard let self = self else { return }
            billingViewModel.loadAllBalances(reflection_alias: ReflectionType.nasiya_all_balance)
        }
    }
    
    public func selectLimit() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            guard let firstSection: AmountBannersRoom = self.table.cell(at: 0, in: 0) else { return }
            let collection = firstSection.collection
            collection.isScrollEnabled = false
            collection.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
            collection.isScrollEnabled = true
        }
    }
    
    public override func configureViews() {
        languageUpdated()
    }
    
    public override func languageUpdated() {
        navigationBar.setTitle("main".localized())
        output.filters.resetStatuses(status: .inWork)
        verifyView.languageUpdated()
        languageReset()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        homeViewModel.loadLimit()
    }
    
    public override func refreshList(_ sender: AnyObject) {
        refreshReset()
        refreshControl.endRefreshing()
    }
    
}

public extension NasiyaHomeViewController {
    func languageReset() {
        output.filters.resetStatuses(status: .inWork)
        output.filters.reset()
        
        resetBaseActions()
    }
 
    func refreshReset() {
        output.filters.reset()
        input.banners.removeAll()
        resetBaseActions()
    }
    
    func resetBaseActions() {
        table.reloadData()
        commonViewModel.loadBanners()
        installmentViewModel.loadInstallments(filter: output.filters, cancel: true)
        output.balanceFilled.send()
    }
}
