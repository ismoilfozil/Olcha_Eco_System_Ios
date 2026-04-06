import UIKit
import SnapKit

public class EmptyPlaceholderItem: BaseCollectionCell {
    
    public let responder = EmptyPlaceholder()
    
    public override func setupViews() {
        container.addSubview(responder)
    }
    
    public override func autolayout() {
        responder.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        responder.titleLabel.style(.semibold, 22)
        responder.subtitleLabel.style(.medium, 16)
        responder.subtitleLabel.textColor = .olchaLightTextColornnnnnn
        responder.removeContent()
    }
    
    public func setup() {
        responder.setupTitle("empty_products_title".localized())
        responder.setupSubtitle("empty_products_subtitle".localized())
    }
}
