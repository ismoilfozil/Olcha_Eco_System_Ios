//
//  IslamicPopUpView.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 26/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class IslamicPopUpViewController: InvestBaseViewController<EmptyNavigationBar> {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView(image: .mosquePic)
        imageView.contentMode = .scaleAspectFill
        imageView.round(16)
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let closeButton: IconButton = {
        let button = IconButton()
        button.round(18)
        button.setIcon(.multiply?.withTintColor(.white), edgeSize: 10, isIgnoringEdge: false)
        button.backgroundColor = .olchaBlackNeutral?.withAlphaComponent(0.35)
        return button
    }()
    
    private let contentBackground: UIVisualEffectView = {
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        effectView.layer.cornerRadius = 12
        effectView.layer.masksToBounds = true
        return effectView
    }()
    
    private let contentBackgroundBorder = CornerBorderView()
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.bold, 24)
        label.textColor = .olchaBlackNeutral
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = .style(.regular, 16)
        textView.textColor = .olchaBlackNeutral
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        textView.showsVerticalScrollIndicator = false
        return textView
    }()
    
    private let unsubscribeButton: IButton = {
        let button = IButton()
        button.setTitle("Закрыть и больше не показывать", for: .normal)
        button.titleLabel?.textColor = .grayBorder
        button.titleLabel?.font = .style(.regular, 14)
        return button
    }()
    
    public override func setupViews() {
        view.addSubview(containerView)
        containerView.addSubview(backgroundImage)
        backgroundImage.addSubview(closeButton)
        backgroundImage.addSubview(contentBackground)
        containerView.addSubview(unsubscribeButton)
        contentBackground.contentView.addSubview(contentBackgroundBorder)
        contentBackground.contentView.addSubview(contentStack)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(descriptionTextView)
    }
    
    public override func autolayout() {
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(300)
            make.center.equalToSuperview()
        }
        backgroundImage.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        closeButton.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(12)
            make.width.height.equalTo(36)
        }
        contentBackground.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview().inset(16)
            make.top.equalTo(closeButton.snp.bottom).offset(10)
        }
        unsubscribeButton.snp.makeConstraints { make in
            make.top.equalTo(backgroundImage.snp.bottom)//.offset(12)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
        contentBackgroundBorder.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        descriptionTextView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(200)
            make.height.lessThanOrEqualTo(600)
        }
    }
    
    public override func configureViews() {
        view.backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    public override func setupObservers() {
        closeButton.clicked { [weak self] in
            self?.remove()
        }
        unsubscribeButton.clicked { [weak self] in
            self?.showLoader()
            NotificationManager.default.unsubscribe?("messages") { _ in
                InvestGlobalDefaults.settings.messagesNotificationDisabled = true
                self?.hideLoader()
                self?.remove()
            }
        }
    }
    
    public func setupContent(title: String?, description: String?) {
        titleLabel.text = title
        descriptionTextView.text = description
    }
    
    
}
