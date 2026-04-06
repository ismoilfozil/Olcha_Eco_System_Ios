import UIKit
import OlchaUI

public class EcoSearchCategoryTableCell: BaseTableCell {

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    
    private let categoryImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.round(6)
        imageView.backgroundColor = .olchaLightNeutralGray
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.numberOfLines = 0
        label.textColor = .olchaBlackNeutral
        return label
    }()
    
    private let chevronImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .altArrowRight
        return imageView
    }()
    
    public override func setupViews() {
        container.addSubview(contentStack)
        contentStack.addArrangedSubview(categoryImage)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(chevronImage)
    }
    
    public override func configureViews() {
        container.backgroundColor = .white
        separatorInset = UIEdgeInsets(top: 0, left: 56, bottom: 0, right: 16)
    }
    
    public override func autolayout() {
        contentStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(48)
        }
        categoryImage.snp.makeConstraints { make in
            make.size.equalTo(36)
        }
        chevronImage.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
    }
    
    public func setup(title: String?, imageUrl: String?) {
        titleLabel.text = title
        categoryImage.load(from: imageUrl)
    }
    
}
