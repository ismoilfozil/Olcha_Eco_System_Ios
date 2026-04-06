import UIKit
import OlchaUI
import OlchaUtils
import SnapKit

public class EcoOrderConfirmationViewController: BaseViewController<TitleNavigationBar> {

    // MARK: - Properties
    public var viewModel: EcoOrderConfirmationViewModel?
    public weak var coordinator: EcoHomeCoordinatorProtocol?

    private var orderCode: String?
    private var expirationTimer: Timer?
    private var remainingSeconds: Int = 60
    private var isExpired: Bool = false

    // MARK: - UI Components
    private lazy var barcodeContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray4.cgColor
        return view
    }()

    private lazy var barcodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "order_confirmation_code_title".localized(.olchaEcoSystemCore)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = .monospacedSystemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "order_confirmation_description".localized(.olchaEcoSystemCore)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    private lazy var progressContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        return view
    }()

    private lazy var progressBar: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.progressTintColor = .systemBlue
        progress.trackTintColor = .systemGray4
        progress.progress = 1.0
        return progress
    }()

    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "1:00"
        label.textAlignment = .center
        label.font = .monospacedSystemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()

    private lazy var expirationLabel: UILabel = {
        let label = UILabel()
        label.text = "order_confirmation_code_expires_in".localized(.olchaEcoSystemCore)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("order_confirmation_update_code".localized(.olchaEcoSystemCore), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(updateCodeTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    private lazy var expiredLabel: UILabel = {
        let label = UILabel()
        label.text = "order_confirmation_code_expired".localized(.olchaEcoSystemCore)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .systemRed
        label.isHidden = true
        return label
    }()

    // MARK: - Lifecycle
    public init(viewModel: EcoOrderConfirmationViewModel?) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        fetchAndGenerateBarcode()
    }

    deinit {
        expirationTimer?.invalidate()
    }

    // MARK: - Setup
    public override func setupViews() {
        container.addSubview(instructionLabel)
        container.addSubview(barcodeContainerView)
        container.addSubview(codeLabel)
        container.addSubview(descriptionLabel)
        container.addSubview(progressContainerView)
        container.addSubview(expiredLabel)
        container.addSubview(updateButton)

        barcodeContainerView.addSubview(barcodeImageView)

        progressContainerView.addSubview(expirationLabel)
        progressContainerView.addSubview(timerLabel)
        progressContainerView.addSubview(progressBar)
    }

    public override func autolayout() {
        instructionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        barcodeContainerView.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(200)
        }

        barcodeImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }

        codeLabel.snp.makeConstraints { make in
            make.top.equalTo(barcodeContainerView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(codeLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        progressContainerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(100)
        }

        expirationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }

        timerLabel.snp.makeConstraints { make in
            make.top.equalTo(expirationLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }

        progressBar.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(6)
        }

        expiredLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        updateButton.snp.makeConstraints { make in
            make.top.equalTo(expiredLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
    }

    public override func configureViews() {
        navigationBar.setTitle("order_confirmation_title".localized(.olchaEcoSystemCore))
        view.backgroundColor = .systemBackground
    }

    // MARK: - Barcode Generation
    private func fetchAndGenerateBarcode() {
        // Show loading state
        instructionLabel.text = "order_confirmation_loading".localized(.olchaEcoSystemCore)

        viewModel?.fetchBarcode { [weak self] success, code in
            guard let self = self else { return }

            if success, let code = code {
                self.orderCode = code
                self.codeLabel.text = code
                self.instructionLabel.text = "order_confirmation_code_title".localized(.olchaEcoSystemCore)

                // Generate barcode image
                if let barcodeImage = self.generateBarcodeImage(from: code) {
                    self.barcodeImageView.image = barcodeImage
                }

                // Start expiration timer
                self.startExpirationTimer()
            } else {
                self.instructionLabel.text = "order_confirmation_failed".localized(.olchaEcoSystemCore)
                self.showError("order_confirmation_error_message".localized(.olchaEcoSystemCore))
            }
        }
    }

    private func generateBarcodeImage(from string: String) -> UIImage? {
        let data = string.data(using: .ascii)

        guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else {
            return nil
        }

        filter.setValue(data, forKey: "inputMessage")

        guard let ciImage = filter.outputImage else {
            return nil
        }

        // Scale the barcode image to make it larger and clearer
        let transform = CGAffineTransform(scaleX: 5, y: 5)
        let scaledCIImage = ciImage.transformed(by: transform)

        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledCIImage, from: scaledCIImage.extent) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }

    // MARK: - Timer Management
    private func startExpirationTimer() {
        remainingSeconds = 60
        isExpired = false
        updateTimerDisplay()

        expirationTimer?.invalidate()
        expirationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }

    @objc private func updateTimer() {
        remainingSeconds -= 1

        if remainingSeconds <= 0 {
            handleCodeExpiration()
        } else {
            updateTimerDisplay()
        }
    }

    private func updateTimerDisplay() {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        timerLabel.text = String(format: "%d:%02d", minutes, seconds)

        // Update progress bar
        let progress = Float(remainingSeconds) / 60.0
        UIView.animate(withDuration: 1.0) {
            self.progressBar.progress = progress
        }

        // Change color based on remaining time
        if remainingSeconds <= 10 {
            progressBar.progressTintColor = .systemRed
            timerLabel.textColor = .systemRed
        } else if remainingSeconds <= 30 {
            progressBar.progressTintColor = .systemOrange
            timerLabel.textColor = .systemOrange
        }
    }

    private func handleCodeExpiration() {
        expirationTimer?.invalidate()
        expirationTimer = nil
        isExpired = true

        // Hide progress container
        UIView.animate(withDuration: 0.3) {
            self.progressContainerView.isHidden = true
            self.expiredLabel.isHidden = false
            self.updateButton.isHidden = false
        }

        // Disable barcode interaction
        barcodeContainerView.alpha = 0.5
    }

    // MARK: - Actions
    @objc private func updateCodeTapped() {
        // Reset UI
        UIView.animate(withDuration: 0.3) {
            self.progressContainerView.isHidden = false
            self.expiredLabel.isHidden = true
            self.updateButton.isHidden = true
            self.barcodeContainerView.alpha = 1.0
        }

        // Reset timer colors
        progressBar.progressTintColor = .systemBlue
        timerLabel.textColor = .label

        // Fetch new barcode
        fetchAndGenerateBarcode()
    }

    // MARK: - Helpers
    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "order_confirmation_error_title".localized(.olchaEcoSystemCore),
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func showSuccessAndDismiss(message: String?) {
        let alert = UIAlertController(
            title: "Success",
            message: message ?? "Order confirmed successfully!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}
