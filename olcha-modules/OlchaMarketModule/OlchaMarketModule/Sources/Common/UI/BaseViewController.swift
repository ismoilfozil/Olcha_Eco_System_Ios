//
//  BaseViewController.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 29/06/22.
//

import UIKit
import SnapKit
import Combine
import IQKeyboardManagerSwift
import ProgressHUD
import OlchaAuth
import OlchaUI
import OlchaUtils

protocol BaseViewControllerProtocol {
    func showPostProgress()
    func hidePostProgress()
    func showCenterProgress()
    func hideCenterProgress()
}

open class BaseViewController: UIViewController {
    var tabbarAnimated = false
    var likeToastEnabled = true
    var compareToastEnabled = true
    
    var initallyAnimates = false///animate collection/table view
    public let container = IQPreviousNextView()
    
    
    let navigation = OlchaNavigationBar()
    var sortMenus : ButtonMenus?

    
    private var bag = Set<AnyCancellable>()
    
    private let shrinkHeight: CGFloat = 56.0
    
    private let centerProgressContainer = UIView()
    
    private let centerProgress = UIActivityIndicatorView()
    
    
    var bottomToastTimer: Timer?
    var bottomToast : UIView?
    let bottomToastLeftIconContainer = IconButton()
    let bottomToastLeftIcon = IconButton()
    let bottomToastTitleLabel = UILabel()
    let bottomToastRightIcon = IconButton()
    let bottomToastButton = Button()
    
    private let headerContainer = UIStackView()
    let xButton = IconButton()
    private let modalHeaderTitle = UILabel()
    
    private let modalMainContainer = UIView()
    public  let modalContainer = IQPreviousNextView()
    private let dismissTrackerContainer = UIView()
    private let dismissTracker = UIView()
    private let dismissContainer = UIButton()
    
    //MARK: - Placeholder
    let placeholder = EmptyPlaceholder()
    
    //MARK: Connection
    var connectionContainerIsOpened = false
    let rightMargin: CGFloat = 80.0
    let connectionContainer = UIView()
    let connectionBackground = UIImageView()
    let connectionExpandButton = IconButton()
    let telegramButton = IconButton()
    let instagramButton = IconButton()
    
    let refreshControl = UIRefreshControl()
    
    var authCoordinator: OlchaAuthCoordinatorProtocol?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        initialViewDidLoad()
        baseSetupViews()
        baseAutolayout()
        baseConfigureViews()
        baseInitialRequest()
        
        setupViews()
        autolayout()
        configureViews()
        setupObservers()
        initialRequest()
        
        baseObservers()
    }
    
    
    func initialViewDidLoad() {}

    func setupViews() {}
    func autolayout() {}
    func configureViews() {}
    
    func setupObservers() {}
    func initialRequest() {}
    
    func baseObservers() {
        navigation.delegate = self
        LanguageObserver.shared.observer.sink { [weak self] in
            guard let self = self else { return }
            LocalizationBundle.setup()
            updateTabNames()
            languageUpdated()
        }.store(in: &bag)
        
        CartViewModel
            .shared
            .$cartCount
            .sink { [weak self] count in
                guard let self = self else { return }
                if let items = self.tabBarController?.tabBar.items {
                    let tabItem = items[OlchaTab.cart]
                    tabItem.badgeValue = max(0, count).string
                }
            }.store(in: &bag)
        
        CartViewModel
            .shared
            .$favouritesCount
            .sink { [weak self] count in
                guard let self = self else { return }
                #warning("Favourite o'zgartirish")
                if let items = self.tabBarController?.tabBar.items {
                    let tabItem = items[OlchaTab.badgeTab]
                    tabItem.badgeValue = max(0, count).string
                }
            }.store(in: &bag)
        
        CartViewModel.shared.favouritesAuthError = { [weak self] in
            guard let self = self else { return }
            pushAuth()
        }
        
        CartViewModel
            .shared
            .favouriteAdded
            .sink { [weak self] isLiked in
                guard let self = self,
                      self.likeToastEnabled,
                      isLiked else { return }
                
                self.changeTabBar(hidden: false, animated: true)
                pushFavourites()
            }.store(in: &bag)
        
        CompareViewModel
            .shared
            .compareAdded
            .sink { [weak self] isAdded in
                guard let self,
                      compareToastEnabled,
                      isAdded
                else { return }
                    pushCompare()
            }.store(in: &bag)
    }
    
    private func updateTabNames() {
        if let items = self.tabBarController?.tabBar.items {
            for i in 0..<min(items.count, OlchaTab.tabs.count) {
                items[i].title = OlchaTab.tabs[i].title
            }
        }
    }
    
    open func languageUpdated() {}
    
    @objc func refreshList(_ sender: AnyObject) {}
    
    func baseSetupObservers(viewModel: OldBaseViewModel) {
        viewModel
            .$centerLoading
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                
                if isLoading {
                    viewModel.centerLoadingsCount += 1
                    self.showCenterProgress()
                } else {
                    viewModel.centerLoadingsCount -= 1
                    if viewModel.centerLoadingsCount <= 0 {
                        viewModel.centerLoadingsCount = 0
                        self.hideCenterProgress()
                    }
                }
                
            }.store(in: &bag)
            
        
        viewModel
            .$errorMessage
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let self = self else { return }
                self.showError(text: message)
            }.store(in: &bag)
        
        viewModel
            .$successMessage
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let self = self else { return }
                self.showSuccess(text: message)
            }.store(in: &bag)
        
        viewModel
            .authObserver
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isError in
                guard let self = self else { return }
                if isError {
                    print("⛔⛔⛔⛔⛔⛔⛔⛔⛔ AUTH ⛔⛔⛔⛔⛔⛔⛔⛔⛔")
                }
            }.store(in: &bag)
    }
    
    private func pushFavourites() {
        showToast(type: .favourites) { [weak self] in
            guard let self else { return }
            
            dismiss(animated: true) {
                if let navigationController = Funcs.getTopViewController()?.navigationController {
                    let vc: FavouritesPage = OlchaDIContainer.shared.resolve()
                    navigationController.push(vc)
                }
            }
        }
    }
    
    private func pushCompare() {
        showToast(type: .compare) { [weak self] in
            guard let self else { return }
            
            dismiss(animated: true) {
                if let navigationController = Funcs.getTopViewController()?.navigationController {
                    let vc: ComparePage = OlchaDIContainer.shared.resolve()
                    navigationController.push(vc)
                }
            }
        }
    }
    
    func setupModalViews() {
        view.addSubview(dismissContainer)
        view.addSubview(modalMainContainer)
        modalMainContainer.addSubview(modalContainer)
        modalMainContainer.addSubview(dismissTrackerContainer)
        
        modalMainContainer.addSubview(headerContainer)
        
        headerContainer.addArrangedSubview(modalHeaderTitle)
        headerContainer.addArrangedSubview(xButton)
        
        dismissTrackerContainer.addSubview(dismissTracker)
        centerProgressSetup()
    }
    
    func modalAutolayout() {
        dismissContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        modalContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headerContainer.snp.bottom).inset(-8)
            make.bottom.equalToSuperview().inset(UIApplication.shared.bottomInset)
        }
        
        dismissTrackerContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        dismissTracker.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.height.equalTo(4)
            make.width.equalTo(40)
        }
        
        xButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        
        headerContainer.snp.makeConstraints { make in
            make.top.equalTo(dismissTrackerContainer.snp.bottom).inset(-8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        modalMainContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview().inset(100)
        }
        
        centerProgressAutolayout()
    }
    func configureModalViews(header: String = "", textAlignment: NSTextAlignment = .left) {

        modalHeaderTitle.textAlignment = textAlignment
        modalHeaderTitle.text = header
        
        xButton.setIcon(.x)
        
        dismissContainer.backgroundColor = .clear
        view.backgroundColor = .clear
        
        
        dismissContainer.setTitle("", for: .normal)
        dismissContainer.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
        
        modalContainer.backgroundColor = .olchaBackgroundColor
        modalMainContainer.backgroundColor = .olchaBackgroundColor
        dismissTrackerContainer.backgroundColor = .olchaBackgroundColor
        
        dismissTracker.backgroundColor = .olchaLightNeutralGray
        dismissTracker.round(2)
        

        dismissTrackerContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        dismissTrackerContainer.round()
        
        modalMainContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        modalMainContainer.round()
        
        modalHeaderTitle.style(.bold, 18)
        modalHeaderTitle.textColor = .olchaTextBlack
        modalHeaderTitle.numberOfLines = 0
        modalHeaderTitle.lineBreakMode = .byWordWrapping
        modalHeaderTitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        modalHeaderTitle.setContentCompressionResistancePriority(.required, for: .vertical)
        
        headerContainer.axis = .horizontal
        headerContainer.spacing = 8
        headerContainer.distribution = .fill
        headerContainer.alignment = .center
        
        xButton.clicked { [weak self] in
            guard let self = self else { return }
            dismiss(animated: true, completion: nil)
        }
        
        centerProgressConfigure()

    }

    func setContainerHeight(_ height: CGFloat = UIScreen.main.bounds.height) {
        
        let maxHeight = UIScreen.main.bounds.height * 0.8
        modalContainer.snp.remakeConstraints { make in
            if height > maxHeight {
                make.height.equalTo(maxHeight)
            } else {
                make.height.equalTo(height)
            }
            make.left.right.equalToSuperview()
            make.top.equalTo(headerContainer.snp.bottom).inset(-8)
            make.bottom.equalToSuperview().inset(UIApplication.shared.bottomInset)
        }
    }
    
    @objc func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func pushAuth() {
        
        if let navigationController = Funcs.getTopViewController()?.navigationController {
            authCoordinator = OlchaAuthCoordinator(navigationController: navigationController)
            authCoordinator?.pushAuth(isSet: false) {}
        }
        
    }
}

extension BaseViewController {
    
    
    func showCenterProgress() {
        centerProgressContainer.isHidden = false
    }
    
    func hideCenterProgress() {
        centerProgressContainer.isHidden = true
    }
//    
//    func showAlert(title: String = " ", text: String) {
//        self.showError(text: )
//        showErrorPopUp(title,text)
//    }
}

extension BaseViewController {
    
    func centerProgressSetup() {
        view.addSubview(centerProgressContainer)
        centerProgressContainer.addSubview(centerProgress)
    }
    
    func centerProgressAutolayout() {
        
        centerProgressContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        centerProgress.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func centerProgressConfigure() {
        centerProgressContainer.layer.cornerRadius = 8
        centerProgressContainer.backgroundColor = .lightGray.withAlphaComponent(0.3)
        
        centerProgress.color = .olchaAccentColor
        centerProgress.startAnimating()
        hideCenterProgress()
    }
    
    func baseSetupViews() {
        view.addSubview(container)
        view.addSubview(placeholder)
        view.addSubview(navigation)
        centerProgressSetup()
    }
    
    func baseAutolayout() {
        
        container.snp.makeConstraints { make in
            make.top.equalTo(navigation.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        placeholder.snp.makeConstraints { make in
            make.edges.equalTo(container.snp.edges)
        }
        
        navigation.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(shrinkHeight)
        }
        
        centerProgressAutolayout()
    }
    
    
    func baseConfigureViews() {
        view.backgroundColor = .olchaWhite
        navigationController?.navigationBar.isHidden = true
        
        centerProgressConfigure()
        
        configureTapActions()
        
        disablePlaceholder()
        
        refreshControl.addTarget(self, action: #selector(self.refreshList(_:)), for: .valueChanged)
        refreshControl.tintColor = .olchaAccentColor
    }
    
    func baseInitialRequest() {}
    
    
    func backButtonClicker() {
        
    }
}


//MARK: - NavigationBar Actions
extension BaseViewController: NavBarDelegate {

    @objc open func popPage() {
        if self.navigationController?.topViewController != self {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setNavigationTitle( _ title: String) {
        navigation.setTitle(title)
    }
    
    func hideNavigationBar() {
        navigation.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
    }
    
    func presentShareScreen(text: String?) {
        
        let textShare = [ (text ?? "")]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
        self.present(activityViewController, animated: true, completion: nil)
        
    }
}
//MARK: - 

extension BaseViewController: UIGestureRecognizerDelegate {
    func configureTapActions() {
//        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(screenTapped))
//        tapGesture.cancelsTouchesInView = false
//        tapGesture.delegate = self
//        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func screenTapped() {
        hideMenus()
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let menus = sortMenus else { return true }
        
        let location = touch.location(in: nil)
        
        if menus.frame.contains(location) {
            return false
        }
        
        return true
    }
}
