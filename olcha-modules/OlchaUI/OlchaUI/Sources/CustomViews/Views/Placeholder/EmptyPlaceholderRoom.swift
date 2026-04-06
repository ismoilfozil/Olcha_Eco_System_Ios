import UIKit
import SnapKit

public class EmptyPlaceholderRoom: BaseTableCell {
    
    public let responder = EmptyView()
    
    public override func setupViews() {
        container.addSubview(responder)
    }
    
    public override func autolayout() {
        responder.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        responder.setImage(height: 300, topOffset: 50)
    }
    
    public override func configureViews() {
        responder.setup(title: "", image: .empty_placeholder)
    }
    
    public func setTitle(text: String?, image: UIImage? = .empty_placeholder) {
        responder.setup(title: text, image: image)
    }
}
