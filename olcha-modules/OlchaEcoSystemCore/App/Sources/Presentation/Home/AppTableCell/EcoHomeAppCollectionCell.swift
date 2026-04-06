import UIKit
import OlchaUI

public class EcoHomeAppCollectionCell: BaseCollectionCell {
    
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        return stack
    }()
    
    private let imageViewContainer: UIView = {
        let view = UIView()
        view.round(16)
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .olchaBlackNeutral
        label.style(.medium, 12)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let imageSize: CGFloat = 48
    
    private lazy var blurView: BlurView = {
        let view = BlurView(frame: .init(origin: .zero, size: .init(width: imageSize, height: imageSize)))
        view.blurRadius = 2
        return view
    }()
    
    private let soonLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 10)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .hex("7C6473")
        label.text = "Tez\nkunda"
        return label
    }()
    
    public override func setupViews() {
        container.addSubview(containerStack)
        containerStack.addArrangedSubview(imageViewContainer)
        imageViewContainer.addSubview(imageView)
        imageViewContainer.addSubview(blurView)
        imageViewContainer.addSubview(soonLabel)
        containerStack.addArrangedSubview(titleLabel)
    }
    
    public override func autolayout() {
        containerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageViewContainer.snp.makeConstraints { make in
            make.width.height.equalTo(imageSize)
        }
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(imageSize)
        }
        soonLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        container.backgroundColor = .clear
    }
  
    public func setup(with model: RowProtocol, isEnabled: Bool) {
        titleLabel.text = model.title
        titleLabel.textColor = isEnabled ? .olchaBlackNeutral : .olchaBlackNeutral?.withAlphaComponent(0.6)
        imageView.image = model.image
        soonLabel.isHidden = isEnabled
        blurView.isHidden = isEnabled
    }
    
}
