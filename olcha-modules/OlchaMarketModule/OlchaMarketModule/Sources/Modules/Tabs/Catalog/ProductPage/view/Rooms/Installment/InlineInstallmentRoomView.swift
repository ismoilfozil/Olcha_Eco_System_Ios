import UIKit
import OlchaUI
import OlchaUtils
import SnapKit

class InlineInstallmentRoomView: BaseTableCellView {

    private let titleLabel = UILabel()

    private let periodsScrollView = UIScrollView()
    private let periodsStack = UIStackView()

    private let providersStack = UIStackView()

    private let buyButton = OlchaButton()

    private var chipButtons: [UIButton] = []
    private var chipBadges: [UILabel?] = []
    private var providerCards: [InstallmentProviderCard] = []

    private var product: ProductModel?
    private var providers: [ExternalInstallmentProvider] = []
    private var selectedPeriod: Int = 0
    private var selectedOfferID: String?
    private let olchaInstallmentMinPeriod = 3
    private let olchaInstallmentMaxPeriod = 12

    var onBuyTapped: (() -> Void)?
    
    private struct InstallmentOffer {
        let id: String
        let logoSource: InstallmentProviderCard.LogoSource
        let monthly: Double
        let total: Double
    }

    override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(periodsScrollView)
        periodsScrollView.addSubview(periodsStack)
        container.addSubview(providersStack)
        container.addSubview(buyButton)
    }

    override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(16)
        }

        periodsScrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(38)
        }

        periodsStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }

        providersStack.snp.makeConstraints { make in
            make.top.equalTo(periodsScrollView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }

        buyButton.snp.makeConstraints { make in
            make.top.equalTo(providersStack.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
    }

    override func configureViews() {
        titleLabel.style(.bold, 18)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.textAlignment = .center
        titleLabel.text = "installment_buy".localized()

        periodsScrollView.showsHorizontalScrollIndicator = false
        periodsScrollView.showsVerticalScrollIndicator = false

        periodsStack.axis = .horizontal
        periodsStack.spacing = 8
        periodsStack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        periodsStack.isLayoutMarginsRelativeArrangement = true

        providersStack.axis = .vertical
        providersStack.spacing = 12

        buyButton.setTitle("buy_credit".localized())
        buyButton.clicked { [weak self] in
            self?.onBuyTapped?()
        }
    }

    func setup(product: ProductModel?, providers: [ExternalInstallmentProvider]) {
        self.product = product
        self.providers = providers

        let periodsWithCounts = buildPeriodsWithCounts(product: product, providers: providers)

        guard !periodsWithCounts.isEmpty else {
            isHidden = true
            return
        }

        isHidden = false

        let allPeriods = periodsWithCounts.map { $0.period }
        if selectedPeriod == 0 || !allPeriods.contains(selectedPeriod) {
            selectedPeriod = allPeriods.first ?? 0
        }

        buildChips(periodsWithCounts: periodsWithCounts)
        buildProviderCards()
    }

    private func buildPeriodsWithCounts(
        product: ProductModel?,
        providers: [ExternalInstallmentProvider]
    ) -> [(period: Int, count: Int)] {
        var counts: [Int: Int] = [:]

        if product?.plan != nil {
            (olchaInstallmentMinPeriod...olchaInstallmentMaxPeriod).forEach { counts[$0, default: 0] += 1 }
        }

        for provider in providers {
            for p in provider.sortedPeriods {
                counts[p, default: 0] += 1
            }
        }

        return counts.map { (period: $0.key, count: $0.value) }.sorted { $0.period > $1.period }
    }

    private func buildChips(periodsWithCounts: [(period: Int, count: Int)]) {
        chipButtons.forEach { $0.superview?.removeFromSuperview() }
        chipButtons.removeAll()
        chipBadges.removeAll()
        periodsStack.arrangedSubviews.forEach {
            periodsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        for item in periodsWithCounts {
            let (wrapper, btn, badge) = makePeriodChipView(period: item.period, count: item.count)
            periodsStack.addArrangedSubview(wrapper)
            chipButtons.append(btn)
            chipBadges.append(badge)
        }

        updateChipSelection()
    }

    private func makePeriodChipView(period: Int, count: Int) -> (UIView, UIButton, UILabel?) {
        let wrapper = UIView()
        wrapper.clipsToBounds = false

        let btn = UIButton(type: .custom)
        btn.setTitle("\(period) " + "month_short".localized(), for: .normal)
        btn.titleLabel?.font = UIFont.style(.medium, 14)
        btn.layer.cornerRadius = 19
        btn.layer.borderWidth = 1.5
        btn.clipsToBounds = true
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        btn.tag = period
        btn.addTarget(self, action: #selector(chipTapped(_:)), for: .touchUpInside)

        wrapper.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
            make.right.equalToSuperview().inset(count > 1 ? 6 : 0)
            make.height.equalTo(38)
        }
        wrapper.snp.makeConstraints { $0.height.equalTo(46) }

        var badge: UILabel? = nil
        if count > 1 {
            let b = UILabel()
            b.text = "\(count)"
            b.font = UIFont.style(.bold, 10)
            b.textColor = .white
            b.textAlignment = .center
            b.backgroundColor = .olchaTextBlack
            b.layer.cornerRadius = 9
            b.clipsToBounds = true
            wrapper.addSubview(b)
            b.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.right.equalToSuperview()
                make.width.height.equalTo(18)
            }
            badge = b
        }

        return (wrapper, btn, badge)
    }

    private func updateChipSelection() {
        for (index, btn) in chipButtons.enumerated() {
            let isSelected = btn.tag == selectedPeriod
            btn.backgroundColor = isSelected ? .olchaAccentColor : .olchaWhite
            btn.setTitleColor(isSelected ? .white : .olchaTextBlack, for: .normal)
            btn.layer.borderColor = isSelected
                ? UIColor.olchaAccentColor.cgColor
                : (UIColor.olchaLightNeutralGray?.cgColor ?? UIColor.lightGray.cgColor)

            if let badge = chipBadges[index] {
                badge.backgroundColor = isSelected ? .white : .olchaTextBlack
                badge.textColor = isSelected ? .olchaAccentColor : .white
            }
        }
    }

    @objc private func chipTapped(_ sender: UIButton) {
        selectedPeriod = sender.tag
        selectedOfferID = nil
        updateChipSelection()
        rebuildProviderCards()
    }

    private func buildProviderCards() {
        selectedOfferID = nil
        rebuildProviderCards()
    }
    
    private func rebuildProviderCards() {
        providerCards.forEach { card in
            providersStack.removeArrangedSubview(card)
            card.removeFromSuperview()
        }
        providerCards.removeAll()
        
        let offers = sortedOffers()
        let selectedID = selectedOfferID.flatMap { id in
            offers.contains(where: { $0.id == id }) ? id : nil
        } ?? offers.first?.id
        selectedOfferID = selectedID
        
        for offer in offers {
            let card = InstallmentProviderCard()
            card.offerID = offer.id
            card.logoSource = offer.logoSource
            card.update(monthly: offer.monthly, total: offer.total, period: selectedPeriod)
            card.isChosen = offer.id == selectedID
            providersStack.addArrangedSubview(card)
            providerCards.append(card)

            card.onTap = { [weak self] in
                guard let self else { return }
                self.selectedOfferID = offer.id
                self.updateCardSelection()
            }
        }
    }

    private func sortedOffers() -> [InstallmentOffer] {
        let totalPrice = product?.total_price?.double ?? 0
        var olchaOffer: InstallmentOffer?
        var externalOffers: [InstallmentOffer] = []
        
        if let plan = product?.plan {
            let inRange = isOlchaInstallmentPeriod(selectedPeriod)
            if inRange {
                let margin = plan.margin?.double ?? 0
                let monthly = totalPrice * (1.0 + margin / 100.0) / Double(max(selectedPeriod, 1))
                let total = totalPrice * (1.0 + margin / 100.0)
                olchaOffer = InstallmentOffer(
                    id: "olcha",
                    logoSource: .image(.olchaIcon),
                    monthly: monthly,
                    total: total
                )
            }
        }
        
        for provider in providers {
            guard provider.sortedPeriods.contains(selectedPeriod) else { continue }
            let monthly = provider.monthlyPayment(totalPrice: totalPrice, period: selectedPeriod)
            let total = provider.totalPayment(totalPrice: totalPrice, period: selectedPeriod)
            externalOffers.append(
                InstallmentOffer(
                    id: provider.alias,
                    logoSource: .url(provider.logoUrl),
                    monthly: monthly,
                    total: total
                )
            )
        }
        
        externalOffers.sort {
            if $0.monthly == $1.monthly { return $0.total < $1.total }
            return $0.monthly < $1.monthly
        }
        
        if let olchaOffer {
            return [olchaOffer] + externalOffers
        }
        return externalOffers
    }

    private func updateCardSelection() {
        for card in providerCards {
            card.isChosen = card.offerID == selectedOfferID
        }
    }
    
    private func isOlchaInstallmentPeriod(_ period: Int) -> Bool {
        period >= olchaInstallmentMinPeriod && period <= olchaInstallmentMaxPeriod
    }
}

// MARK: - InstallmentProviderCard

class InstallmentProviderCard: UIView {

    enum LogoSource {
        case image(UIImage?)
        case url(String)
    }

    var logoSource: LogoSource = .image(nil) {
        didSet { applyLogoSource() }
    }
    
    var offerID: String?

    var isChosen: Bool = false {
        didSet { updateStyle() }
    }

    var onTap: (() -> Void)?

    private let containerBG = UIView()
    private let logoImageView = UIImageView()
    private let infoStack = UIStackView()
    private let monthlyLabel = UILabel()
    private let totalLabel = UILabel()
    private let checkIcon = UIImageView()
    private let tapButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(containerBG)
        containerBG.addSubview(logoImageView)
        containerBG.addSubview(infoStack)
        containerBG.addSubview(checkIcon)
        containerBG.addSubview(tapButton)
        infoStack.addArrangedSubview(monthlyLabel)
        infoStack.addArrangedSubview(totalLabel)

        containerBG.snp.makeConstraints { $0.edges.equalToSuperview() }

        logoImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(88)
            make.height.equalTo(44)
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

        tapButton.snp.makeConstraints { $0.edges.equalToSuperview() }

        containerBG.layer.cornerRadius = 12
        containerBG.layer.borderWidth = 1.5
        containerBG.clipsToBounds = true

        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true

        infoStack.axis = .vertical
        infoStack.spacing = 4

        monthlyLabel.style(.bold, 15)
        monthlyLabel.textColor = .olchaAccentColor
        monthlyLabel.numberOfLines = 2

        totalLabel.style(.regular, 13)
        totalLabel.textColor = .olchaLightTextColornnnnnn
        totalLabel.numberOfLines = 1

        checkIcon.image = UIImage(systemName: "checkmark.circle.fill")
        checkIcon.tintColor = .olchaAccentColor
        checkIcon.contentMode = .scaleAspectFit
        checkIcon.isHidden = true

        tapButton.backgroundColor = .clear
        tapButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)

        updateStyle()
    }

    private func applyLogoSource() {
        switch logoSource {
        case .image(let img):
            logoImageView.image = img
        case .url(let urlString):
            logoImageView.load(from: urlString, withIndicator: false, imageType: .ignoreResize, withPlaceholder: false)
        }
    }

    private func updateStyle() {
        if isChosen {
            containerBG.backgroundColor = UIColor.olchaAccentColor.withAlphaComponent(0.06)
            containerBG.layer.borderColor = UIColor.olchaAccentColor.cgColor
        } else {
            containerBG.backgroundColor = .olchaWhite
            containerBG.layer.borderColor = UIColor.olchaLightNeutralGray?.cgColor ?? UIColor.lightGray.cgColor
        }
        checkIcon.isHidden = !isChosen
    }

    func update(monthly: Double, total: Double, period: Int) {
        monthlyLabel.text = monthly.int.string.price + " × \(period) " + "month_short".localized()
        totalLabel.text = "overall_payment".localized() + ": " + total.int.string.price
    }

    @objc private func tapped() {
        onTap?()
    }
}
