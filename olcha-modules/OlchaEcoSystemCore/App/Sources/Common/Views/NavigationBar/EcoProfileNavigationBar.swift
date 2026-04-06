import UIKit
import OlchaUI

public class EcoProfileNavigationBar: BaseView {
    
    public let container: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .white
        return label
    }()
    
    public let rightButton: IconButton = {
        let button = IconButton()
        button.setIcon(.settings?.withTintColor(.white), edgeSize: 10, isIgnoringEdge: false)
        button.icon.contentMode = .scaleAspectFit
        return button
    }()
    
    public override func setupViews() {
        addSubview(container)
        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(rightButton)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(6)
        }
        rightButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
        }
    }
    
    public func setTitle(_ title: String?) {
        titleLabel.text = title
    }
    
    public func rightButtonClicked(completion: (() -> Void)?) {
        rightButton.clicked { completion?() }
    }
    
}
