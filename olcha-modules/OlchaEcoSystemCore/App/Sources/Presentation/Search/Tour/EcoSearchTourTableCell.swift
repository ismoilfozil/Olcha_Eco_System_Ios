import UIKit
import OlchaUI

public class EcoSearchTourTableCell: BaseTableCell {

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    
    private let searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .magnifierIcon
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.numberOfLines = 0
        label.textColor = .olchaBlackNeutral
        return label
    }()
    
    public override func setupViews() {
        container.addSubview(contentStack)
        contentStack.addArrangedSubview(searchIcon)
        contentStack.addArrangedSubview(titleLabel)
    }
    
    public override func configureViews() {
        container.backgroundColor = .white
        separatorInset = UIEdgeInsets(top: 0, left: 56, bottom: 0, right: 16)
    }
    
    public override func autolayout() {
        contentStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(40)
        }
        searchIcon.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
    }
    
    public func setup(title: String?) {
        titleLabel.text = title
    }
    
}
