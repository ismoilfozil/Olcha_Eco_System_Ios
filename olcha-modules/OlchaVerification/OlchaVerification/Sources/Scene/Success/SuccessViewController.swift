import UIKit
import OlchaUI
import OlchaUtils
import Lottie

public class SuccessViewController: BaseViewController<EmptyNavigationBar> {
    
    private lazy var animationView: LottieAnimationView = {
        let animationView = LottieAnimationView()
        animationView.loopMode = .autoReverse
        animationView.contentMode = .scaleAspectFit
        return animationView
    }()
    
    private let successLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .olchaTextBlack
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
        container.addSubview(animationView)
        container.addSubview(successLabel)
        container.addSubview(closeButton)
    }
    
    public override func autolayout() {
        animationView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-120)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }
        successLabel.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(32)
        }
        closeButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    public override func configureViews() {
        guard let bundle = Bundle(identifier: BundleType.olchaInvestCore.identifier) else {
            return
        }
        animationView.animation = LottieAnimation.named("success", bundle: bundle)
        animationView.play()
        languageUpdated()
    }
    
    public override func languageUpdated() {
        successLabel.text = "success_identification".localized(.verification)
        closeButton.setTitle("close".localized(), for: .normal)
    }
    
    public func setSuccessLabel(text: String) {
        successLabel.text = text
    }
    
    public func setCloseButton(listener: @escaping () -> Void) {
        closeButton.clicked(listener)
    }
    
}
