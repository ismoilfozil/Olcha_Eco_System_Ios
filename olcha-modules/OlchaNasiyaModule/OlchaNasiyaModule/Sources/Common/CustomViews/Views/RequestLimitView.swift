import UIKit
import OlchaUI
import SnapKit
import OlchaUtils

public final class RequestLimitView: BaseView {
    
    private let container: UIView = {
        let view = UIView()
        view.round(8)
        view.backgroundColor = .olchaLightNeutralGray
        return view
    }()
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 18)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let requestButton: IButton = {
        let button = IButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.style(.medium, 10)
        button.backgroundColor = .olchaPrimaryColor
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        button.round(6)
        return button
    }()
    
    private let requestImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .right
        imageView.image = .limitViewImage
        return imageView
    }()
    
    public override func setupViews() {
        addSubview(container)
        container.addSubview(contentStack)
        container.addSubview(requestImageView)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(requestButton)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        contentStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(16)
            make.right.equalTo(requestImageView.snp.left).offset(-16)
        }
        requestButton.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        requestImageView.snp.makeConstraints { make in
            make.verticalEdges.right.equalToSuperview()
            make.width.equalTo(120)
        }
    }
    
    public override func configureViews() {
        languageUpdated()
    }
    
    public override func languageUpdated() {
        titleLabel.text = "request_limit_title".localized(.olchaNasiyaModule)
        requestButton.setTitle("home_nasiya_limit_request".localized(.olchaEcoSystemCore), for: .normal)
    }
    
    public func setRequestButton(_ listener: (() -> Void)? = nil) {
        requestButton.clicked { listener?() }
    }
    
    func setup(status: VerificationStatusType?) {
        let isRequestDisabled = status == .blocked
        requestButton.isEnabled = !isRequestDisabled
        requestButton.backgroundColor = .olchaAccentColor.withAlphaComponent(isRequestDisabled ? 0.4 : 1)
    }
}
