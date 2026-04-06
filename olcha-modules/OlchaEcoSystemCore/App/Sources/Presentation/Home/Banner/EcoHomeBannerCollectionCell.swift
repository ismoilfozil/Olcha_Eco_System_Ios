import UIKit
import OlchaUI
import OlchaCommon

public class EcoHomeBannerCollectionCell: BaseCollectionCell {
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImageView.image = nil
        skeletonViews.forEach({ $0.layoutSkeletonIfNeeded() })
    }
    
    public override func setupViews() {
        container.addSubview(backgroundImageView)
    }
    
    public override func autolayout() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        configureSkeleton()
    }
    
    public func setup(with model: BannerModel) {
        backgroundImageView.load(from: model.image_url, transition: false)
    }
    
}

private extension EcoHomeBannerCollectionCell {
    func configureSkeleton() {
        makeSkeleton(views: [
            container
        ])
    }
}
