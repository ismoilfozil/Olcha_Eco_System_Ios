import UIKit
import OlchaUI

public class HorizontalCategoryCollectionCell: BaseCollectionCell, BuilderCollectionCell {
        
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.round()
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.style(.medium, 12)
        label.textAlignment = .center
        label.textColor = .olchaBlackNeutral
        return label
    }()
    
    public override func setupViews() {
        container.addSubview(contentStack)
        contentStack.addArrangedSubview(iconImageView)
        contentStack.addArrangedSubview(titleLabel)
    }
    
    public override func autolayout() {
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(64)
        }
    }
    
    public override func configureViews() {
        
    }
    
    public func setup(with data: BuilderSectionItem) {
        iconImageView.load(from: data.image_url, imageType: .quadratic)
        titleLabel.text = data.title
    }
    
}
