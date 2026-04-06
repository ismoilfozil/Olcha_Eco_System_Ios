import UIKit
import OlchaUI

public class EcoProfileTableCell: BaseTableCell {
    
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 12
        stack.alignment = .center
        return stack
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaBlackNeutral
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    public override func setupViews() {
        container.addSubview(containerStack)
        containerStack.addArrangedSubview(iconImageView)
        containerStack.addArrangedSubview(titleLabel)
    }
    
    public override func autolayout() {
        containerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
    }

    public override func configureViews() {
        
    }
    
    public func setup(with model: RowProtocol, isDelete: Bool) {
        titleLabel.text = model.title
        iconImageView.image = model.image
        iconImageView.isHidden = model.image == nil
        titleLabel.textColor = isDelete ? .olchaAccentColor : .olchaBlackNeutral
    }
    
}
