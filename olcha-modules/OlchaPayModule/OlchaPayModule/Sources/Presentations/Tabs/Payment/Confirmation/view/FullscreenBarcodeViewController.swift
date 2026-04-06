//
//  FullscreenBarcodeViewController.swift
//  OlchaPayModule
//
//  Created by Claude Code
//

import UIKit
import OlchaUI
import SnapKit

public class FullscreenBarcodeViewController: UIViewController {

    // MARK: - Views
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ic_close"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()

    private lazy var numericCodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()

    private lazy var barcodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        return imageView
    }()

    // MARK: - Properties
    private var barcodeImage: UIImage?
    private var codeString: String = ""

    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }

    // MARK: - Setup
    private func setupViews() {
        view.addSubview(closeButton)
        view.addSubview(numericCodeLabel)
        view.addSubview(barcodeImageView)

        numericCodeLabel.text = formatCode(codeString)
        barcodeImageView.image = barcodeImage
    }

    private func setupConstraints() {
        closeButton.snp.makeConstraints { make in
            make.top.left.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.height.equalTo(48)
        }

        numericCodeLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.bottom.equalTo(barcodeImageView.snp.top).offset(-32)
        }

        barcodeImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(150)
        }
    }

    // MARK: - Public Methods
    public func setBarcodeImage(_ image: UIImage, code: String) {
        barcodeImage = image
        codeString = code
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

    // MARK: - Actions
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}
