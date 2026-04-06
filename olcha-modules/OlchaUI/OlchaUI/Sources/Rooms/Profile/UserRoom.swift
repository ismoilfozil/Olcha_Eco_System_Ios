import UIKit
import SnapKit
import SkeletonView
import OlchaUtils

public class UserRoom: BaseTableCell {
    
    public let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 12
        stack.alignment = .top
        return stack
    }()
    
    private let userStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.spacing = 4
        stack.axis = .vertical
        return stack
    }()
    
    public let userImageContainer: UIView = {
        let view = UIView()
        view.round(28)
        view.backgroundColor = .hex("#FDF4F4")
        return view
    }()
    
    public let userNameLetter: UILabel = {
        let label = UILabel()
        label.textColor = .olchaAccentColor
        label.textAlignment = .center
        label.style(.medium, 16)
        return label
    }()
    
    public let userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.round(28)
        return imageView
    }()
    
    public let username: UILabel = {
        let label = UILabel()
        label.style(.semibold, 16)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    public let subtitle: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaLightTextColornnnnnn
        return label
    }()
    
    public let statusLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.text = "\t"
        return label
    }()
        
    public let rightIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .rightIcon?.withColor(.olchaLightTextColornnnnnn ?? .lightGray)
        return imageView
    }()
    
    public let progressView: CircularProgressView = {
        let view = CircularProgressView()
        view.round(28)
        return view
    }()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        userNameLetter.text = "\t\t"
        username.text = "\t\t"
        subtitle.text = "\t\t"
        statusLabel.text = "\t\t"
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        skeletonViews.forEach({ $0.layoutSkeletonIfNeeded() })
    }
    
    public override func setupViews() {
        container.addSubview(contentStack)
        contentStack.addArrangedSubview(userImageContainer)
        contentStack.addArrangedSubview(userStack)
        contentStack.addArrangedSubview(progressView)
        userImageContainer.addSubview(userNameLetter)
        userImageContainer.addSubview(userImage)
        userStack.addArrangedSubview(username)
        userStack.addArrangedSubview(subtitle)
        userStack.addArrangedSubview(statusLabel)
    }
    
    public override func autolayout() {
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        userImageContainer.snp.makeConstraints { make in
            make.size.equalTo(56)
        }
        
        userNameLetter.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        userImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
                
        progressView.snp.makeConstraints { make in
            make.size.equalTo(56)
        }
    }
    
    public override func configureViews() {
        configureSkeleton()
    }
    
    public func setup(
        with data: String, subtitleText: String = "personal_datas".localized(),
        isVerified: Bool = false,
        status: VerificationStatusType?
    ) {
        userNameLetter.text = String(describing: data.withoutWhiteSpace.first ?? " ") 
        username.text = data
        subtitle.text = subtitleText
        progressView.isHidden = isVerified && status == .approved
        switch status {
        case .approved:
            statusLabel.attributedText = makeAttributedStringWithImage(
                text: "status_approved".localized(.verification),
                statusType: .approved
            )
            statusLabel.textColor = .hex("#25B577")
        case .rejected:
            statusLabel.attributedText = makeAttributedStringWithImage(
                text: "status_rejected".localized(.verification),
                statusType: .rejected
            )
            statusLabel.textColor = .olchaPrimaryColor
        case .requested:
            statusLabel.attributedText = makeAttributedStringWithImage(
                text: "status_requested".localized(.verification),
                statusType: .requested
            )
            statusLabel.textColor = .hex("#F99746")
        case .blocked:
            statusLabel.attributedText = makeAttributedStringWithImage(
                text: "status_blocked".localized(.verification),
                statusType: .none
            )
            statusLabel.textColor = .olchaPrimaryColor
        case .expired:
            statusLabel.attributedText = makeAttributedStringWithImage(
                text: "status_expired".localized(.verification),
                statusType: .none
            )
            statusLabel.textColor = .olchaPrimaryColor
        case .none:
            statusLabel.attributedText = makeAttributedStringWithImage(
                text: "status_none".localized(.verification), 
                statusType: .none
            )
            statusLabel.textColor = .olchaPrimaryColor
        }
    }
    
}

private extension UserRoom {
    func configureSkeleton() {
        makeSkeleton(views: [
            userImage,
            username,
            subtitle,
            statusLabel,
            progressView,
        ])
        
        username.skeletonConfiguration(
            lines: .custom(1),
            lastLinePercentage: 100,
            height: .relativeToConstraints
        )
        subtitle.skeletonConfiguration(
            lines: .custom(1),
            lastLinePercentage: 70,
            height: .relativeToConstraints
        )
        statusLabel.skeletonConfiguration(
            lines: .custom(1),
            lastLinePercentage: 50,
            height: .relativeToConstraints
        )
    }
    
    func makeAttributedStringWithImage(text: String, statusType: VerificationStatusType?) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.append(NSAttributedString(string: " "))
        var image: UIImage?
        switch statusType {
        case .approved:
            image = .verificationApproved
        case .rejected, .none:
            image = .verificationRejected
        case .expired:
            image = .verificationRejected
        case .blocked:
            image = .verificationRejected
        case .requested:
            image = .verificationRequest
        }
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        imageAttachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
        attributedText.append(NSAttributedString(attachment: imageAttachment))
        return attributedText
    }

}
