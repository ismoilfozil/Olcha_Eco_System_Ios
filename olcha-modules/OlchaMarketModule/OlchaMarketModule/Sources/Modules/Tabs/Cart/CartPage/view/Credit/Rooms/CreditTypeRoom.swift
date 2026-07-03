//
//  CreditTypeRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 22/02/23.
//

import UIKit
import Combine
import OlchaUI
class CreditTypeRoom: BaseTableCell {
    
    enum PaymentType: String {
        case permonth = "permonth_payment"
        case overall = "overall_payment"
    }
    
    let checkRound = IconButton()
    let icon = UIImageView()
    let stackContainer = UIStackView()
    
    let slider = MonthSlider()
    let paymentInfoContainer = UIStackView()
    
    let staticSection = UIView()
    private let stackContainerBackground = UIView()
    
    let hintInfoContainer = UIView()
    let hintInfoIcon = IconButton()
    let hintInfoTitle = UILabel()
    
    let separator = Divide()
    let firstPaymentField = TField()
    let bottomInfoTitle = UILabel()
    let bottomInfoButton = Button()
    
//    let dataSection = UIView()
//
//    let expandeButton = IconButton()
    
    
    var permonthLabel: UILabel?
    var overallLabel: UILabel?
    let errorLabel = UILabel()
    
    //MARK: Bottom sections
    let paymentFieldBottomSection = UIView()
    
    var bag = Set<AnyCancellable>()
    
    var products: [ProductModel] = []
    
    var viewModel = CreditViewModel()
    
    weak var creditOrder: CreditOrder?
    
    private var tempCreditData: CartCreditData?
    
    let payments: [PaymentType] = [
        .permonth,
        .overall
    ]
    
    var isExpande = false {
        didSet {
            expandeCheck()
        }
    }
    
    var isChosen: Bool = false {
        didSet {
            isChosen ? selectedStyle() : unselectedStyle()
        }
    }
    
    weak var isReady: PassthroughSubject<Bool, Never>?
    
    override func setupViews() {
        container.addSubview(checkRound)
        container.addSubview(icon)
        container.addSubview(stackContainer)
        
        stackContainer.addArrangedSubview(slider)
        stackContainer.addArrangedSubview(paymentInfoContainer)
        stackContainer.addArrangedSubview(separator)
        stackContainer.addArrangedSubview(firstPaymentField)
        stackContainer.addArrangedSubview(bottomInfoTitle)
        stackContainer.addArrangedSubview(bottomInfoButton)
    }
    
    override func autolayout() {
        horizontalEdge = 8
        verticalEdge = 8
        
        checkRound.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
        
        icon.snp.makeConstraints { make in
            make.centerX.equalTo(checkRound.snp.centerX)
            make.left.equalTo(checkRound.snp.right).inset(-16)
        }
        
        stackContainer.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).inset(-24)
            make.left.right.bottom.equalToSuperview()
        }
        
        slider.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
        paymentInfoContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
        firstPaymentField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
        
    }
    
    override func configureViews() {
        checkRound.isUserInteractionEnabled = false
        stackContainer.axis = .vertical
        stackContainer.setCustomSpacing(12, after: slider)
        paymentInfoContainer.axis = .vertical
        hintInfoIcon.setIcon(.info?.withColor(.olchaOrange ?? .orange))
        hintInfoTitle.style(.regular, 12)
        hintInfoTitle.textColor = .olchaOrange
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
    
    func setup(with data: [ProductModel], credit: CreditTypeModel) {
        products = data
        
        drawPaymentsSection()
        
        viewModel.calculateStatics(products: data)
        
        slider.setup(min: viewModel.minMonth,
                     max: viewModel.maxMonth,
                     delegate: self)
    }
    
    func setupTempData() {
        
        if let creditData = creditOrder?.creditDatas[.olcha] {
            tempCreditData = creditData
            viewModel.month = viewModel.getTrueMonth(month: creditData.inst_pay_time)
            viewModel.initialPayment = viewModel.getTrueInitialPayment(payment: creditData.first_fee_sum.double)
        } else {
            tempCreditData = .init()
        }
        
        slider.forcedStep = viewModel.month
        valueChanged(month: viewModel.month)
        firstPaymentField.settings.text = viewModel.initialPayment.int.string.priceWithoutCurrency
        
        updateData()
    }
    
}

//MARK: -  ACTIONS
extension CreditTypeRoom: SliderViewDelegate {
    func valueChanged(month: Int) {
        viewModel.month = month
        viewModel.calculate(products: products)
        updateData()
    }
    
    func expandeCheck() {
        isExpande ? shrink() : expande()
    }
    
    func shrink() {
        paymentFieldBottomSection.isHidden = true
    }
    
    func expande() {
        paymentFieldBottomSection.isHidden = false
    }
    
    func updateData() {
        guard let tempCreditData = tempCreditData else { return }
        
        tempCreditData.inst_pay_time = viewModel.month
        tempCreditData.first_fee_sum = viewModel.initialPayment.int
        tempCreditData.monthly_payment = viewModel.monthPayment.int
        
        creditOrder?.creditDatas[.olcha] = tempCreditData
    }
    
}

//MARK: - payment Information
extension CreditTypeRoom {
    
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

//    override func setupViews() {
//        addSubview(stackContainerBackground)
//        stackContainerBackground.addSubview(stackContainer)
//        stackContainer.addArrangedSubview(staticSection)
//        stackContainer.addArrangedSubview(paymentFieldBottomSection)
//
//        staticSection.addSubview(checkRound)
//        staticSection.addSubview(icon)
//        staticSection.addSubview(expandeButton)
//        staticSection.addSubview(dataSection)
//
//        dataSection.addSubview(slider)
//        dataSection.addSubview(paymentInfoContainer)
//        dataSection.addSubview(hintInfoIcon)
//        dataSection.addSubview(hintInfoTitle)
//
//
//        paymentFieldBottomSection.addSubview(separator)
//        paymentFieldBottomSection.addSubview(firstPaymentField)
//        paymentFieldBottomSection.addSubview(errorLabel)
        
        
//    }
    
//    override func autolayout() {
//        stackContainerBackground.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview().inset(8)
//            make.left.right.equalToSuperview().inset(16)
//        }
//
//        stackContainer.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//        checkRound.snp.makeConstraints { make in
//            make.top.left.equalToSuperview().inset(16)
//            make.width.height.equalTo(24)
//        }
//
//        icon.snp.makeConstraints { make in
//            make.left.equalTo(checkRound.snp.right).inset(-12)
//            make.top.equalTo(checkRound)
//            make.height.equalTo(24)
//        }
//
//        expandeButton.snp.makeConstraints { make in
//            make.width.height.equalTo(30)
//            make.right.top.equalToSuperview().inset(16)
//        }
//
//        dataSection.snp.makeConstraints { make in
//            make.top.equalTo(expandeButton.snp.bottom).inset(-16)
//            make.left.right.equalToSuperview()
//            make.bottom.equalToSuperview().inset(16)
//        }
//
//        slider.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.left.right.equalToSuperview().inset(16)
//        }
//
//        paymentInfoContainer.snp.makeConstraints { make in
//            make.top.equalTo(slider.snp.bottom)
//            make.left.right.equalToSuperview().inset(16)
//        }
//
//        hintInfoIcon.snp.makeConstraints { make in
//            make.top.equalTo(paymentInfoContainer.snp.bottom).inset(-8)
//            make.width.height.equalTo(16)
//            make.left.equalToSuperview().inset(16)
//            make.bottom.equalToSuperview()
//        }
//
//        hintInfoTitle.snp.makeConstraints { make in
//            make.top.equalTo(paymentInfoContainer.snp.bottom).inset(-8)
//            make.left.equalTo(hintInfoIcon.snp.right).inset(-4)
//            make.right.equalToSuperview().inset(16)
//            make.bottom.equalToSuperview()
//        }
//
//        separator.snp.makeConstraints { make in
//            make.left.right.equalToSuperview().inset(16)
//            make.top.equalToSuperview()
//        }
//
//        firstPaymentField.snp.makeConstraints { make in
//            make.left.right.equalToSuperview().inset(16)
//            make.top.equalTo(separator.snp.bottom).inset(-16)
//        }
//
//        errorLabel.snp.makeConstraints { make in
//            make.bottom.left.right.equalToSuperview().inset(16)
//            make.top.equalTo(firstPaymentField.snp.bottom).inset(-8)
//        }
//    }
    
//    override func configureViews() {
//        self.isChosen = false
//        self.isExpande = false
//        stackContainer.axis = .vertical
//
//
//
//        icon.image = .olchaIcon
//        expandeButton.setIcon(.large_shrinked)
//
//
//        paymentInfoContainer.axis = .vertical
//        paymentInfoContainer.spacing = 4
//        hintInfoIcon.setIcon(.info?.withColor(.olchaOrange ?? .orange))
//        hintInfoTitle.style(.regular, 12)
//        hintInfoTitle.textColor = .olchaOrange
//
//        errorLabel.style(.medium, 12)
//        errorLabel.textColor = .olchaAccentColor
//        errorLabel.isHidden = true
//        errorLabel.text = "initial_pay".localized() + " " + self.viewModel.minInitialPayment.int.string.price
//
//
//
//        firstPaymentField.withPhone = false
//        firstPaymentField.topHint = "first_payment".localized()
//        firstPaymentField.settings.keyboardType = .numberPad
//
//
//        firstPaymentField.isPrice = true
//        stackContainerBackground.round()
//        setupObservers()
//        stackContainerBackground.clipsToBounds = true
//    }
