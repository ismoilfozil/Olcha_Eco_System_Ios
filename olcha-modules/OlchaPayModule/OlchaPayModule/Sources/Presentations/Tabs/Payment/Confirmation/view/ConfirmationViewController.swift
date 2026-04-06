//
//  ConfirmationViewController.swift
//  OlchaPayModule
//
//  Created by Claude Code
//

import UIKit
import OlchaUI
import SnapKit
import Combine

public class ConfirmationViewController: BaseViewController<EmptyNavigationBar> {

    // MARK: - ViewModel
    var viewModel: ConfirmationViewModel!
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Toolbar
    private lazy var toolbar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ic_arrow_back"), for: .normal)
        button.tintColor = .olchaTextBlack
        button.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        return button
    }()

    private lazy var toolbarTitleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 18)
        label.textColor = .olchaTextBlack
        label.text = "your_one_time_code".localized()
        label.textAlignment = .center
        return label
    }()

    // MARK: - Active State Views
    private lazy var activeStateContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaTextBlack
        label.text = "scan_the_code_below".localized()
        label.textAlignment = .center
        return label
    }()

    private lazy var qrCodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(qrCodeTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()

    private lazy var numericCodeLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 28)
        label.textColor = .olchaTextBlack
        label.text = "code_placeholder".localized()
        label.textAlignment = .center
        label.font = UIFont(name: "sans-serif-medium", size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .semibold)
        return label
    }()

    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaTextBlack
        label.text = "expires_in_45s".localized()
        label.textAlignment = .center
        return label
    }()

    private lazy var progressBar: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .bar)
        progress.progressTintColor = .olchaAccentColor
        progress.trackTintColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.0)
        progress.layer.cornerRadius = 2
        progress.clipsToBounds = true
        progress.progress = 0.75
        return progress
    }()

    // MARK: - Expired State Views
    private lazy var expiredStateContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()

    private lazy var expiredIconContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        view.layer.cornerRadius = 100
        view.clipsToBounds = true
        return view
    }()

    private lazy var expiredIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_expired")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .olchaDarkNeutralGray
        return imageView
    }()

    private lazy var expiredTitleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 22)
        label.textColor = .olchaTextBlack
        label.text = "code_expired".localized()
        label.textAlignment = .center
        return label
    }()

    private lazy var expiredMessageLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaDarkNeutralGray
        label.text = "please_request_new_code".localized()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var refreshCodeButton: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .olchaAccentColor
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(refreshCodeTapped))
        containerView.addGestureRecognizer(tapGesture)
        containerView.isUserInteractionEnabled = true

        return containerView
    }()

    private lazy var refreshIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_super_refresh_square")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var refreshLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .white
        label.text = "refresh_code".localized()
        label.textAlignment = .center
        return label
    }()

    // MARK: - Properties
    private var timer: Timer?
    private var remainingSeconds: Int = 45
    private var qrCodeString: String = ""
    private var userId: Int = 0

    public var onBack: (() -> Void)?

    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        bindViewModel()
    }

    // MARK: - Configuration
    public func configure(userId: Int) {
        self.userId = userId
        viewModel.generateBarcode(userId: userId)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }

    // MARK: - Setup
    public override func setupViews() {
        view.addSubview(toolbar)
        toolbar.addSubview(backButton)
        toolbar.addSubview(toolbarTitleLabel)

        view.addSubview(activeStateContainer)
        activeStateContainer.addSubview(instructionLabel)
        activeStateContainer.addSubview(qrCodeImageView)
        activeStateContainer.addSubview(numericCodeLabel)
        activeStateContainer.addSubview(timerLabel)
        activeStateContainer.addSubview(progressBar)

        view.addSubview(expiredStateContainer)
        expiredStateContainer.addSubview(expiredIconContainer)
        expiredIconContainer.addSubview(expiredIcon)
        expiredStateContainer.addSubview(expiredTitleLabel)
        expiredStateContainer.addSubview(expiredMessageLabel)
        expiredStateContainer.addSubview(refreshCodeButton)
        refreshCodeButton.addSubview(refreshIcon)
        refreshCodeButton.addSubview(refreshLabel)
    }

    private func setupConstraints() {
        toolbar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(56)
        }

        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }

        toolbarTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(backButton.snp.right)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        // Active State Constraints
        activeStateContainer.snp.makeConstraints { make in
            make.top.equalTo(toolbar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        instructionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.left.right.equalToSuperview().inset(24)
        }

        qrCodeImageView.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(120)
        }

        numericCodeLabel.snp.makeConstraints { make in
            make.top.equalTo(qrCodeImageView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(24)
        }

        timerLabel.snp.makeConstraints { make in
            make.top.equalTo(numericCodeLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(24)
        }

        progressBar.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(4)
        }

        // Expired State Constraints
        expiredStateContainer.snp.makeConstraints { make in
            make.top.equalTo(toolbar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        expiredIconContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }

        expiredIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(80)
        }

        expiredTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(expiredIconContainer.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(24)
        }

        expiredMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(expiredTitleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(24)
        }

        refreshCodeButton.snp.makeConstraints { make in
            make.top.equalTo(expiredMessageLabel.snp.bottom).offset(48)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }

        refreshIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }

        refreshLabel.snp.makeConstraints { make in
            make.left.equalTo(refreshIcon.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
    }

    // MARK: - Binding
    private func bindViewModel() {
        viewModel.$barcodeData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading:
                    // Show loading indicator if needed
                    self.showLoader()
                case .success(let response):
                    self.hideLoader()
                    if let code = response?.code {
                        self.setCode(code)
                        self.startTimer()
                    } else if let message = response?.message {
                        self.showToast(text: message)
                    }
                case .failure(let error):
                    self.hideLoader()
                    self.showToast(text: error?.message ?? "error_generating_barcode".localized())
                case .standart:
                    break
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Public Methods
    public func setCode(_ code: String) {
        qrCodeString = code
        numericCodeLabel.text = formatCode(code)
        qrCodeImageView.image = generateQRCode(from: code)
    }

    // MARK: - Private Methods
    private func formatCode(_ code: String) -> String {
        // Format code with spacing for readability
        var formatted = ""
        for (index, char) in code.enumerated() {
            if index > 0 && index % 4 == 0 {
                formatted += " "
            }
            formatted.append(char)
        }
        return formatted
    }

    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: .utf8)

        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")

        guard let ciImage = filter.outputImage else { return nil }

        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledImage = ciImage.transformed(by: transform)

        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else { return nil }

        return UIImage(cgImage: cgImage)
    }

    private func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: .utf8)

        guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")

        guard let ciImage = filter.outputImage else { return nil }

        let scaleX = 300 / ciImage.extent.width
        let scaleY = 150 / ciImage.extent.height
        let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        let scaledImage = ciImage.transformed(by: transform)

        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else { return nil }

        return UIImage(cgImage: cgImage)
    }

    private func startTimer() {
        remainingSeconds = 45
        updateTimerLabel()
        progressBar.progress = 1.0

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.remainingSeconds -= 1
            self.updateTimerLabel()

            let progress = Float(self.remainingSeconds) / 45.0
            UIView.animate(withDuration: 0.3) {
                self.progressBar.progress = progress
            }

            if self.remainingSeconds <= 0 {
                self.timer?.invalidate()
                self.showExpiredState()
            }
        }
    }

    private func updateTimerLabel() {
        timerLabel.text = String(format: "expires_in_%ds".localized(), remainingSeconds)
    }

    private func showExpiredState() {
        UIView.animate(withDuration: 0.3) {
            self.activeStateContainer.isHidden = true
            self.expiredStateContainer.isHidden = false
        }
    }

    private func showActiveState() {
        UIView.animate(withDuration: 0.3) {
            self.activeStateContainer.isHidden = false
            self.expiredStateContainer.isHidden = true
        }
    }

    // MARK: - Actions
    @objc private func backTapped() {
        onBack?()
        navigationController?.popViewController(animated: true)
    }

    @objc private func qrCodeTapped() {
        guard let barcodeImage = generateBarcode(from: qrCodeString) else { return }
        let fullscreenVC = FullscreenBarcodeViewController()
        fullscreenVC.setBarcodeImage(barcodeImage, code: qrCodeString)
        fullscreenVC.modalPresentationStyle = .fullScreen
        present(fullscreenVC, animated: true)
    }

    @objc private func refreshCodeTapped() {
        showActiveState()
        viewModel.refreshBarcode(userId: userId)
    }
}
