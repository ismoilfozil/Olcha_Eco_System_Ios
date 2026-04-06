import UIKit
import OlchaUI
import OlchaUtils

public class VerifyView: BaseView {
 
    private var skeletonViews: [UIView] = []
    private var isLoading: Bool = false
    
    private lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.horizontalEdge()
        scrollView.container.spacing = 16
        scrollView.settings.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 32, right: 0)
        scrollView.settings.alwaysBounceVertical = true
        return scrollView
    }()
    
    private let verifyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .verifyPlaceholder
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 22)
        label.textColor = .olchaTextBlack
        label.textAlignment = .center
        label.text = "\t\t\t\t"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaLightTextColornnnnnn
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "\n\n\n"
        return label
    }()
    
    public let continueButton: OlchaButton = {
        let button = OlchaButton()
        return button
    }()
    
    public override func setupViews() {
        addSubview(scrollView)
        scrollView.addArrangedSubview(verifyImageView)
        scrollView.addArrangedSubview(titleLabel)
        scrollView.addArrangedSubview(descriptionLabel)
        scrollView.addArrangedSubview(continueButton)
    }
    
    public override func autolayout() {
        scrollView.container.setCustomSpacing(32, after: verifyImageView)
        scrollView.container.setCustomSpacing(32, after: descriptionLabel)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        verifyImageView.snp.makeConstraints { make in
            make.height.equalTo(verifyImageView.snp.width).dividedBy(1.3)
        }
        continueButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    
    public override func configureViews() {
        backgroundColor = .white
        languageUpdated()
        configureSkeleton()
    }
    
    public override func languageUpdated() {
        titleLabel.text = "verification".localized()
        descriptionLabel.text = "verify_description".localized()
        continueButton.setTitle("continue".localized())
    }
    
    public func setContinueButton(listener: @escaping () -> Void) {
        continueButton.clicked(listener)
    }
    
    public func updateSkeleton(isLoading: Bool) {
        guard self.isLoading != isLoading else { return }
        self.isLoading = isLoading
        skeletonViews.forEach { skeletonView in
            skeletonView.layoutIfNeeded()
            skeletonView.layoutSkeletonIfNeeded()
            isLoading ? skeletonView.showAnimatedGradientSkeleton() : skeletonView.hideSkeleton()
        }
    }
    
    public func setup(isVerified: Bool) {
        isHidden = isVerified
    }
    
    public func setup(status: VerificationStatusType?) {
        (status == .blocked) ? continueButton.disableButton() : continueButton.enableButton()
    }
}

private extension VerifyView {
    func configureSkeleton() {
        skeletonViews = [
            verifyImageView,
            titleLabel,
            descriptionLabel,
            continueButton
        ]
        titleLabel.skeletonConfiguration(
            lines: .custom(1),
            lastLinePercentage: 50,
            height: .relativeToConstraints
        )
        descriptionLabel.skeletonConfiguration(
            lines: .custom(3),
            lastLinePercentage: 50,
            height: .relativeToConstraints
        )
        skeletonViews.forEach({
            $0.isSkeletonable = true
            $0.showAnimatedGradientSkeleton()
        })
    }
}
