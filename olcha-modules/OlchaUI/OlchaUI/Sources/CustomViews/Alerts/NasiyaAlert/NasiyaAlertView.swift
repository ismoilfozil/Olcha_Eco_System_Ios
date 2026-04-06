import UIKit
import Lottie
import SnapKit
import OlchaUtils

public enum NasiyaAlertType {
    case requested
    case success
    case reject
    case amount_increased
    
    var title: String {
        switch self {
        case .requested:
            return "nasiya_alert_request".localized()
        case .success:
            return "nasiya_alert_success".localized()
        case .reject:
            return "nasiya_alert_reject".localized()
        default:
            return ""
        }
    }
    
    var buttonText: String {
        switch self {
        case .requested, .success, .amount_increased:
            return "go_profile".localized()
        case .reject:
            return "go_verification".localized()
        }
    }
}

public class NasiyaAlertView: BaseViewController<EmptyNavigationBar> {
    
    public var alertButtonObserver: (() -> Void)?
    
    public var message: String? {
        didSet {
            if message == nil {
                titleLabel.text = alertType.title
            } else {
                titleLabel.text = message
            }
        }
    }
    
    public var alertType: NasiyaAlertType = .requested {
        didSet {
            alertButton.setTitle(alertType.buttonText, for: .normal)
            switch alertType {
            case .reject:
                animationView.isHidden = true
                imageView.isHidden = false
            case .requested, .success:
                animationView.isHidden = false
                imageView.isHidden = true
            case .amount_increased:
                animationView.isHidden = false
                imageView.isHidden = true
            }
        }
    }
    
    private let alertView: UIView = {
        let view = UIView()
        view.round(12)
        view.backgroundColor = .white
        return view
    }()
    
    private let content: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    private let closeButton: IconButton = {
        let button = IconButton()
        button.setIcon(.x_cancel, edgeSize: 6)
        return button
    }()

    private lazy var animationView: LottieAnimationView = {
        let animationView = LottieAnimationView()
        animationView.loopMode = .autoReverse
        animationView.contentMode = .scaleAspectFit
        return animationView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .denyVerification
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let alertButton: IButton = {
        let button = IButton()
        button.backgroundColor = .olchaAccentColor
        button.titleLabel?.style(.semibold, 14)
        button.round(8)
        return button
    }()
    
    public override func setupViews() {
        container.addSubview(alertView)
        alertView.addSubview(content)
        alertView.addSubview(closeButton)
        content.addArrangedSubview(animationView)
        content.addArrangedSubview(imageView)
        content.addArrangedSubview(titleLabel)
        content.addArrangedSubview(alertButton)
    }
    
    public override func autolayout() {
        content.setCustomSpacing(28, after: titleLabel)
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        content.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        animationView.snp.makeConstraints { make in
            make.size.equalTo(180)
        }
        imageView.snp.makeConstraints { make in
            make.size.equalTo(180)
        }
        alertButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    
    public override func configureViews() {
        view.backgroundColor = .black.withAlphaComponent(0.4)
        guard let bundle = Bundle(identifier: BundleType.resources.identifier) else {
            return
        }
        animationView.animation = LottieAnimation.named("success", bundle: bundle)
        animationView.play()
    }
    
    public override func setupObservers() {
        closeButton.clicked { [weak self] in
            guard let self else { return }
            dismiss(animated: false)
        }
        alertButton.clicked { [weak self] in
            guard let self else { return }
            dismiss(animated: false)
            alertButtonObserver?()
        }
    }
    
}
