import UIKit
import OlchaUI

public class EcoSearchHistoryTableCell: BaseTableCell {

    public var closeIconObserver: (() -> Void)?
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    
    private let historyIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .searchHistory
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.numberOfLines = 0
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let closeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .searchCloseButton
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    public override func setupViews() {
        container.addSubview(contentStack)
        contentStack.addArrangedSubview(historyIcon)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(closeIcon)
    }
    
    public override func configureViews() {
        container.backgroundColor = .lightGrayBackground
        separatorInset = UIEdgeInsets(top: 0, left: 56, bottom: 0, right: 16)
        
        let closeTapGesture = UITapGestureRecognizer(target: self, action: #selector(closeIconClicked))
        closeIcon.addGestureRecognizer(closeTapGesture)
    }
    
    public override func autolayout() {
        contentStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(40)
        }
        historyIcon.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        closeIcon.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
    }
    
    public func setup(title: String?) {
        titleLabel.text = title
    }
    
    @objc private func closeIconClicked() {
        closeIconObserver?()
    }
    
}
