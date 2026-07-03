import UIKit
import OlchaUI
import OlchaUtils
import SnapKit

class ExternalInstallmentStoreRoom: BaseTableCell {

    private let containerBackground = UIView()

    private let topRow = UIStackView()
    private let logoImageView = UIImageView()

    private let priceStack = UIStackView()
    private let permonthLabel: UILabel = {
        let l = UILabel()
        l.style(.regular, 12)
        l.textColor = .olchaLightTextColornnnnnn
        return l
    }()
    private let permonthValue: UILabel = {
        let l = UILabel()
        l.style(.bold, 18)
        l.textColor = .olchaAccentColor
        return l
    }()
    private let totalLabel: UILabel = {
        let l = UILabel()
        l.style(.regular, 12)
        l.textColor = .olchaLightTextColornnnnnn
        return l
    }()
    private let totalValue: UILabel = {
        let l = UILabel()
        l.style(.semibold, 15)
        l.textColor = .olchaTextBlack
        return l
    }()

    private let separator = Divide()
    private let bottomStack = UIStackView()
    private let slider = MonthSlider()
    private let infoLabel: UILabel = {
        let l = UILabel()
        l.style(.regular, 12)
        l.textColor = .olchaLightTextColornnnnnn
        l.numberOfLines = 3
        return l
    }()

    private let topTapButton = IButton()

    private var provider: ExternalInstallmentProvider?
    private var totalPrice: Double = 0
    private var selectedPeriod: Int = 0

    var isChosen: Bool = false {
        didSet {
            containerBackground.darkBorder(with: isChosen ? .olchaAccentColor : .olchaLightNeutralGray)
        }
    }

    var onSelected: (() -> Void)?
    var onPeriodChanged: ((Int) -> Void)?

    override func setupViews() {
        container.addSubview(containerBackground)

        containerBackground.addSubview(topRow)
        containerBackground.addSubview(separator)
        containerBackground.addSubview(bottomStack)
        containerBackground.addSubview(topTapButton)

        bottomStack.addArrangedSubview(slider)
        bottomStack.addArrangedSubview(infoLabel)

        priceStack.addArrangedSubview(permonthLabel)
        priceStack.addArrangedSubview(permonthValue)
        priceStack.addArrangedSubview(totalLabel)
        priceStack.addArrangedSubview(totalValue)

        topRow.addArrangedSubview(logoImageView)
        topRow.addArrangedSubview(priceStack)
    }

    override func autolayout() {
        containerBackground.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(16)
        }

        topRow.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.right.equalToSuperview().inset(16)
        }

        separator.snp.makeConstraints { make in
            make.top.equalTo(topRow.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
        }

        slider.snp.makeConstraints { make in
            make.height.equalTo(40)
        }

        bottomStack.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }

        topTapButton.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(separator.snp.bottom)
        }

        logoImageView.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(32)
        }
    }

    override func configureViews() {
        containerBackground.round()
        containerBackground.clipsToBounds = true

        topRow.axis = .horizontal
        topRow.spacing = 12
        topRow.alignment = .center
        topRow.distribution = .fill

        priceStack.axis = .vertical
        priceStack.spacing = 2
        priceStack.alignment = .trailing

        bottomStack.axis = .vertical
        bottomStack.spacing = 8

        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true

        isChosen = false

        permonthLabel.text = "permonth_payment".localized()
        totalLabel.text = "overall_payment".localized()

        topTapButton.clicked { [weak self] in
            guard let self else { return }
            self.onSelected?()
        }
    }

    func setup(provider: ExternalInstallmentProvider, totalPrice: Double, initialPeriod: Int? = nil) {
        self.provider = provider
        self.totalPrice = totalPrice

        logoImageView.load(from: provider.logoUrl, withIndicator: false, imageType: .ignoreResize, withPlaceholder: false)
        infoLabel.text = provider.infoText
        infoLabel.isHidden = (provider.infoText == nil || provider.infoText?.isEmpty == true)

        let periods = provider.sortedPeriods
        selectedPeriod = initialPeriod ?? periods.first ?? provider.minPeriod

        slider.setup(periods: periods, delegate: self)
        if let initial = initialPeriod, periods.contains(initial) {
            slider.forcedStep = initial
        }
        updatePrices()
    }

    private func updatePrices() {
        guard let provider else { return }
        let monthly = provider.monthlyPayment(totalPrice: totalPrice, period: selectedPeriod)
        let total = provider.totalPayment(totalPrice: totalPrice, period: selectedPeriod)
        permonthValue.text = monthly.int.string.price
        totalValue.text = total.int.string.price
    }
}

extension ExternalInstallmentStoreRoom: SliderViewDelegate {
    func valueChanged(month: Int) {
        selectedPeriod = month
        updatePrices()
        onPeriodChanged?(month)
    }
}
