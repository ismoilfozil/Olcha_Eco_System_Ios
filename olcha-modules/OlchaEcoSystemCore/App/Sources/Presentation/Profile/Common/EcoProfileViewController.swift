import UIKit
import OlchaUI
import OlchaAuth
import OlchaCommon
import OlchaUtils

public class EcoProfileViewController: BaseViewController<EcoProfileNavigationBar> {
    
    private lazy var gradientBackground: GradientView = {
        let view = GradientView()
        view.setupGradientView(
            .hex("#EFA1F9"), .hex("#EC7B8A"),
            points: (start: CGPoint(x: 0.0, y: 0.0), end: CGPoint(x: 1.0, y: 1.0))
        )
        return view
    }()
    
    private let profileView = ProfileView()
    
    private let roundViewContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        return view
    }()
    
    private let roundView: UIView = {
        let view = UIView()
        view.round(24, topCorner: true, bottomCorner: false)
        view.backgroundColor = .white
        return view
    }()
    
    private let notificationsView = EcoProfileNotificationsView()
    
//    private let loyaltyView = LoyaltyStepCardView()
    
    private lazy var table: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .white
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        table.showsVerticalScrollIndicator = false
        table.registerClass(forCell: EcoProfileTableCell.self)
        table.registerClass(forCell: EcoProfileLoginTableCell.self)
        return table
    }()
    
    public var lastContentOffset: CGFloat = 0.0
    public var selectObserver: ((ClickAction?) -> Void)?
    public var input: Input
    public var output: Output
    public let commonViewModel: CommonViewModel
    public let profileViewModel: ProfileViewModel
//    public let loyaltyViewModel: LoyaltyViewModel
    public weak var coordinator: EcoProfileCoordinatorProtocol?
    
    public init(
        commonViewModel: CommonViewModel,
        profileViewModel: ProfileViewModel,
//        loyaltyViewModel: LoyaltyViewModel,
        input: Input = .init(),
        output: Output = .init()
    ) {
        self.commonViewModel = commonViewModel
        self.profileViewModel = profileViewModel
//        self.loyaltyViewModel = loyaltyViewModel
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
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        commonViewModel.loadNotifications(page: 1, type: .user)
        profileViewModel.loadUserData()
    }
    
    public override func setupViews() {
        container.addSubview(gradientBackground)
//        container.addSubview(loyaltyView)
        container.addSubview(profileView)
        container.addSubview(roundViewContainer)
        container.addSubview(table)
        roundViewContainer.addSubview(roundView)
        roundViewContainer.addSubview(notificationsView)
    }
    
    public override func autolayout() {
        gradientBackground.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(table.snp.top)
        }
        profileView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
//        loyaltyView.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview().inset(16)
//            make.top.equalTo(profileView.snp.bottom).offset(20)
//        }
        
        notificationsView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(120)
        }
        table.snp.makeConstraints { make in
            make.top.equalTo(roundViewContainer.snp.centerY).offset(10)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        roundViewContainer.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(200)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(120)
        }
        roundView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        notificationsView.clipsToBounds = false
    }
    
    public override func languageUpdated() {
        table.reloadData()
        navigationBar.setTitle("profile_tab_item".localized(.olchaEcoSystemCore))
        let isUser = AuthGlobalDefaults.isUser()
        profileView.setNameLabel(isUser ? "-" : "profile_name".localized())
        profileView.setSubNameLabel(isUser ? "-" : "profile_id".localized())
    }
    
    public func logout() {
        EcoAppConfigurator.shared.appCoordinator?.logout()
    }
    
    public override func setupObservers() {
        handle(profileViewModel.$user, success: { [weak self] data in
            guard let self, let data else { return }
            input.user = data
            profileView.setNameLabel("\(data.name ?? " - ")  \(data.lastname ?? " - ")")
            profileView.setSubNameLabel("ID: \(data.id ?? 0)")
        })
        handle(commonViewModel.$notifications, success: { [weak self] data in
            guard let self, let data else { return }
            input.notifications.models = data.notifications ?? []
            notificationsView.destroy {
                self.notificationsView.addCards(notifications: self.input.notifications.models)
            }
        })
        notificationsView.$readNotification
            .compactMap({ $0?.id })
            .sink { [weak self] notificationId in
                guard let self else { return }
                commonViewModel.readNotification(id: notificationId)
            }.store(in: &bag)
        notificationsView.$cards
            .dropFirst()
            .sink { [weak self] cards in
                guard let self else { return }
                updateLayout(hasNotifications: !cards.isEmpty)
            }.store(in: &bag)
        notificationsView.tapObserver = selectObserver
        navigationBar.rightButtonClicked { [weak self] in
            guard let self else { return }
            coordinator?.pushSettings()
        }
        AuthNotificationManager.shared.addObserver(observer: self, selector: #selector(authStatusChanged))
    }
    
    public override func initialRequest() {
        commonViewModel.loadNotifications(page: 1, type: .user)
        profileViewModel.loadUserData()
        // - loyalty
//        loyaltyViewModel.loadLevels()
//        loyaltyViewModel.loadUserLevel()
//        loyaltyViewModel.loadNextLevel()
    }
    
}

private extension EcoProfileViewController {
    func updateLayout(hasNotifications: Bool) {
        container.bringSubviewToFront(hasNotifications ? roundViewContainer : table)
        table.snp.remakeConstraints { make in
            let target = hasNotifications ? roundViewContainer.snp.bottom : roundViewContainer.snp.centerY
            let offset = hasNotifications ? 0 : 10
            make.top.equalTo(target).offset(offset)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func setTableView(expanded: Bool) {
        roundViewContainer.snp.updateConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(expanded ? 0 : 200)
        }

//        loyaltyView.snp.updateConstraints { make in
//            make.top.equalTo(profileView.snp.bottom).offset(expanded ? -500 : 20)
//        }
//        
        profileView.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(expanded ? 0 : 20)
        }

        table.snp.updateConstraints { make in
            let hasNotifications = !notificationsView.cards.isEmpty
            let offset = hasNotifications ? 0 : expanded ? -50 : 10
            let target = hasNotifications ? roundViewContainer.snp.bottom : roundViewContainer.snp.centerY
            make.top.equalTo(target).offset(offset)
        }
        let delay: TimeInterval = expanded ? 0 : 0.1
        UIView.animate(withDuration: 0.3, delay: delay, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        })
    }
}

public extension EcoProfileViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        setTableView(expanded: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let velocity = scrollView.panGestureRecognizer.velocity(in: scrollView).y
        let offset = scrollView.contentOffset
        guard AuthGlobalDefaults.isUser(), velocity != 0 else { return }
        setTableView(expanded: (velocity < 0 && offset.y > 20))
    }
}

private extension EcoProfileViewController {
    @objc func authStatusChanged(_ notification: Notification) {
        notificationsView.destroy()
    }
}
