//
//  PackagesDetailViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 24/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class PackagesDetailViewController: BaseViewController<TitleNavigationBar> {
    
    private lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.horizontalEdge()
        scrollView.settings.alwaysBounceVertical = true
        scrollView.container.spacing = 16
        scrollView.settings.showsVerticalScrollIndicator = false
        scrollView.settings.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 72, right: 0)
        return scrollView
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaInfoColor
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        return label
    }()
    
    private let boxStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let percentBox: RateBoxView = {
        let box = RateBoxView()
        box.setRateBoxGradient(.olchaLightOrangeGradient)
        box.setRateAmountLabelColor(.olchaOrange)
        box.setRateImage(image: .percentBoxLeftIcon)
        box.style = .right
        return box
    }()
    
    private let termBox: RateBoxView = {
        let box = RateBoxView()
        box.setRateBoxGradient(.olchaLightBlueGradient)
        box.setRateAmountLabelColor(.olchaInfoColor)
        box.setRateImage(image: .chartBoxLeftIcon)
        box.style = .right
        return box
    }()
    
    private let currencyBox: RateBoxView = {
        let box = RateBoxView()
        box.setRateBoxGradient(.olchaLightGreenGradient)
        box.setRateAmountLabelColor(.olchaGreen)
        box.setRateImage(image: .currencyBoxLeftIcon)
        box.style = .right
        return box
    }()
    
    private let warningView = InvestWarningView()
    
    private let additionalInfoLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        return label
    }()
    
    private let investButton: InvestOlchaButton = {
        let button = InvestOlchaButton()
        button.settings.setTitleColor(.lightGrayBackground, for: .normal)
        button.settings.titleLabel?.font = .style(.semibold, 16)
        button.round(10)
        return button
    }()
    
    public var input: Input
    public var output: Output
    public let viewModel: PackagesViewModel
    public weak var coordinator: PackagesCoordinatorProtocol?
    
    public init(
        input: Input = .init(),
        output: Output = .init(),
        viewModel: PackagesViewModel
    ) {
        self.input = input
        self.output = output
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(scrollView)
        container.addSubview(investButton)
        scrollView.settings.addSubview(refreshControl)
        scrollView.addArrangedSubview(idLabel)
        scrollView.addArrangedSubview(titleLabel)
        scrollView.addArrangedSubview(descriptionLabel)
        scrollView.addArrangedSubview(boxStack)
        boxStack.addArrangedSubview(percentBox)
        boxStack.addArrangedSubview(termBox)
        boxStack.addArrangedSubview(currencyBox)
        scrollView.addArrangedSubview(warningView)
        scrollView.addArrangedSubview(additionalInfoLabel)
    }
    
    public override func autolayout() {
        scrollView.container.setCustomSpacing(0, after: idLabel)
        scrollView.container.setCustomSpacing(20, after: descriptionLabel)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        boxStack.snp.makeConstraints({ $0.height.equalTo(120) })
        investButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
    }
    
    public override func configureViews() {
        languageUpdated()
        configureSkeleton()
    }
    
    public override func languageUpdated() {
        navigationBar.setTitle("package_title".localized(.olchaInvestCore))
        investButton.setTitle("package_invest_button".localized(.olchaInvestCore))
        warningView.setWarningText("package_warning_text".localized(.olchaInvestCore))
        percentBox.setRateLabelText("contract_percent".localized(.olchaInvestCore))
        termBox.setRateLabelText("contract_term".localized(.olchaInvestCore))
        currencyBox.setRateLabelText("package_currency".localized(.olchaInvestCore))
    }
    
    private func setup(with data: InvestmentModel) {
        navigationBar.setTitle(data.name)
        idLabel.text = "№\(data.id.orZero)"
        titleLabel.text = data.name
        setupDescription(label: descriptionLabel, text: data.description.unwrap)
        setupDescription(label: additionalInfoLabel, text: data.additional_info.unwrap, isAdditional: true)
        percentBox.setRateAmountLabelText("\(data.percent.orZero)%")
        let termString = String(format: "term_value".localized(.olchaInvestCore), data.term_info.unwrap)
        termBox.setRateAmountLabelText(termString)
        currencyBox.setRateAmountLabelText(data.unwrappedCurrency)
    }
    
    private func setupDescription(label: UILabel, text: String, isAdditional: Bool = false) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.style(.semibold, 14),
            .foregroundColor: UIColor.olchaTextBlack ?? .black
        ]
        let bodyAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.style(.regular, 14),
            .foregroundColor: UIColor.olchaTextBlack ?? .black
        ]
        let headingText = isAdditional ? "package_heading_additional".localized(.olchaInvestCore) : "package_heading_category".localized(.olchaInvestCore)
        let descriptionHeadingAttributedString = NSMutableAttributedString(string: "\(headingText)\n", attributes: attributes)
        let descriptionBodyAttributedString = NSMutableAttributedString(string: " \u{2022} \(text)", attributes: bodyAttributes)
        
        let descriptionAttributedString = descriptionHeadingAttributedString
        descriptionAttributedString.append(descriptionBodyAttributedString)
        
        label.attributedText = descriptionAttributedString
    }
    
    public override func initialRequest() {
        guard let investmentId = output.investmentId else { return }
        viewModel.loadPackage(id: investmentId)
    }
    
    public override func setupObservers() {
        handle(viewModel.$package) { [weak self] data in
            guard let self, let data else { return }
            input.package = data
            setup(with: data)
        } loading: { [weak self] isLoading in
            guard let self else { return }
            updateSkeleton(isLoading: isLoading)
        }
        investButton.clicked { [weak self] in
            guard let self, let investmentId = output.investmentId else { return }
            coordinator?.packageIdObserver.send(investmentId)
            coordinator?.pushSelectTermViewController(packageId: investmentId)
        }
    }
    
    public override func refreshList(_ sender: AnyObject) {
        input.reset()
        initialRequest()
        refreshControl.endRefreshing()
    }
    
    public func setInvestButtonHidden() {
        investButton.isHidden = true
    }
    
}

private extension PackagesDetailViewController {
    func configureSkeleton() {
        input.skeletonViews = [
            investButton,
            idLabel,
            titleLabel,
            descriptionLabel,
            boxStack,
            warningView,
            additionalInfoLabel
        ]
        input.skeletonViews.forEach({ $0.isSkeletonable = true })
        
        idLabel.skeletonConfiguration(
            lines: .custom(1),
            lastLinePercentage: 50,
            height: .relativeToConstraints
        )
        titleLabel.skeletonConfiguration(
            lines: .custom(2),
            lastLinePercentage: 80,
            height: .relativeToConstraints
        )
        descriptionLabel.skeletonConfiguration(
            lines: .custom(6),
            lastLinePercentage: 60,
            height: .relativeToConstraints
        )
        additionalInfoLabel.skeletonConfiguration(
            lines: .custom(8),
            lastLinePercentage: 60,
            height: .relativeToConstraints
        )
    }
    
    func updateSkeleton(isLoading: Bool = true) {
        input.skeletonViews.forEach({
            $0.layoutSkeletonIfNeeded()
            isLoading ? $0.showAnimatedGradientSkeleton() : $0.hideSkeleton()
        })
    }
}
