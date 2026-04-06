import UIKit
import OlchaUI
import OlchaUtils
import Lottie

public class DenyViewController: BaseViewController<EmptyNavigationBar> {
    
    private lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.horizontalEdge()
        scrollView.container.spacing = 12
        scrollView.settings.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 32, right: 0)
        scrollView.settings.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var denyImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = .denyVerification
        return view
    }()
    
    private let successLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaLightTextColornnnnnn
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let closeButton: IButton = {
        let button = IButton()
        button.backgroundColor = .olchaAccentColor
        button.titleLabel?.style(.semibold, 14)
        button.round(8)
        return button
    }()

    public override func setupViews() {
        container.addSubview(scrollView)
        container.addSubview(closeButton)
        scrollView.addArrangedSubview(denyImageView)
        scrollView.addArrangedSubview(successLabel)
        scrollView.addArrangedSubview(descriptionLabel)
    }
    
    public override func autolayout() {
        scrollView.container.setCustomSpacing(24, after: denyImageView)
        
        scrollView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.bottom.equalTo(closeButton.snp.top)
        }
        denyImageView.snp.makeConstraints { make in
            make.size.equalTo(300)
        }
        closeButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    public override func configureViews() {
        ignoreNavigationBar = true
        languageUpdated()
    }
    
    public override func languageUpdated() {
        successLabel.text = "deny_identification".localized(.verification)
        descriptionLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text"
        closeButton.setTitle("close".localized(), for: .normal)
    }
    
    public func setSuccessLabel(text: String) {
        successLabel.text = text
    }
    
    public func setCloseButton(listener: @escaping () -> Void) {
        closeButton.clicked(listener)
    }
    
}
