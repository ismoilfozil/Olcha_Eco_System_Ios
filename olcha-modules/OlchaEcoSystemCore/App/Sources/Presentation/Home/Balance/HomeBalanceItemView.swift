import UIKit
import OlchaUI

public class HomeBalanceItemView: BaseView {
    
    public var viewClicked: (() -> Void)?
    
    private let progressBar: PlainHorizontalProgressBar = {
        let bar = PlainHorizontalProgressBar()
        bar.color = .bonusProgressColor
        bar.maskColor = .white
        return bar
    }()
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 16
        stack.axis = .vertical
        return stack
    }()
        
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 12)
        label.textColor = .olchaLightTextColornnnnnn
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 22)
        label.textColor = .olchaBlackNeutral
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    public enum BalanceImageType {
        case title
        case balance
        
        var image: UIImage? {
            switch self {
            case .title: return .altArrowRight
            case .balance: return .balanceLevelIcon
            }
        }
        
        var size: Int {
            switch self {
            case .title: return 12
            case .balance: return 20
            }
        }
    }
    
    public override func setupViews() {
        addSubview(contentStack)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(progressBar)
        contentStack.addArrangedSubview(balanceLabel)
    }
    
    public override func autolayout() {
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        progressBar.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
    }
    
    public override func configureViews() {
        backgroundColor = .lightGrayBackground
        round()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func viewTapped() {
        viewClicked?()
    }
    
    public func setupBalance(title: String, balance: String?, progress: CGFloat? = nil, hideProgress: Bool = true, alignment: NSTextAlignment = .left) {
        balanceLabel.textAlignment = alignment
        titleLabel.attributedText = makeAttributedStringWithImage(text: title, imageType: .title)
        balanceLabel.attributedText = makeAttributedStringWithImage(
            text: balance?.originalPriceWithoutCurrency ?? "0",
            imageType: hideProgress ? .none : .balance
        )
        progressBar.isHidden = hideProgress
        progressBar.isPercentHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.progressBar.progress = progress ?? 0
        }
    }
    
    private func makeAttributedStringWithImage(text: String, imageType: BalanceImageType? = nil) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: text)
        if let imageType {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = imageType.image
            imageAttachment.bounds = CGRect(x: 0, y: -2, width: imageType.size, height: imageType.size)
            attributedText.append(NSAttributedString(attachment: imageAttachment))
        }
        return attributedText
    }
    
}
