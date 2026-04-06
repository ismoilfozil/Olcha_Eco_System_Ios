import UIKit
import OlchaUI

public class EcoSearchActualCollectionCell: BaseCollectionCell {
    
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 2
        return stack
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .olchaLightNeutralGray
        imageView.round()
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .olchaBlackNeutral
        label.style(.medium, 12)
        label.textAlignment = .center
        return label
    }()
    
    public override func setupViews() {
        container.addSubview(containerStack)
        containerStack.addArrangedSubview(imageView)
        containerStack.addArrangedSubview(titleLabel)
    }
    
    public override func autolayout() {
        containerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.size.equalTo(56)
        }
    }
    
    public override func configureViews() {
        container.backgroundColor = .clear
    }
  
    public func setup(with model: ActualItem) {
        titleLabel.text = model.title
        imageView.load(from: model.image_url)
    }
    
}
