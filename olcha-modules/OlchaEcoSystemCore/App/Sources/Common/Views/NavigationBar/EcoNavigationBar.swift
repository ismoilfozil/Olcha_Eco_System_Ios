import UIKit
import OlchaUI
import OlchaAuth

public class EcoNavigationBar: BaseView {
    
    public let container: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.backgroundColor = .clear
        return stack
    }()
    
    public let leftButton: IconButton = {
        let button = IconButton()
        button.setIcon(.olcha_logo)
        button.icon.contentMode = .scaleAspectFit
        return button
    }()
    
    public let rightButton: IconButton = {
        let button = IconButton()
        button.setIcon(.bellButtonBar)
        button.icon.contentMode = .scaleAspectFit
        return button
    }()

    public let barcodeButton: IconButton = {
        let button = IconButton()
        button.setIcon(.qr)
        button.icon.contentMode = .scaleAspectFit
        return button
    }()

    private let rightButtonsContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()

    public override func setupViews() {
        addSubview(container)

        rightButtonsContainer.addArrangedSubview(barcodeButton)
        rightButtonsContainer.addArrangedSubview(rightButton)

        container.addArrangedSubview(leftButton)
        container.addArrangedSubview(rightButtonsContainer)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        leftButton.snp.makeConstraints { make in
            make.width.equalTo(78)
        }
        barcodeButton.snp.makeConstraints { make in
            make.width.equalTo(24)
        }
        rightButton.snp.makeConstraints { make in
            make.width.equalTo(24)
        }
    }
    
    public override func configureViews() {
        backgroundColor = .clear
        updateBarcodeButtonVisibility()
    }

    public func updateBarcodeButtonVisibility() {
        barcodeButton.isHidden = !AuthGlobalDefaults.isUser()
    }
    
    public func leftButtonClicked(completion: (() -> Void)?) {
        leftButton.clicked { completion?() }
    }

    public func rightButtonClicked(completion: (() -> Void)?) {
        rightButton.clicked { completion?() }
    }

    public func barcodeButtonClicked(completion: (() -> Void)?) {
        barcodeButton.clicked { completion?() }
    }

}
