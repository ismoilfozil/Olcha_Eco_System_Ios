import UIKit
import Combine
import OlchaUI
import OlchaUtils
import OlchaNasiyaModule
import OlchaPayModule
import OlchaCommon

public class EcoHomeViewController: BaseViewController<EcoNavigationBar> {
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .radial
        gradient.locations = [0, 0.5, 1]
        gradient.startPoint = CGPoint(x: 0.1, y: 0.1)
        gradient.endPoint = CGPoint(x: 1, y: 0.7)
        let yellowColor = UIColor.yellowGradientColor?.withAlphaComponent(0.5).cgColor ?? UIColor.black.cgColor
        let pinkColor = UIColor.pinkGradientColor?.withAlphaComponent(0.5).cgColor ?? UIColor.white.cgColor
        let redColor = UIColor.redGradientColor?.withAlphaComponent(0.42).cgColor ?? UIColor.white.cgColor
        gradient.colors = [yellowColor, pinkColor, redColor]
        return gradient
    }()
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.registerClass(forCell: EcoHomeSearchTableCell.self)
        table.registerClass(forCell: EcoHomeAppTableCell.self)
//        table.registerClass(forCell: EcoHomeNasiyaLimitTableCell.self)
        table.registerClass(forCell: EcoHomeBalanceTableCell.self)
        table.registerClass(forCell: EcoHomeBannerTableCell.self)
        table.registerClass(forCell: EcoHomeMarketTableCell.self)
        table.registerClass(forCell: EcoHomeNasiyaTableCell.self)
        table.registerClass(forCell: EcoHomeSayohatTableCell.self)
        table.registerClass(forCell: EcoHomeInvestTableCell.self)
        table.registerClass(forCell: EcoHomePayTableCell.self)
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .clear
        table.configure()
        return table
    }()
    
    public var input: Input
    public var output: Output
    public let viewModel: EcoHomeViewModel
    public let nasiyaViewModel: NasiyaHomeViewModel
    public let payBankCardsViewModel: BankCardsViewModel
    public let commonViewModel: CommonViewModel
    public let loyaltyViewModel: LoyaltyViewModel
    public weak var coordinator: EcoHomeCoordinatorProtocol?
    
    public init(
        viewModel: EcoHomeViewModel,
        nasiyaViewModel: NasiyaHomeViewModel,
        payBankCardsViewModel: BankCardsViewModel,
        commonViewModel: CommonViewModel,
        loyaltyViewModel: LoyaltyViewModel,
        input: Input = .init(),
        output: Output = .init()
    ) {
        self.viewModel = viewModel
        self.nasiyaViewModel = nasiyaViewModel
        self.payBankCardsViewModel = payBankCardsViewModel
        self.commonViewModel = commonViewModel
        self.loyaltyViewModel = loyaltyViewModel
        self.input = input
        self.output = output
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        AuthNotificationManager.shared.removeObserver(self)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = CGRect(
            x: view.frame.origin.x, y: view.frame.origin.y,
            width: view.frame.width, height: view.frame.height * 0.6
        )
    }
    
    public override func setupViews() {
        view.layer.insertSublayer(gradientLayer, at: 0)
        container.addSubview(table)
        table.addSubview(refreshControl)
    }
    
    public override func autolayout() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        languageUpdated()
        navigationBar.rightButton.clicked { [weak self] in
            guard let self else { return }
            coordinator?.pushNotification()
        }
        navigationBar.barcodeButton.clicked { [weak self] in
            guard let self else { return }
            coordinator?.pushConfirmationScreen()
        }
        view.backgroundColor = .lightGrayBackground
//        enableLogger(state: Config.isTestFlightOrDebug)
    }
    
    public override func setupObservers() {
        commonViewModel.$banners
            .sink(receiveValue: { [weak self] banners in
                guard let self else { return }
                let isLoading = banners == .loading
                input.banners = banners.value
                input.bannerSkeleton.isAnimating = isLoading
                reloadSection(with: .banner, isLoading: isLoading)
            }).store(in: &bag)
        
        viewModel.$builder
            .compactMap({ $0.value?.builder })
            .sink(receiveValue: { [weak self] builder in
                guard let self else { return }
                input.builders = builder
                table.reloadData()
            }).store(in: &bag)
        
//        nasiyaViewModel.$limit
//            .sink(receiveValue: { [weak self] nasiyaLimit in
//                guard let self else { return }
//                let isLoading = nasiyaLimit == .loading
//                input.nasiyaLimit = nasiyaLimit.value
//                input.nasiyaLimitSkeleton.isAnimating = isLoading
//                reloadSection(with: .nasiyaLimit, isLoading: isLoading, animation: .none)
//            }).store(in: &bag)
        
        payBankCardsViewModel.$balances.combineLatest(viewModel.$balance, viewModel.$bonusBalance)
            .sink(receiveValue: { [weak self] (payBalance, olchaBalance, bonusBalance) in
                guard let self else { return }
                setBalances(
                    payBalance: payBankCardsViewModel.balancesData,
                    balance: olchaBalance.value,
                    bonusBalance: bonusBalance.value
                )
                let isLoading = payBalance == .loading || olchaBalance == .loading || bonusBalance == .loading
                input.balanceSkeleton.isAnimating = isLoading
                reloadSection(with: .balance, isLoading: isLoading, animation: .none)
            }).store(in: &bag)
        
        output.observers.clickActionSubject.sink(receiveValue: { [weak self] action in
            guard let self else { return }
            coordinator?.clickActionRouter(action: action)
        }).store(in: &bag)
        
        output.observers.appServiceSubject.sink { [weak self] service in
            guard let self else { return }
            switch service {
            case .invest:
                ModuleGeneratorHelper.shared.generate(module: .invest, appStarted: nil)
            case .market:
                ModuleGeneratorHelper.shared.generate(module: .olcha, appStarted: nil)
            case .nasiya:
                ModuleGeneratorHelper.shared.generate(module: .nasiya, appStarted: nil)
            case .pay:
                ModuleGeneratorHelper.shared.generate(module: .pay, appStarted: nil)
            default:
                self.showInvalidSnackbar(container)
            }
        }.store(in: &bag)
        
        AuthNotificationManager.shared.addObserver(observer: self, selector: #selector(authStatusChanged))
    }
    
    private func setBalances(payBalance: BalancesData?, balance: BalanceData?, bonusBalance: BonusData?) {
        input.payBalance = payBalance
        input.balance = balance
        input.bonusBalance = bonusBalance
    }
    
    public override func initialRequest() {
        #warning("NEW RELEASE")
        //loyaltyViewModel.loadNextLevel()
        
        viewModel.loadBuilders()
        viewModel.loadBalance()
        viewModel.loadBonusBalance()
//        nasiyaViewModel.loadLimit()
        payBankCardsViewModel.loadBalancesWithoutRunloop()
        commonViewModel.loadBanners()
    }
    
    public override func languageUpdated() {
        initialRequest()
    }
    
    public override func refreshList(_ sender: AnyObject) {
        input.reset()
        table.reloadData()
        initialRequest()
        refreshControl.endRefreshing()
    }
}

private extension EcoHomeViewController {
    @objc func authStatusChanged(_ notification: Notification) {
        navigationBar.updateBarcodeButtonVisibility()
        initialRequest()
    }
    
    func reloadSection(with section: Section, isLoading: Bool, animation: UITableView.RowAnimation = .fade) {
        guard !isLoading, let sectionIndex = noBuilderSections.firstIndex(of: section) else {
            return
        }
        table.reloadSections([sectionIndex], with: animation)
    }
}
