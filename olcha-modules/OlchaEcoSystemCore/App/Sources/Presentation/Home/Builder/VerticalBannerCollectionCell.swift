import UIKit
import OlchaUI

public class VerticalBannerCollectionCell: BaseCollectionCell, BuilderCollectionCell {
        
    private let contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    public override func setupViews() {
        container.addSubview(contentImageView)
    }
    
    public override func autolayout() {
        contentImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        corner(16)
    }
    
    public func setup(with data: BuilderSectionItem) {
        contentImageView.load(from: data.image_url)
    }
    
}
