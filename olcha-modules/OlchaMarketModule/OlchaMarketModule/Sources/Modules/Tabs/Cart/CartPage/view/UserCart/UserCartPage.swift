//
//  CartPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 13/09/22.
//

import UIKit
import Combine
import OlchaUI
import Lottie
import OlchaVerification
import OlchaUtils
import OlchaAuth

class UserCartPage: OlchaUI.BaseViewController<OlchaUI.TitleNavigationBar> {
    
    struct Input {
        let userSkeleton = Skeleton()
        let cardSkeleton = Skeleton()
        
        var verification: VerificationData?
        var isVerified: Bool {
            AuthGlobalDefaults.user.isVerified ?? false
        }
        
        mutating func reset() {
            verification = nil
        }
    }
    
    struct Output {
        
    }
    
    enum CartPageType {
        case cash
        case credit
    }
    
    let animationView = LottieAnimationView()
    
    lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.registerClass(forCell: CartProductsGroupRoom.self)
        table.registerClass(forCell: CartItemRoom.self)
        table.registerClass(forCell: CartCostRoom.self)
        table.registerClass(forCell: CartActionsRoom.self)
        return table
    }()
    
    let commentContainerView: IButton = {
        let view = IButton()
        view.backgroundColor = .olchaTextBlack.withAlphaComponent(0.7)
        view.isHidden = true
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let commentTextView: CartCommentView = {
        let textView = CartCommentView()
        return textView
    }()
    
    let sections: [Section] = [
        .products,
        .profile,
        .locations,
        .orderType,
        .paymentType,
        .promocode,
        .emptyBonus,
        .bonus,
        .comment,
        .getCost,
        .action
    ]
    
    weak var coordinator: CartCoordinatorProtocol?
    
    var type: CartPageType = .cash {
        didSet {
            navigationBar.backButton.isHidden = (type == .cash)
        }
    }
    
    var initialLoading: Bool = true
    
    let viewModels = ViewModelsFactory()
    let observers = CartObservers()
    var initialCreditOrder: CreditOrder?
    
    var input = Input()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.disableShadow()
        tabBarController?.tabBar.isHidden = false
        screenAppearRequests()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.enableShadow()
    }
    
    override func setupViews() {
        super.setupViews()
        container.addSubview(table)
        table.addSubview(refreshControl)
        
        view.addSubview(commentContainerView)
        commentContainerView.addSubview(commentTextView)
    }
    
    override func autolayout() {
        super.autolayout()
        table.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        placeholder.contentView.snp.updateConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(64)
        }
        
        commentContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        commentTextView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        languageUpdated()
        setupAnimation()
    }
    
    override func languageUpdated() {
        
        if type == .cash {
            navigationController?.popToRootViewController(animated: true)
            navigationBar.setTitle("checkout_installment".localized())
        } else {
            navigationBar.setTitle("checkout_installment".localized())
        }
        
        datasUpdated()
        
        placeholder.setupTitle("empty_cart".localized())
        placeholder.setupSubtitle("empty_cart_subtitle".localized())
        placeholder.setupButtonTitle()
        
    }
    
    override func initialRequest() {
        viewModels.verification.loadStep()
    }
    
    override func setupObservers() {
        setupStaticObserver()
        setupCartObservers()
        networkingObservers()
        setupVerificationObservers()
    }
    
    func datasUpdated() {
        observers.action.loadGetCost.send()
        observers.action.tableReloader.send()
#warning("CART!!!!!!!!!!!!!!")
//        checkButtonState(isGetCost: false) ? bottomOrderButton.enableButton() : bottomOrderButton.disableButton()
    }
    
    func productsEmpty() {
        cancelCoupon()
        observers.reset()
    }
    
    func clearCartLocal() {
        CartViewModel.shared.deleteCartLocally(items: CartViewModel.shared.cartItems)
    }
    
    override func refreshList(_ sender: AnyObject) {
        refreshControl.endRefreshing()
    }
}
