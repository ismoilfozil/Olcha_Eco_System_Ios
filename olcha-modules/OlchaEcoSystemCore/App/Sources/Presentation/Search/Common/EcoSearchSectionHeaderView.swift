import UIKit
import OlchaUI

public class EcoSearchSectionHeaderView: BaseView {
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 16)
        label.textColor = .olchaBlackNeutral
        return label
    }()
    
    public override func setupViews() {
        addSubview(contentStack)
        contentStack.addArrangedSubview(titleLabel)
    }
    
    public override func autolayout() {
        contentStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview()
            make.height.equalTo(46)
        }
    }
    
    public override func configureViews() {
        backgroundColor = .white
    }
    
    public func setHeader(_ title: String?) {
        titleLabel.text = title
    }
    
}
