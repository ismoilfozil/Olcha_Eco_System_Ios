import UIKit
import SnapKit

public class EmptyView: BaseView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .empty_placeholder
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    public override func setupViews() {
        addSubview(imageView)
        addSubview(titleLabel)
    }
    
    public override func autolayout() {
        imageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.equalTo(160)
            make.height.equalTo(185)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).inset(-8)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    public func setup(title: String?, image: UIImage? = nil) {
        titleLabel.text = title
        if let image {
            imageView.image = image
        }
    }
    
    public func setImage(height: CGFloat, topOffset: CGFloat) {
        imageView.snp.removeConstraints()
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topOffset)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(height)
        }
    }
}
