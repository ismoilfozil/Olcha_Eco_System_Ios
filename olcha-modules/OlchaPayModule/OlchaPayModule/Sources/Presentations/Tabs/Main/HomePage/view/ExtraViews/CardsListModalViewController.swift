//
//  CardsListViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 04/02/23.
//

import UIKit
import OlchaUI
import Combine

public class CardsListModalViewController: BaseModalViewController {
    
    private lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.container.spacing = 16
        return scrollView
    }()
    
    public let allBalanceView = HomeAllBalanceView()
    
    weak var coordinator: PayHomeCoordinatorProtocol?
    
    public lazy var tableContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .olchaWhite
        view.round()
        return view
    }()
    
    public lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.registerClass(forCell: HomeCardListRoom.self)
        table.isScrollEnabled = false
        return table
    }()
    
    public lazy var addCardButton: BorderedButton = {
        let button = BorderedButton()
        button.setTitle("+" + "add_card".localized())
        button.titleLabel.style(.medium, 14)
        button.borderWidth = 2
        button.borderColor = .olchaAccentColor
        button.background = .clear
        button.titleLabel.textColor = .olchaAccentColor
        return button
    }()
    
    public override func configureViews() {
        dismissConfiguration()
        setHeader(title: "all_balance".localized())
        fullBackgroundColor = .olchaLightNeutralGray
        
        updateLayout()
    }
     
    public var items: [UserBankCardModel] = [] {
        didSet {
            updateLayout()
        }
    }
    
    public var cardsData: BankCardsData? {
        didSet {
            self.items = cardsData?.bank_cards ?? []
            self.allBalanceView.setup(totalSum: cardsData?.total_sum)
        }
    }
    
    let rowHeight: CGFloat = 50
    let separatorHeight: CGFloat = 20
    
    
    var isSelectable = false {
        didSet {
            addCardButton.isHidden = isSelectable
        }
    }
    
    var addCardObserver: (() -> Void)?
    
    let viewModel: BankCardsViewModel
    
    weak var makePaymentHelper: MakePaymentHelper?
    
    public init(viewModel: BankCardsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public override func setupViews() {
        container.addSubview(scrollView)
        scrollView.addArrangedSubview(allBalanceView)
        
        scrollView.addArrangedSubview(tableContainer)
        tableContainer.addSubview(table)
        container.addSubview(addCardButton)
    }
    
    public override func autolayout() {
        setContainerHeight(500)
        
        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(addCardButton.snp.top).inset(-16)
        }
        
        allBalanceView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        tableContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
        table.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(16)
            make.height.equalTo(getTableHeight())
        }
        
        addCardButton.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview().inset(16)
            make.height.equalTo(36)
        }
    }
    
    public override func setupObservers() {
        addCardButton.clicked { [weak self] in
            guard let self = self else { return }
            
            self.dismiss(animated: true) {
                self.coordinator?.pushAddNewCard(completed: self.addCardObserver)
            }
        }
        
        handle(viewModel.$bankCards, success: { [weak self] data in
            guard let self = self else { return }
            self.cardsData = data
        })
    }
    
    public override func initialRequest() {
        cardsData = viewModel.bankCardsData
    }
    
    private func updateLayout() {
        table.snp.updateConstraints { make in
            make.height.equalTo(getTableHeight())
        }
    }
    
    private func getTableHeight() -> CGFloat {
        let totalRowsHeight = items.count.cgfloat * rowHeight
        let totalSeparatorsHeight = max(0, (items.count.cgfloat-1)) * separatorHeight
        return totalRowsHeight + totalSeparatorsHeight
    }
}
