import UIKit
import OlchaUI
import OlchaUtils

public class ProfileVerifyStatusRoom: BaseTableCell {
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        return stack
    }()
    
    private let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .verificationRequested
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    public override func setupViews() {
        container.addSubview(contentStack)
        contentStack.addArrangedSubview(statusImageView)
    }
    
    public override func autolayout() {
        horizontalEdge = 16
        
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func setup(status: VerificationStatusType?) {
        switch status {
        case .approved, .none:
            statusImageView.isHidden = true
        case .rejected, .requested:
            statusImageView.isHidden = false
        case .expired:
            statusImageView.isHidden = true
            break
        case .blocked:
            statusImageView.isHidden = true
            break
        }
    }
    
}
