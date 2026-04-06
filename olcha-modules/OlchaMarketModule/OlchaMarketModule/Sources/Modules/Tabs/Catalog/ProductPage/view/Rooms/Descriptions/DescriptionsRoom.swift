//
//  DescriptionsRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 26/07/22.
//

import UIKit
import Combine
import OlchaUI
import WebKit

class DescriptionsRoom: BaseTableCell {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaLightTextColornnnnnn
        label.numberOfLines = 3
        return label
    }()
    
    private let webview = WebView()
    
    private let showAllButton: IButton = {
        let button = IButton()
        button.titleLabel?.style(.medium, 14)
        button.setTitleColor(.olchaBlue, for: .normal)
        return button
    }()
    
    var isExpanded: Bool = false {
        didSet {
            showAllButton.setTitle(isExpanded ? "less".localized() : "more".localized(), for: .normal)
            titleLabel.numberOfLines = isExpanded ? 0 : 3
        }
    }
    
    weak var mainTableReloader: PassthroughSubject<ProductPage.Sections, Never>?

    override func setupViews() {
        container.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(webview)
        stackView.addArrangedSubview(showAllButton)
    }
    
    override func autolayout() {
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.left.right.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
        webview.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
        showAllButton.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.left.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        showAllButton.clicked { [weak self] in
            guard let self = self else { return }
            self.isExpanded = !self.isExpanded
            mainTableReloader?.send(.all)
        }
        
        webview.heightUpdated = { [weak self] isUpdated in
            guard let self else { return }
//            contentView.layoutIfNeeded()
        }
    }
    
    func setup(with product: ProductModel?) {
        let isHtml = product?.isHtml() ?? false
        titleLabel.isHidden = isHtml
        showAllButton.isHidden = isHtml
        webview.isHidden = !isHtml
        
        if (isHtml) {
            setupWebView(product: product)
        } else {
            setupTitleLabel(product: product)
        }
    }
    
    private func setupTitleLabel(product: ProductModel?) {
        showAllButton.isHidden = (titleLabel.calculateMaxLines(actualWidth: UIScreen.main.bounds.width - 32) < 4)
        showAllButton.setTitle(isExpanded ? "less".localized() : "more".localized(), for: .normal)
        titleLabel.text = product?.getDescription()
    }
    
    private func setupWebView(product: ProductModel?) {
        webview.setup(html: product?.getDescription())
    }
}
class DescriptionsRoomView: BaseTableCellView {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaLightTextColornnnnnn
        label.numberOfLines = 3
        return label
    }()
    
    private let webview = WebView()
    
    let showAllButton: IButton = {
        let button = IButton()
        button.titleLabel?.style(.medium, 14)
        button.setTitleColor(.olchaAccentColor, for: .normal)
        button.backgroundColor = .olchaAccentColor.withAlphaComponent(0.1)
        button.setTitle("more".localized(), for: .normal)
        button.round(8)
        return button
    }()
    
    weak var mainTableReloader: PassthroughSubject<ProductPage.Sections, Never>?

    override func setupViews() {
        container.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(webview)
        stackView.addArrangedSubview(showAllButton)
    }
    
    override func autolayout() {
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.left.right.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
        webview.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
        showAllButton.snp.makeConstraints { make in
            make.height.equalTo(34)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        showAllButton.clicked { [weak self] in
            guard let self = self else { return }
            
        }
        
        webview.heightUpdated = { [weak self] isUpdated in
            guard let self else { return }
            container.layoutIfNeeded()
        }
    }
    
    func setup(with product: ProductModel?) {
        let isHtml = false//product?.isHtml() ?? false
        titleLabel.isHidden = isHtml
        showAllButton.isHidden = isHtml
        webview.isHidden = !isHtml
        
        if (isHtml) {
            setupWebView(product: product)
        } else {
            setupTitleLabel(product: product)
        }
    }
    
    private func setupTitleLabel(product: ProductModel?) {
        showAllButton.isHidden = (titleLabel.calculateMaxLines(actualWidth: UIScreen.main.bounds.width - 32) < 4)
        titleLabel.text = product?.getShortDescription()
    }
    
    private func setupWebView(product: ProductModel?) {
        webview.setup(html: product?.getShortDescription())
    }
}
