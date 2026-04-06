import UIKit
import OlchaUI

class DeliveryCodeModalPage: BaseViewController {

    var deliveryCode: String = ""
    var orderId: Int?

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 24
        return stack
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaLightTextColornnnnnn
        label.text = "delivery_code_subtitle".localized()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let codeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .equalSpacing
        return stack
    }()

    private let qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let orderLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaLightTextColornnnnnn
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        setupModalViews()
        modalAutolayout()
        configureModalViews()
    }

    override func setupModalViews() {
        super.setupModalViews()
        modalContainer.addSubview(contentStack)

        contentStack.addArrangedSubview(subtitleLabel)
        contentStack.addArrangedSubview(codeStack)
        contentStack.addArrangedSubview(qrImageView)
        contentStack.addArrangedSubview(orderLabel)

        setupCodeDigits()
    }

    override func modalAutolayout() {
        super.modalAutolayout()
        contentStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(24)
        }

        qrImageView.snp.makeConstraints { make in
            make.width.height.equalTo(200)
        }
    }

    override func configureModalViews(header: String = "", textAlignment: NSTextAlignment = .left) {
        super.configureModalViews(header: "delivery_code".localized(), textAlignment: .left)
        dismissConfiguration()

        orderLabel.text = "order_number".localized() + " \(orderId ?? 0)"
        qrImageView.image = generateQRCode(from: deliveryCode)
    }

    private func setupCodeDigits() {
        for char in deliveryCode {
            let digitView = createDigitView(String(char))
            codeStack.addArrangedSubview(digitView)
        }
    }

    private func createDigitView(_ digit: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .olchaBackgroundColor
        container.layer.cornerRadius = 8
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.olchaLightNeutralGray?.cgColor

        let label = UILabel()
        label.style(.bold, 24)
        label.textColor = .olchaTextBlack
        label.text = digit
        label.textAlignment = .center

        container.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }

        container.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(56)
        }

        return container
    }

    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: .ascii)
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("M", forKey: "inputCorrectionLevel")

        guard let outputImage = filter.outputImage else { return nil }
        let scale = 200.0 / outputImage.extent.size.width
        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        return UIImage(ciImage: scaledImage)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = contentStack.systemLayoutSizeFitting(
            CGSize(width: view.frame.width - 48, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height + 100
        setContainerHeight(height)
    }
}
