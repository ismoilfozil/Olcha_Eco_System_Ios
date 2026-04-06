import UIKit
import OlchaUtils

public class SupportView: BaseView {
    
    private let container: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    private let iconImageView: ContainerImageView = {
        let imageView = ContainerImageView()
        imageView.settings.image = .callIcon?.withTintColor(.olchaAccentColor)
        imageView.horizontalInset = 10
        imageView.verticalInset = 10
        imageView.backgroundColor = .hex("#FFDEDE").withAlphaComponent(0.4)
        imageView.round(8)
        return imageView
    }()
    
    private let labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 14)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let detailLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 14)
        label.textColor = .olchaPrimaryColor
        return label
    }()
    
    public override func setupViews() {
        addSubview(container)
        container.addArrangedSubview(iconImageView)
        container.addArrangedSubview(labelStack)
        labelStack.addArrangedSubview(titleLabel)
        labelStack.addArrangedSubview(detailLabel)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
    }
    
    public override func configureViews() {
        backgroundColor = .hex("#F5F5F5").withAlphaComponent(0.6)
        round()
        detailLabel.text = Texts.urls.olcha_phone
        languageUpdated()
    }
    
    public override func languageUpdated() {
        titleLabel.text = "support_title".localized()
    }
    
}
