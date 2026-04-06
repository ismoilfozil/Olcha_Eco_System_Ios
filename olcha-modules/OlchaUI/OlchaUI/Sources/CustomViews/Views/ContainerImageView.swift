import UIKit
import SnapKit

public final class ContainerImageView: BaseView {
    public let container = UIView()
    public let settings = UIImageView()
    
    public var horizontalInset: CGFloat = 0 {
        didSet {
            updateLayout()
        }
    }
    
    public var verticalInset: CGFloat = 0 {
        didSet {
            updateLayout()
        }
    }
    
    public override func setupViews() {
        addSubview(container)
        container.addSubview(settings)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        settings.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
    }
    
    private func updateLayout() {
        settings.snp.updateConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(horizontalInset)
            make.verticalEdges.equalToSuperview().inset(verticalInset)
        }
    }
    
}
