import UIKit
import OlchaUI
import OlchaUtils
import SnapKit

class ProductExternalInstallmentRoom: BaseTableCell {

    private let containerBackground = UIView()
    private let logoImageView = UIImageView()

    private let infoStack = UIStackView()
    private let monthlyLabel = UILabel()
    private let totalLabel: UILabel = {
        let l = UILabel()
        l.style(.regular, 13)
        l.textColor = .olchaLightTextColornnnnnn
        return l
    }()

    private let checkIcon = IconButton()

    var isChosen: Bool = false {
        didSet {
            checkIcon.isHidden = !isChosen
            containerBackground.darkBorder(with: isChosen ? .olchaAccentColor : .olchaLightNeutralGray)
        }
    }

    override func setupViews() {
        container.addSubview(containerBackground)
        containerBackground.addSubview(logoImageView)
        containerBackground.addSubview(infoStack)
        containerBackground.addSubview(checkIcon)
        infoStack.addArrangedSubview(monthlyLabel)
        infoStack.addArrangedSubview(totalLabel)
    }

    override func autolayout() {
        containerBackground.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.left.right.equalToSuperview().inset(16)
        }

        logoImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(40)
        }

        checkIcon.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }

        infoStack.snp.makeConstraints { make in
            make.left.equalTo(logoImageView.snp.right).offset(12)
            make.right.equalTo(checkIcon.snp.left).offset(-8)
            make.top.bottom.equalToSuperview().inset(14)
        }
    }

    override func configureViews() {
        containerBackground.round()
        containerBackground.clipsToBounds = true

        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true

        infoStack.axis = .vertical
        infoStack.spacing = 4

        monthlyLabel.style(.bold, 15)
        monthlyLabel.textColor = .olchaAccentColor
        monthlyLabel.numberOfLines = 2

        checkIcon.setIcon(.round_selected_check)
        checkIcon.isUserInteractionEnabled = false
        checkIcon.isHidden = true

        isChosen = false
    }

    func setup(provider: ExternalInstallmentProvider, totalPrice: Double, period: Int) {
        logoImageView.load(from: provider.logoUrl, withIndicator: false, imageType: .ignoreResize, withPlaceholder: false)

        let effectivePeriod = period > 0 ? period : (provider.sortedPeriods.first ?? provider.minPeriod)
        guard effectivePeriod > 0 else { return }

        let monthly = provider.monthlyPayment(totalPrice: totalPrice, period: effectivePeriod)
        let total = provider.totalPayment(totalPrice: totalPrice, period: effectivePeriod)

        monthlyLabel.text = monthly.int.string.price + " × \(effectivePeriod) " + "month_short".localized()
        totalLabel.text = "overall_payment".localized() + ": " + total.int.string.price
    }
}
