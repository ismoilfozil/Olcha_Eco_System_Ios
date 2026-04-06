//
//  NotificationRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/10/22.
//

import UIKit
import OlchaUI
enum NotificationType: String {
    case celebration
    case newspaper
    case percentage
    case truck_loading
    case truck
    
    var icon: UIImage? {
        switch self {
        case .celebration:
            return .celebration
        case .newspaper:
            return .newspaper
        case .percentage:
            return .percentage
        case .truck_loading:
            return .truck_loading
        case .truck:
            return .truck
        }
    }
}

class NotificationRoom: BaseTableCell {
    
    private let notificationIcon = UIImageView()
    
    private let notificationState = UIView()
    
    private let titleLabel = UILabel()
    
    let expandeButton = IconButton()
    
    private let contentStack = UIStackView()
    
    private let contentLabel = UILabel()
    
    private let contentImage = UIImageView()
    
    var isExpande = false {
        didSet {
            isExpande ? expande() : shrink()
        }
    }
    
    var data: NotificationEntity?
    
    let type : NotificationType = .truck_loading
    
    override func setupViews() {
        container.addSubview(notificationIcon)
        container.addSubview(notificationState)
        container.addSubview(titleLabel)
        container.addSubview(expandeButton)
        container.addSubview(contentStack)
        contentStack.addArrangedSubview(contentLabel)
        contentStack.addArrangedSubview(contentImage)
    }
    
    
    override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 8
        
        notificationIcon.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(12)
            make.width.height.equalTo(32)
        }
        
        notificationState.snp.makeConstraints { make in
            make.top.equalTo(notificationIcon.snp.top).inset(-3)
            make.left.equalTo(notificationIcon.snp.left).inset(-3)
            make.width.height.equalTo(6)
        }
        
        expandeButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.top.right.equalToSuperview().inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(notificationIcon.snp.right).inset(-8)
            make.right.equalTo(expandeButton.snp.left).inset(-8)
            make.top.equalToSuperview().inset(12)
        }
        
        contentStack.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(12)
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(expandeButton.snp.bottom).inset(-4)
            make.bottom.equalToSuperview().inset(12)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        contentImage.snp.makeConstraints { make in
            make.height.equalTo(136)
            make.left.right.equalToSuperview()
        }
    }
    
    override func configureViews() {
        container.round()
        container.backgroundColor = .grayBackground
        
        notificationState.backgroundColor = .olchaAccentColor
        notificationState.round(3)
        
        notificationIcon.round(6)
        notificationIcon.backgroundColor = .olchaWhite
        
        
        titleLabel.style(.bold, 16)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.numberOfLines = 0
        
        contentLabel.style(.regular, 14)
        contentLabel.textColor = .olchaTextBlack
        contentLabel.numberOfLines = 2
        
        expandeButton.setIcon(.arrow_down)
        contentStack.spacing = 8
        contentStack.axis = .vertical
        contentImage.isHidden = true
        contentImage.round()
        
    }
    
    func setup(with data: NotificationEntity?) {
        
        self.data = data
        titleLabel.text = data?.getTitle() ?? ""
        contentLabel.text = data?.getText() ?? ""
        notificationIcon.load(from: data?.icon)

        checkNotificationState()
    }
    
    func shrink() {
        self.contentLabel.numberOfLines = 2
    }
    
    func expande() {
        self.contentLabel.numberOfLines = 0
        //image show
    }
    
    func checkNotificationState() {
        notificationState.isHidden = (data?.read ?? false)
    }
}
