//
//  CreditStoreRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 26/07/22.
//

import UIKit
import Combine
import OlchaUI
import OlchaUtils

class OlchaCreditStoreRoom: BaseTableCell {

    enum PaymentType: String {
        case permonth = "permonth_payment"
        case overall = "overall_payment"
    }
    
    private let stackContainerBackground = UIView()
    let staticSection = UIView()
    let stackContainer = UIStackView()
    let checkRound = IconButton()
    let icon = UIImageView()
    let dataSection = UIView()
    let slider = MonthSlider()
    let expandeButton = IconButton()
    
    let paymentInfoContainer = UIStackView()
    let limitLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 12)
        label.textColor = .olchaLightTextColornnnnnn
        return label
    }()
    let hintInfoIcon = IconButton()
    let hintInfoTitle = UILabel()

    var permonthLabel: UILabel?
    var overallLabel: UILabel?
    let errorLabel = UILabel()

    //MARK: Bottom sections
    let paymentFieldBottomSection = UIView()
    let separator = Divide()
    let firstPaymentField = TField()
    
    
    var bag = Set<AnyCancellable>()
    
    var products: [ProductModel] = []
    
    var viewModel = CreditViewModel()
    
    weak var creditOrder: CreditOrder?
    
    weak var limitBalance: Balance?
    
    private var tempCreditData: CartCreditData?
    
    let payments: [PaymentType] = [
//        .permonth,
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
    weak var graphObserver: CurrentValueSubject<[String: InstallmentInfo], Never>?
    weak var observers: CartObservers?

    override func setupViews() {
        container.addSubview(stackContainerBackground)
        stackContainerBackground.addSubview(stackContainer)
        stackContainer.addArrangedSubview(staticSection)
        stackContainer.addArrangedSubview(paymentFieldBottomSection)
        
        staticSection.addSubview(dataSection)
        
        dataSection.addSubview(slider)
        dataSection.addSubview(paymentInfoContainer)
        dataSection.addSubview(hintInfoIcon)
        dataSection.addSubview(hintInfoTitle)
        
        
        paymentFieldBottomSection.addSubview(separator)
        paymentFieldBottomSection.addSubview(firstPaymentField)
        paymentFieldBottomSection.addSubview(errorLabel)
    }
    
    override func autolayout() {
        stackContainerBackground.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        stackContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        dataSection.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
        
        slider.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        paymentInfoContainer.snp.makeConstraints { make in
            make.top.equalTo(slider.snp.bottom)
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
            make.bottom.equalToSuperview()
        }
      
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
        
        firstPaymentField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(separator.snp.bottom).inset(-16)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(firstPaymentField.snp.bottom).inset(-8)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        checkRound.isUserInteractionEnabled = false
        self.isChosen = false
        self.isExpande = false
        stackContainer.axis = .vertical
        
        icon.image = .olchaIcon
        expandeButton.setIcon(.large_shrinked)
        
        
        paymentInfoContainer.axis = .vertical
        paymentInfoContainer.spacing = 4
        hintInfoIcon.setIcon(.info?.withColor(.olchaLightTextColornnnnnn ?? .lightGray))
        hintInfoTitle.style(.regular, 12)
        hintInfoTitle.textColor = .olchaLightTextColornnnnnn
        
        errorLabel.style(.medium, 12)
        errorLabel.textColor = .olchaAccentColor
        errorLabel.isHidden = true
        errorLabel.text = "initial_pay".localized() + " " + self.viewModel.minInitialPayment.int.string.price
        
        firstPaymentField.type = .amountWithoutRange
        firstPaymentField.topHint = "first_payment".localized()
        
        stackContainerBackground.round()
        setupObservers()
        stackContainerBackground.clipsToBounds = true
        
        
        setHighContent(view: errorLabel)
    }
    
    private func setHighContent(view: UIView) {
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
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
        viewModel.coupon = observers?.coupon?.value?.double ?? 0
        viewModel.bonus = (observers?.isBonusUsing ?? false) ? (observers?.bonus?.usingBonus?.double ?? 0) : 0
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
extension OlchaCreditStoreRoom: SliderViewDelegate {
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
extension OlchaCreditStoreRoom {
    
    func drawPaymentsSection() {
        paymentInfoContainer.subviews.forEach { $0.removeFromSuperview() }
        for payment in payments {
            let item = getPaymentItem(type: payment)
            paymentInfoContainer.addArrangedSubview(item)
        }
        
        if let limitBalance = limitBalance, (limitBalance.amount ?? 0) > 0 {
            if let lastView = paymentInfoContainer.arrangedSubviews.last {
                paymentInfoContainer.setCustomSpacing(8, after: lastView)
            }
            paymentInfoContainer.addArrangedSubview(limitLabel)
            setupLimitLabel()
        }
    }
    
    private func setupLimitLabel() {
        let limitTitle = NSAttributedString(string: "limit_balance".localized() + " ", attributes: [
            NSAttributedString.Key.font: UIFont.style(.medium, 14),
            NSAttributedString.Key.foregroundColor: UIColor.olchaLightTextColornnnnnn])
        
        let limitValue = NSAttributedString(string: limitBalance?.amount?.string.originalPrice ?? "", attributes: [
            NSAttributedString.Key.font: UIFont.style(.semibold, 14),
            NSAttributedString.Key.foregroundColor: UIColor.olchaLightTextColornnnnnn])
        
        let finalText = NSMutableAttributedString()
        finalText.append(limitTitle)
        finalText.append(limitValue)
        
        limitLabel.attributedText = finalText
        limitLabel.numberOfLines = 0
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
