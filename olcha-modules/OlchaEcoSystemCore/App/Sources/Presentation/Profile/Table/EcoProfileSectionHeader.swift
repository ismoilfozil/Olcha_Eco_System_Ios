import UIKit
import OlchaUI

public class EcoProfileSectionHeader: BaseView {
    
    private let headerStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()

    private let sectionLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaLightTextColornnnnnn
        return label
    }()

    public override func setupViews() {
        addSubview(headerStack)
        headerStack.addArrangedSubview(sectionLabel)
    }
    
    public override func autolayout() {
        headerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
    }
    
    public func setup(with title: String) {
        sectionLabel.text = title
    }
    
}
