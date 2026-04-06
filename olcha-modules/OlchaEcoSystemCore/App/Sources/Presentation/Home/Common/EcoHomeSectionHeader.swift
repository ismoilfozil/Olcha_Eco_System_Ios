import UIKit
import OlchaUI

public class EcoHomeSectionHeader: BaseView {
    
    private let headerStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()
    
    private let sectionLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 18)
        label.textColor = .olchaBlackNeutral
        return label
    }()
    
    private let allButton: RightIconButton = {
        let button = RightIconButton()
        button.backgroundColor = .olchaLightNeutralGray
        button.buttonTitle.textColor = .olchaBlackNeutral
        button.buttonTitle.style(.regular, 12)
        button.configure(image: .altArrowRight, title: "home_section_all".localized(.olchaEcoSystemCore), size: 16, padding: 12)
        return button
    }()
    
    public override func setupViews() {
        addSubview(headerStack)
        headerStack.addArrangedSubview(sectionLabel)
        headerStack.addArrangedSubview(allButton)
    }
    
    public override func autolayout() {
        headerStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview()
        }
        allButton.snp.makeConstraints { make in
            make.height.equalTo(28)
        }
    }
    
    public override func configureViews() {
        allButton.round(14)
    }
    
    public func setSectionLabel(_ text: String, image: UIImage?) {
        sectionLabel.attributedText = withLeftImage(
            text: text, image: image,
            rect: CGRect(x: 0, y: -8, width: 28, height: 28)
        )
    }
    
    public func setAllButtonLabel(_ text: String) {
        allButton.configure(image: .altArrowRight, title: text, size: 16, padding: 12)
    }
    
    public func setAllButton(listener: @escaping () -> Void) {
        allButton.settings.clicked(listener)
    }
    
    private func withLeftImage(text: String, image: UIImage?, rect: CGRect) -> NSAttributedString {
        let attributedText = NSMutableAttributedString()
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        imageAttachment.bounds = rect
        attributedText.append(NSAttributedString(attachment: imageAttachment))
        attributedText.append(NSAttributedString(string: "  "))
        attributedText.append(NSAttributedString(string: text))
        return attributedText
    }
}
