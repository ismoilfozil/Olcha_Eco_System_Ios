//
//  NotificationDetail.swift
//  OlchaCommon
//
//  Created by Elbek Khasanov on 23/02/24.
//

import UIKit
import OlchaUI
class NotificationDetailViewController: BaseViewController<EmptyNavigationBar> {
    
    private let headerView: UIView = {
        let view = UIView()
        return view
    }()
    private let backButtonSize: CGFloat = 40
    private lazy var backIconButton: IconButton = {
        let button = IconButton()
        button.setIcon(.back_left_anchor, edgeSize: 10, isIgnoringEdge: false)
        button.backgroundColor = .olchaWhite
        button.round(backButtonSize/2)
        button.addShadow(location: .bottom, color: .black.withAlphaComponent(0.8), opacity: 0.15, radius: backButtonSize/4)
        button.border(with: .olchaLightTextColornnnnnn, width: 0.1)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.textColor = .olchaTextBlack
        label.textAlignment = .center
        return label
    }()
    
    private let scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.container.spacing = 16
        scrollView.container.alignment = .center
        return scrollView
    }()
    
    private let contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 14)
        label.textColor = .olchaLightTextColornnnnnn
        label.numberOfLines = 0
        return label
    }()
    
    private let contentHeaderLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaDarkNeutralGray
        label.numberOfLines = 0
        return label
    }()
    
    public var notification: CommonNotificationModel? {
        didSet {
            setup()
        }
    }
    
    override func setupViews() {
        container.addSubview(scrollView)
        container.addSubview(headerView)
        headerView.addSubview(backIconButton)
        headerView.addSubview(titleLabel)
        scrollView.addArrangedSubview(view: contentImageView, horizontalEdge: 0)
        scrollView.addArrangedSubview(view: dateLabel, horizontalEdge: 16)
        scrollView.addArrangedSubview(view: contentHeaderLabel, horizontalEdge: 16)
        scrollView.addArrangedSubview(view: contentLabel, horizontalEdge: 16)
    }
    
    override func autolayout() {
        backIconButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.width.height.equalTo(backButtonSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(navigationHeight)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
        }
        
        contentImageView.snp.makeConstraints { make in
            make.height.equalTo(326)
        }
        
    }
    
    override func configureViews() {
        container.backgroundColor = .olchaLightGray
        view.backgroundColor = .olchaLightGray
        ignoreNavigationBar = true
        backIconButton.clicked { [weak self] in
            guard let self else { return }
            navigationController?.pop()
        }
    }
    
    func setup() {
        
        contentLabel.text = notification?.content
        
        dateLabel.text = notification?.date
        contentImageView.load(from: notification?.image)
        
        if notification?.image == nil {
            dateLabel.isHidden = true
            contentImageView.isHidden = true
            headerView.backgroundColor = .olchaLightGray
            titleLabel.text = notification?.title
            scrollView.settings.contentInset = .init(top: navigationHeight, left: 0, bottom: 0, right: 0)
        } else {
            dateLabel.isHidden = false
            contentHeaderLabel.text = notification?.title
            contentImageView.isHidden = false
            contentImageView.backgroundColor = .olchaLightTextColornnnnnn
            headerView.backgroundColor = .clear
            scrollView.settings.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        }
        
    }
}
