import UIKit
import OlchaUI
import OlchaUtils
import OlchaCommon
import SnapKit

public protocol NotificationCard: BaseView {
    var cardTappedObserver: ((ClickAction?) -> Void)? { get set }
    var closeCardObserver: (() -> Void)? { get set }
    var model: CommonNotificationModel? { get set }
}

public final class NotificationCardView: BaseView, NotificationCard {
    
    public var cardTappedObserver: ((ClickAction?) -> Void)?
    public var closeCardObserver: (() -> Void)?
    public var model: CommonNotificationModel?
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.round(8)
        imageView.backgroundColor = .hex("#F3F3F3")
        return imageView
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.round()
        view.shadowAdd(
            offset: .init(width: 0, height: 2),
            color: .hex("#CCCCCC"),
            opacity: 0.25,
            radius: 12
        )
        view.backgroundColor = .white
        return view
    }()
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 12
        return stack
    }()
    
    private let labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private let rightStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let closeButton: IconButton = {
        let button = IconButton()
        button.setIcon(.x, edgeSize: 0)
        return button
    }()
    
    private let statusView: LabelView = {
        let labelView = LabelView()
        labelView.round(8)
        labelView.horizontalEdge = 8
        labelView.settings.textColor = .white
        labelView.settings.text = "Доставляется"
        labelView.settings.style(.medium, 10)
        labelView.backgroundColor = .olchaGreen
        return labelView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 14)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textColor = .olchaBlackNeutral
        label.text = "Apple iPhone 12 Pro"
        return label
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 11)
        label.textColor = .olchaLightTextColornnnnnn
        label.text = "ID: 104940"
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 13)
        label.textColor = .olchaInfoColor
        label.text = "13 350 000 cум"
        return label
    }()
    
    public override func setupViews() {
        addSubview(container)
        container.addSubview(contentStack)
        contentStack.addArrangedSubview(productImageView)
        contentStack.addArrangedSubview(labelStack)
        contentStack.addArrangedSubview(rightStack)
        labelStack.addArrangedSubview(titleLabel)
        labelStack.addArrangedSubview(idLabel)
        labelStack.addArrangedSubview(priceLabel)
        rightStack.addArrangedSubview(closeButton)
        rightStack.addArrangedSubview(statusView)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(82)
        }
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        productImageView.snp.makeConstraints { make in
            make.width.equalTo(66)
            make.height.equalTo(56)
        }
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        statusView.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
    }
    
    public override func configureViews() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        addGestureRecognizer(tapGesture)
        closeButton.clicked { [weak self] in
            guard let self else { return }
            closeCardObserver?()
        }
    }
    
    public func setup(with model: CommonNotificationModel) {
        self.model = model
        titleLabel.text = model.title
        priceLabel.text = model.price?.string.originalPriceDouble
        idLabel.text = "ID: \(model.click_action?.click_action_id ?? "-")"
        productImageView.load(from: model.image)
        statusView.settings.text = model.status
        if let color = model.status_color {
            statusView.backgroundColor = .hex(color)
        } else {
            statusView.backgroundColor = .olchaLightTextColornnnnnn
        }
    }
    
    @objc private func cardTapped() {
        cardTappedObserver?(model?.click_action?.getAction())
    }
    
}
