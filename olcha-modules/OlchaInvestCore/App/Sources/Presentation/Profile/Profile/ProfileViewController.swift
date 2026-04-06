//
//  ProfileViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 30/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import OlchaBilling
import OlchaAuth
import OlchaUtils

public class ProfileViewController: BaseViewController<InvestNavigationBar> {
    
    private lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.horizontalEdge()
        scrollView.container.spacing = 16
        scrollView.settings.showsVerticalScrollIndicator = false
        scrollView.settings.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        scrollView.settings.alwaysBounceVertical = true
        return scrollView
    }()
    private lazy var table: DynamicTable = {
        let table = DynamicTable()
        table.registerClass(forCell: InvestHomeModalTableCell.self)
        table.isScrollEnabled = false
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        return table
    }()
    
    private let profileView = ProfileView()
    public let cardsView = ProfieCardsView()
    private var tooltips: [ProfileViewControllerTooltip] {
        let firstItem = cardsView.collection.cellForItem(at: IndexPath(row: 0, section: 0)) as? ProfileCardsViewItem
        let phoneCell: InvestHomeModalTableCell? = cell(for: .personal)
        let cardCell: InvestHomeModalTableCell? = cell(for: .cards)
        let passportCell: InvestHomeModalTableCell? = cell(for: .passport)
        let securityCell: InvestHomeModalTableCell? = cell(for: .security)
        var tooltips: [ProfileViewControllerTooltip] = []
        if let firstItem, let phoneCell, let cardCell, let passportCell, let securityCell {
            tooltips.append(.balance(in: firstItem))
            tooltips.append(.phoneDetails(in: phoneCell))
            tooltips.append(.cardDetails(in: cardCell))
            tooltips.append(.passportDetails(in: passportCell))
            tooltips.append(.security(in: securityCell))
        }
        return tooltips
    }
    private let tooltipManager = TooltipManager()
    public var balanceId: Int?
    public let billingViewModel: BillingViewModel
    public let profileViewModel: ProfileViewModel
    public var input: Input
    public var output: Output
    public weak var coordinator: ProfileCoordinatorProtocol?
    
    public init(billingViewModel: BillingViewModel,
                profileViewModel: ProfileViewModel,
                input: Input = .init(),
                output: Output = .init()) {
        self.billingViewModel = billingViewModel
        self.profileViewModel = profileViewModel
        self.input = input
        self.output = output
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        input.skeletonViews.forEach({ $0.layoutSkeletonIfNeeded() })
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
        container.addSubview(scrollView)
        scrollView.settings.addSubview(refreshControl)
        scrollView.addArrangedSubview(profileView)
        scrollView.addArrangedSubview(cardsView)
        scrollView.addArrangedSubview(table)
    }
    
    public override func autolayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        cardsView.snp.makeConstraints { make in
            make.height.equalTo(150)
        }
    }
    
    public override func configureViews() {
        profileView.setNameLabel(" - ")
        profileView.setSubNameLabel("ID: - ")
        languageUpdated()
        configureSkeleton()
    }
    
    public func configureSkeleton() {
        input.skeletonViews = [
            profileView
        ]
        input.skeletonViews.forEach({
            $0.isSkeletonable = true
            $0.showAnimatedGradientSkeleton()
        })
    }
    
    public override func initialRequest() {
        profileViewModel.loadUserData()
        billingViewModel.loadAllBalances(reflection_alias: ReflectionType.invest_all_balance)
    }
    
    public override func languageUpdated() {
        navigationBar.setTitle("profile_heading".localized(.olchaInvestCore))
        table.reloadData()
    }
    
    public override func setupObservers() {
        navigationBar.isProfile = true
        navigationBar.menuClicked { [weak self] in
            self?.coordinator?.presentMenu()
        }
        navigationBar.rightButtonClicked { [weak self] in
            self?.pushSettingsViewController()
        }
        
        profileView.button.clicked { [weak self] in
            self?.pushPersonalDataViewController()
        }
        
        handle(billingViewModel.$balances, withError: false, success: { [weak self] data in
            guard let self = self, let data = data else { return }
            cardsView.setCards(data: data) {
                if let topView = self.topView {
                    self.tooltipManager.setup(tooltips: self.tooltips, darkView: topView)
                }
                if let balanceId = self.balanceId {
                    self.cardsView.selectBalance(by: balanceId)
                }
            }
        }, loading: { [weak self] isLoading in
            guard let self else { return }
            cardsView.updateSkeleton(isLoading: isLoading)
        })
        
        output.balanceFilled.sink { [weak self] isFilled in
            guard let self = self else { return }
            billingViewModel.loadAllBalances(reflection_alias: ReflectionType.invest_all_balance)
        }.store(in: &bag)
        
        handle(profileViewModel.$user, success: { [weak self] data in
            guard let self = self else { return }
            input.user = data
            profileView.setNameLabel("\(self.input.user?.name ?? " - ")  \(self.input.user?.lastname ?? " - ")")
            profileView.setSubNameLabel("ID: \(self.input.user?.id ?? 0)")
        }, loading: { [weak self] isLoading in
            guard let self else { return }
            updateSkeleton(isLoading: isLoading)
        })
        
        cardsView.amountButtonObserver = { [weak self] in
            self?.pushBalanceFill()
        }
    }
    
    public override func refreshList(_ sender: AnyObject) {
        input.reset()
        initialRequest()
        refreshControl.endRefreshing()
    }
    
    public func pushBalanceFill() {
        guard let balanceItem = cardsView.output.balanceCollectionItem else { return }
//        coordinator?.pushFillBalance(balanceFilled: output.balanceFilled, balanceId: balanceId)
        coordinator?.pushFillBalance(balanceFilled: output.balanceFilled, balance: balanceItem)
    }
    
    public func pushPersonalDataViewController() {
        coordinator?.pushPersonalDataViewController()
    }
    
    public func pushSettingsViewController() {
        coordinator?.pushSettingsViewController()
    }
    
}

private extension ProfileViewController {
    func updateSkeleton(isLoading: Bool = true) {
        input.skeletonViews.forEach({
            $0.layoutSkeletonIfNeeded()
            isLoading ? $0.showAnimatedGradientSkeleton() : $0.hideSkeleton()
        })
    }
    
    func cell<T: UITableViewCell>(for row: ProfileRow) -> T? {
        return table.cell(at: rows.firstIndex(of: row).orZero, in: 0) as? T
    }
}
