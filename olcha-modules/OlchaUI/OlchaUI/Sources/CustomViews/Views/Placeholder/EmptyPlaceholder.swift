//
//  PlaceholderView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 16/09/22.
//


import UIKit
import OlchaUtils

public class EmptyPlaceholder: UIView {
    
    private let container = UIView()
    
    public let contentContainerView = UIView()
    
    public let contentView = UIView()
    
    public let imageView = UIImageView()
    
    public let titleLabel = UILabel()
    
    public let subtitleLabel = UILabel()
    
    public let mainButton = OlchaButton()
    public let refreshButton: IButton = {
        let button = IButton()
        button.isHidden = true
        return button
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = .olchaAccentColor
        view.hidesWhenStopped = true
        view.startAnimating()
        return view
    }()
    
    private var mainButtonObserver: (() -> Void)?
    private var refreshButtonObserver: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        baseSetup()
    }
    
    private func baseSetup() {
        setupViews()
        autolayout()
        configureViews()
    }
    
    private func setupViews() {
        addSubview(container)
        container.addSubview(indicator)
        container.addSubview(contentContainerView)
        contentContainerView.addSubview(contentView)
        contentView.addSubview(imageView)
        contentContainerView.addSubview(titleLabel)
        contentContainerView.addSubview(subtitleLabel)
        contentContainerView.addSubview(mainButton)
        contentContainerView.addSubview(refreshButton)
    }
    
    private func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.centerX.centerY.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).inset(-16)
        }
        
        mainButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(160)
            make.height.equalTo(48)
            make.top.equalTo(subtitleLabel.snp.bottom).inset(-24)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainButton.snp.bottom).offset(10)
        }
        
        indicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).inset(-16)
            make.width.equalTo(159)
            make.height.equalTo(185)
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureViews() {
        container.backgroundColor = .olchaWhite
        titleLabel.style(.semibold, 42)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        subtitleLabel.style(.medium, 16)
        subtitleLabel.textColor = .olchaTextBlack
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        
        mainButton.setTitle("to_home".localized())
        
        mainButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.mainButtonObserver?()
        }
        
        setRefreshButton()
        refreshButton.clicked { [weak self] in
            guard let self else { return }
            refreshButtonObserver?()
        }
        
        imageView.image = .empty_placeholder
    }
    
    public func mainButtonClick(observer: (() -> Void)?) {
        self.mainButtonObserver = observer
    }
    
    public func refreshButtonClick(observer: (() -> Void)?) {
        self.refreshButtonObserver = observer
    }
    
    public func addContent(view: UIView) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(view)
        view.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    public func setRefreshButton(hidden: Bool) {
        refreshButton.isHidden = hidden
    }
    
    public func setRefreshButton(title: String = "empty_placeholder_refresh".localized()) {
        let stringAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.olchaBlue,
            .font: UIFont.style(.medium, 14),
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor.olchaBlue
        ]
        let attributedString = NSAttributedString(string: title, attributes: stringAttributes)
        refreshButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    public func setupTitle(_ title: String) {
        titleLabel.text = title
    }
    
    public func setupSubtitle(_ title: String) {
        subtitleLabel.text = title
    }
    
    public func setupButtonTitle(_ title: String = "to_home".localized()) {
        mainButton.setTitle(title)
    }
    
    public func setupImage(_ image: UIImage? = .empty_placeholder) {
        imageView.image = image
    }
    
    public func removeContent() {
        imageView.removeFromSuperview()
        titleLabel.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(subtitleLabel.snp.top).inset(-16)
        }
        
        subtitleLabel.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    public func setupIndicator(isLoading: Bool) {
        contentContainerView.isHidden = isLoading
        isLoading ? indicator.startAnimating() : indicator.stopAnimating()
    }
}
