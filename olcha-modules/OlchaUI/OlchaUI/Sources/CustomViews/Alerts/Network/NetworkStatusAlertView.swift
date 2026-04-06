import UIKit
import SnapKit
import OlchaUtils

public class NetworkStatusAlertView: BaseViewController<EmptyNavigationBar> {
    
    public var alertButtonObserver: (() -> Void)?
    
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
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .networkError
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
        content.addArrangedSubview(imageView)
        content.addArrangedSubview(titleLabel)
        content.addArrangedSubview(alertButton)
    }
    
    public override func autolayout() {
        content.setCustomSpacing(60, after: imageView)
        content.setCustomSpacing(28, after: titleLabel)
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        content.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.horizontalEdges.bottom.equalToSuperview().inset(16)
        }
        imageView.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        alertButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    
    public override func configureViews() {
        view.backgroundColor = .black.withAlphaComponent(0.4)
        titleLabel.text = "network_disconnected".localized()
        alertButton.setTitle("back".localized(), for: .normal)
    }
    
    public override func setupObservers() {
        alertButton.clicked({ self.alertButtonObserver?() })
    }
    
}
