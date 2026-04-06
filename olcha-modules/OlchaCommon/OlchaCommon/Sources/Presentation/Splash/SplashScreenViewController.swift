import UIKit
import OlchaUI
import ViewAnimator
import SnapKit

public class SplashScreenViewController: BaseViewController<EmptyNavigationBar> {
    
    private let splashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .olcha_logo
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public var splashCompletion: (() -> Void)?
    
    public override func setupViews() {
        container.addSubview(splashImageView)
    }
    
    public override func configureViews() {
        ignoreNavigationBar = true
        animateImage()
    }
        
    public override func autolayout() {
        splashImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(100)
        }
    }
    
    public func setSplashImage(_ image: UIImage?) {
        splashImageView.image = image
    }
    
}

private extension SplashScreenViewController {
    func animateImage() {
        splashImageView.animate(
            animations: [AnimationType.zoom(scale: 4)],
            delay: 0,
            duration: 1,
            completion: splashCompletion
        )
    }
}
