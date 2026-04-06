//
//  FoundOrderPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 26/12/22.
//
import OlchaUI
import UIKit
import Combine
class FoundOrderPage: BaseViewController {
    private var bag = Set<AnyCancellable>()
    
    private let scrollView = UIScrollView()
    
    private let scrollContainer = UIView()
    
    private let cardContainer = UIView()
    
    private let orderNumberLabel = UILabel()
    
    private let productsTitle = UILabel()
    
    private let productsTable = BaseTableView()
    
    private let separator = Divide()
    
    private let infoTitle = UILabel()
    
    private let infoStack = UIStackView()
    
    private let homeButton = OlchaButton()
    
    private let subtitleLabel = UILabel()
    
    private let orderStatusButton = RightIconButton()
    
    var order: Order?
    
    var products: [ProductModel] = [] {
        didSet {
            updateLayout()
        }
    }
    
    let dotsSize: CGFloat = 20
    
    let pinSize: CGFloat = 12
    
    let margin: CGFloat = 16
    
    weak var coordinator: ProfileCoordinatorProtocol?
    
    let productHelper = ProductHelper()
    
    override func setupViews() {
        container.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        scrollContainer.addSubview(cardContainer)
        cardContainer.addSubview(orderNumberLabel)
        cardContainer.addSubview(orderStatusButton)
        cardContainer.addSubview(separator)
        cardContainer.addSubview(productsTitle)
        cardContainer.addSubview(productsTable)
        cardContainer.addSubview(infoTitle)
        cardContainer.addSubview(infoStack)
        scrollContainer.addSubview(homeButton)
        scrollContainer.addSubview(subtitleLabel)
    }
    
    override func autolayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.width.equalTo(container.snp.width)
        }
        
        cardContainer.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(16)
        }
        
        orderNumberLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
        }
        
        orderStatusButton.snp.makeConstraints { make in
            make.centerY.equalTo(orderNumberLabel.snp.centerY)
            make.left.equalTo(orderNumberLabel.snp.right).inset(-16)
            make.height.equalTo(28)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(orderStatusButton.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        productsTitle.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        productsTable.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(0)
            make.top.equalTo(productsTitle.snp.bottom)
        }
        
        infoTitle.snp.makeConstraints { make in
            make.top.equalTo(productsTable.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        infoStack.snp.makeConstraints { make in
            make.top.equalTo(infoTitle.snp.bottom).inset(-16)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
        
        homeButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(cardContainer.snp.bottom).inset(-16)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(homeButton.snp.bottom).inset(-16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        navigation.setTitle("follow_order".localized())
        navigation.configure(style: .back)
        
        container.backgroundColor = .lightGrayBackground
        cardContainer.backgroundColor = .olchaBackgroundColor
        cardContainer.round()
        
        orderNumberLabel.style(.bold, 22)
        orderNumberLabel.textColor = .olchaTextBlack
        orderNumberLabel.text = "#"
        
        
        productsTitle.style(.bold, 22)
        productsTitle.textColor = .olchaTextBlack
        productsTitle.text = "order_list".localized()
        productsTable.delegate = self
        productsTable.dataSource = self
        productsTable.configure()
        productsTable.registerClass(forCell: OrderProductRoom.self)
        productsTable.isScrollEnabled = false
        
        infoTitle.style(.bold, 22)
        infoTitle.textColor = .olchaTextBlack
        infoTitle.text = "more_info".localized()
        
        
        infoStack.axis = .vertical
        infoStack.spacing = 16
        
        homeButton.setTitle("to_home".localized())
        configureSubtitleLabel()
        
        
        fillInfo()
        
        
        orderStatusButton.backgroundColor = .olchaAccentColor
        orderStatusButton.round()
        
        orderStatusButton.buttonTitle.style(.medium, 14)
        orderStatusButton.buttonTitle.textColor = .olchaWhite
        
    }
    
    private func updateLayout() {
        productsTable.reloadData()
        productsTable.snp.updateConstraints { make in
            make.height.equalTo(MyOrderRoom.cellHeight * products.count.cgfloat)
        }
    }
    
    private func fillInfo() {
        
        orderNumberLabel.text = "#\(order?.id ?? 0)"
        
        infoStack.addArrangedSubview(
            getInfoView(title: "order_date".localized(),
                        value: order?.created_at)
        )
        
        infoStack.addArrangedSubview(
            getInfoView(title: "contact_data".localized(), value: order?.name)
        )
        
        infoStack.addArrangedSubview(
            getInfoView(title: "overall_payment".localized(), value: order?.total_price_all?.string.originalPrice)
        )
        
        orderStatusButton.configure(image: .info?.withColor(.olchaWhite),
                                    title: (order?.getStatusTitle() ?? " - "),
                                    size: 20,
                                    padding: 12)
        orderStatusButton.backgroundColor = order?.getStatusColor()
    }
    
    override func setupObservers() {
        homeButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.tabBarController?.selectedIndex = OlchaTab.home
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        orderStatusButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            
            self.coordinator?.presentOrdersStep(
                steps: self.order?.getHistories() ?? []
            )
            
        }
        
        productHelper
            .pushProduct
            .sink { [weak self] data in
                guard let self = self else { return }
                self.coordinator?.pushProduct(product: data)
            }.store(in: &bag)
    }
    
    override func initialRequest() {
        
        products = order?.products ?? []
        
    }
    
}

private extension FoundOrderPage {
    
    func getInfoView(title: String?, value: String?) -> UIStackView {
        let stackView = UIStackView()
        let titleLabel = UILabel()
        
        titleLabel.text = title ?? " - "
        titleLabel.style(.medium, 14)
        titleLabel.textColor = .olchaLightTextColornnnnnn
        
       
        let valueLabel = UILabel()
        
        valueLabel.text = value ?? " - "
        valueLabel.style(.medium, 14)
        valueLabel.textColor = .olchaTextBlack
        valueLabel.textAlignment = .right
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .firstBaseline
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueLabel)
        
        return stackView
    }
    
    func configureSubtitleLabel() {
        let privacyText = "help_number".localized()
        
        let textAttributes:[NSAttributedString.Key : Any] = [
            .font: UIFont.style(.medium, 14),
            .foregroundColor: UIColor.olchaLightTextColornnnnnn]
        
        let rangeTextAttributes:[NSAttributedString.Key : Any] = [
            .font: UIFont.style(.medium, 14),
            .foregroundColor: UIColor.olchaGreen]
        
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        
        subtitleLabel.isUserInteractionEnabled = true
        
        subtitleLabel.addTapGesture(text: privacyText,
                                    textAttributes: textAttributes,
                                    tapOnText: MarketTexts.olcha_phone,
                                    tapOnTextAttributes: rangeTextAttributes) {
            Funcs.openPhone()
        }
        
    }
}
