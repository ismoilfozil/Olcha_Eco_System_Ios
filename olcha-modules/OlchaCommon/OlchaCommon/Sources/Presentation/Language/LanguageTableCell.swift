import UIKit
import OlchaUI

public class LanguageTableCell: BaseTableCell {
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14.0)
        label.textColor = .olchaLightTextColornnnnnn
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .rbtnDefault
        return imageView
    }()
    
    public var isChosen: Bool = false {
        didSet {
            print(isChosen)
            iconImageView.image = isChosen ? .rbtn : .rbtnDefault
        }
    }
    
    public override func setupViews() {
        container.addSubview(contentStack)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(iconImageView)
    }
    
    public override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 14
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        iconImageView.snp.makeConstraints { make in
            make.width.equalTo(20)
        }
    }
    
    public override func configureViews() {
        
    }
    
    public func setTitleLabel(_ text: String) {
        titleLabel.text = text
    }

}
