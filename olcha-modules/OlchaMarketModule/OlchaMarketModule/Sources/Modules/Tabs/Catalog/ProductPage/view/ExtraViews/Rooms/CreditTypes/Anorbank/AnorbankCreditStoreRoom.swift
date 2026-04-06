//
//  AnorbankCreditStoreRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 11/11/22.
//

import UIKit
import OlchaUI
import Combine
class AnorbankCreditStoreRoom: BaseTableCell {

    
    enum PaymentType: String {
        case permonth = "permonth_payment"
        case overall = "overall_payment"
    }
    
    let staticSection = UIView()
    private let stackContainerBackground = UIView()
    let stackContainer = UIStackView()
    let checkRound = IconButton()
    let icon = UIImageView()
    let dataSection = UIView()
    let monthTitle = UILabel()
    
    let paymentInfoContainer = UIStackView()
    let hintInfoIcon = IconButton()
    let hintInfoTitle = UILabel()

    var permonthLabel: UILabel?
    var overallLabel: UILabel?

    //MARK: Bottom sections
    let hintBottomSection = UIView()
    let separator = Divide()
    let cardOrderTitle = UILabel()
    let anorbankAppButton = Button()
    
    var bag = Set<AnyCancellable>()
    
    var products: [ProductModel] = []
    
    var viewModel = CreditViewModel()
    
    weak var creditOrder: CreditOrder?
    
    let payments: [PaymentType] = [
        .permonth,
        .overall
    ]
    
    weak var isReady: PassthroughSubject<Bool, Never>?
    
    private var tempCreditData: CartCreditData?
    
    var isChosen: Bool = false {
        didSet {
            isChosen ? selectedStyle() : unselectedStyle()
        }
    }
    
    private let staticMonth = 12
    
    override func setupViews() {
        container.addSubview(stackContainerBackground)
        stackContainerBackground.addSubview(stackContainer)
        stackContainer.addArrangedSubview(staticSection)
        stackContainer.addArrangedSubview(hintBottomSection)
        
        staticSection.addSubview(checkRound)
        staticSection.addSubview(icon)
        staticSection.addSubview(dataSection)
        
        dataSection.addSubview(monthTitle)
        dataSection.addSubview(paymentInfoContainer)
        dataSection.addSubview(hintInfoIcon)
        dataSection.addSubview(hintInfoTitle)
        
        
        hintBottomSection.addSubview(separator)
        hintBottomSection.addSubview(cardOrderTitle)
        hintBottomSection.addSubview(anorbankAppButton)
    }
    
    override func autolayout() {
       
        stackContainerBackground.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        stackContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        checkRound.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
        
        icon.snp.makeConstraints { make in
            make.left.equalTo(checkRound.snp.right).inset(-12)
            make.top.equalTo(checkRound)
            make.height.equalTo(24)
        }
        
        
        dataSection.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).inset(-16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
        
        monthTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        paymentInfoContainer.snp.makeConstraints { make in
            make.top.equalTo(monthTitle.snp.bottom)
            make.left.right.equalToSuperview().inset(16)
        }
        
        hintInfoIcon.snp.makeConstraints { make in
            make.top.equalTo(paymentInfoContainer.snp.bottom).inset(-8)
            make.width.height.equalTo(16)
            make.left.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        hintInfoTitle.snp.makeConstraints { make in
            make.top.equalTo(paymentInfoContainer.snp.bottom).inset(-8)
            make.left.equalTo(hintInfoIcon.snp.right).inset(-4)
            make.right.equalToSuperview().inset(16)
        }
      
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
     
        cardOrderTitle.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(separator.snp.bottom).inset(-16)
        }
        
        anorbankAppButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(cardOrderTitle.snp.bottom).inset(-4)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        checkRound.isUserInteractionEnabled = false
        stackContainer.axis = .vertical
        
        icon.image = .anorbank
        
        selectedStyle()
        
        paymentInfoContainer.axis = .vertical
        paymentInfoContainer.spacing = 4
        hintInfoIcon.setIcon(.info?.withColor(.olchaOrange ?? .orange))
        hintInfoTitle.style(.regular, 12)
        hintInfoTitle.textColor = .olchaOrange
        
        cardOrderTitle.style(.medium, 12)
        cardOrderTitle.text = "anorbank_card_required".localized()
        cardOrderTitle.textColor = .olchaOrange
        
        anorbankAppButton.titleLabel?.style(.medium, 12)
        anorbankAppButton.setTitleColor(.olchaBlue, for: .normal)
        anorbankAppButton.setTitle("anorbank_card_order".localized(), for: .normal)
        
        anorbankAppButton.clicked {
            Funcs.openAnorbank()
        }
        
        stackContainerBackground.round()
        
        setupObservers()
    }

    func selectedStyle() {
        stackContainerBackground.round()
        checkRound.setIcon(.round_selected_check)
        stackContainerBackground.darkBorder(with: .olchaAccentColor)
    }
    
    func unselectedStyle() {
        stackContainerBackground.round()
        checkRound.setIcon(.round_unselected_check)
        stackContainerBackground.darkBorder(with: .olchaLightNeutralGray)
    }
    
    func setup(with data: [ProductModel]) {
        
        products = data
        tempCreditData = CartCreditData()
        viewModel.staticMonth = staticMonth
        viewModel.withInitialFee = false
        drawPaymentsSection()

        viewModel.calculateStatics(products: data)
        valueChanged(month: staticMonth)
        updateData()
    }
    
    
}

//MARK: -  ACTIONS
extension AnorbankCreditStoreRoom: SliderViewDelegate {
    func valueChanged(month: Int) {
        viewModel.month = month
        viewModel.calculate(products: products)
    }
    
    func updateData() {
        guard let tempCreditData = tempCreditData else { return }
        tempCreditData.inst_pay_time = viewModel.month
        tempCreditData.first_fee_sum = viewModel.initialPayment.int
        tempCreditData.monthly_payment = viewModel.monthPayment.int
        
        creditOrder?.creditDatas[.anorbank] = tempCreditData
        
        if creditOrder?.creditType == .anorbank {
            isReady?.send(true)
        }
    }
    
}

//MARK: - payment Information
extension AnorbankCreditStoreRoom {
    
    func drawPaymentsSection() {
        paymentInfoContainer.subviews.forEach { $0.removeFromSuperview() }
        for payment in payments {
            let item = getPaymentItem(type: payment)
            paymentInfoContainer.addArrangedSubview(item)
        }
    }
    
    func getPaymentItem(type: PaymentType) -> UIStackView {
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 2
        let titleLabel = UILabel()
        
        titleLabel.textColor = .olchaLightTextColornnnnnn
        titleLabel.text = type.rawValue.localized()
        titleLabel.style(.medium, 14)
        
        let valueLabel = UILabel()
        valueLabel.textColor = .olchaTextBlack
        
        valueLabel.style(.bold, 16)
        
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(valueLabel)
        
        switch type {
        case .permonth:
            permonthLabel = valueLabel
            break
        case .overall:
            overallLabel = valueLabel
            break
        }
        
        return stack
    }

    
}
