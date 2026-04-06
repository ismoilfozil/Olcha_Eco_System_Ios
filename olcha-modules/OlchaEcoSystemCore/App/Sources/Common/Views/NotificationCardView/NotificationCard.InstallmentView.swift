import UIKit
import OlchaUI
import OlchaCommon
import OlchaUtils
import SnapKit

public final class NotificationCardInstallmentView: BaseView, NotificationCard {
    
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
    
    private let contentView: UIView = {
        let stack = UIView()
        return stack
    }()
    
    private let labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private let closeButton: IconButton = {
        let button = IconButton()
        button.setIcon(.x, edgeSize: 0)
        return button
    }()
        
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 14)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textColor = .olchaBlackNeutral
        label.text = "Muddatli to’lov vaqti keldi"
        return label
    }()
    
    private let progressBar: PlainHorizontalProgressBar = {
        let bar = PlainHorizontalProgressBar()
        bar.color = .bonusProgressColor
        bar.maskColor = .hex("F2F2F2")
        bar.isPercentHidden = false
//        bar.progress = 100
        bar.fontSize = 10
        return bar
    }()
    
    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 11)
        label.textColor = .olchaTextBlack
        label.textAlignment = .right
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 13)
        label.textColor = .olchaInfoColor
        return label
    }()
    
    public override func setupViews() {
        addSubview(container)
        container.addSubview(contentView)
        contentView.addSubview(productImageView)
        contentView.addSubview(labelStack)
        contentView.addSubview(closeButton)
        labelStack.addArrangedSubview(titleLabel)
        labelStack.addArrangedSubview(priceLabel)
        contentView.addSubview(progressBar)
        contentView.addSubview(percentageLabel)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(82)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        productImageView.snp.makeConstraints { make in
            make.width.equalTo(66)
            make.height.equalTo(56)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(8)
        }
        
        labelStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.equalTo(productImageView.snp.right).inset(-12)
            make.right.equalTo(closeButton.snp.left).inset(-12)
            make.bottom.equalTo(progressBar.snp.top).inset(-8)
        }
        
        progressBar.snp.makeConstraints { make in
            make.left.equalTo(productImageView.snp.right).inset(-12)
            make.bottom.equalToSuperview().inset(8)
            make.height.equalTo(12)
        }
        
        percentageLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(12)
            make.centerY.equalTo(progressBar)
            make.left.equalTo(progressBar.snp.right).inset(-8)
            make.width.equalTo(30)
        }
        
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.right.top.equalToSuperview().inset(12)
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
        productImageView.load(from: model.image)
        
        progressBar.isHidden = model.installment_percent == nil
        progressBar.progress = model.installment_percent.orZero
        percentageLabel.text = model.getPercentage()
        if let color = model.status_color {
            progressBar.color = .hex(color)
        }
    }
    
    @objc private func cardTapped() {
        cardTappedObserver?(model?.click_action?.getAction())
    }
    
}
