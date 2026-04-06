import UIKit
import OlchaUI

public class EcoSearchHistoryHeaderView: BaseView {
    
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
    
    private let clearButton: IButton = {
        let button = IButton()
        button.setTitleColor(.olchaDarkNeutralGray, for: .normal)
        button.titleLabel?.style(.medium, 14)
        return button
    }()
    
    public override func setupViews() {
        addSubview(contentStack)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(clearButton)
    }
    
    public override func autolayout() {
        contentStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview()
            make.height.equalTo(34)
        }
    }
    
    public override func configureViews() {
        backgroundColor = .lightGrayBackground
        titleLabel.text = "search_history_title".localized(.olchaEcoSystemCore)
        clearButton.setTitle("search_history_clear".localized(.olchaEcoSystemCore), for: .normal)
    }
    
    public func setClearButton(observer: @escaping () -> Void) {
        clearButton.clicked(observer)
    }
    
}
