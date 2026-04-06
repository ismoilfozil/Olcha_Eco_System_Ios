//
//  DetailedNotificationViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 15/02/23.
//

import UIKit
import OlchaUI
public class DetailedNotificationViewController: BaseModalViewController {
    
    private lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.settings.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        return scrollView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 24)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.style(.medium, 14)
        return label
    }()
    
    var notification: NotificationModel? {
        didSet {
            fillDatas()
        }
    }
    
    let viewModel: NotificationsViewModel
    
    public init(viewModel: NotificationsViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public override func setupViews() {
        container.addSubview(scrollView)
        scrollView.addArrangedSubview(titleLabel)
        scrollView.addArrangedSubview(dateLabel)
        scrollView.addArrangedSubview(contentLabel)
    }
    
    public override func autolayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        dismissConfiguration()
        scrollView.container.setCustomSpacing(8, after: titleLabel)
        scrollView.container.setCustomSpacing(16, after: dateLabel)
    }
    
    
    private func fillDatas() {
        
        titleLabel.text = notification?.title
        dateLabel.text = notification?.date
        contentLabel.text = notification?.content
        
        view.layoutIfNeeded()
        setContainerHeight(scrollView.container.frame.height)
        
    }
    
}
