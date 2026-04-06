import UIKit
import SnapKit

public class LabelView: BaseView {
    public let settings = UILabel()
    
    public var verticalEdge: CGFloat = 0 {
        didSet {
            updateLayout()
        }
    }
    
    public var horizontalEdge: CGFloat = 0 {
        didSet {
            updateLayout()
        }
    }
    
    public override func setupViews() {
        addSubview(settings)
    }
    
    public override func autolayout() {
        settings.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        settings.setContentHuggingPriority(.dragThatCanResizeScene, for: .horizontal)
    }
    
    public func updateLayout() {
        settings.snp.updateConstraints { make in
            make.left.right.equalToSuperview().inset(horizontalEdge)
            make.top.bottom.equalToSuperview().inset(verticalEdge)
        }
    }
}
