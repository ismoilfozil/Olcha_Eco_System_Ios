//
//  NotificationRoom.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 15/02/23.
//

import UIKit
import OlchaUI
public class NotificationRoom: BaseTableCell {
    
    private lazy var stackContainer : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()

    private lazy var headerDateContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .olchaLightNeutralGray
        return view
    }()
    
    private lazy var headerDateLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaTextBlack
        label.textAlignment = .left
        return label
    }()
    
    private lazy var contentContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var titleContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var readTracker: UIView = {
        let view = UIView()
        view.backgroundColor = .olchaAccentColor
        view.isHidden = true
        return view
    }()
    
    private lazy var titlesStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 16)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaDarkGray
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaDarkGray
        label.numberOfLines = 3
        return label
    }()
    
    public lazy var moreButton: IButton = {
        let button = IButton()
        button.titleLabel?.style(.semibold, 16)
        button.setTitleColor(.olchaTextBlack, for: .normal)
        return button
    }()
    
    private let format: (String, String) = ("yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ", "dd-MM-yyyy")
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        readTracker.isHidden = true
    }
    
    public override func setupViews() {
        container.addSubview(stackContainer)
        stackContainer.addArrangedSubview(headerDateContainer)
        headerDateContainer.addSubview(headerDateLabel)
        stackContainer.addArrangedSubview(contentContainer)
        
        contentContainer.addSubview(readTracker)
        contentContainer.addSubview(titlesStack)
        
        titlesStack.addArrangedSubview(titleContainer)
        titleContainer.addSubview(titleLabel)
        titleContainer.addSubview(dateLabel)
        titlesStack.addArrangedSubview(contentLabel)
        titlesStack.addArrangedSubview(moreButton)
    }
    
    public override func autolayout() {
        
        stackContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.top.equalToSuperview().inset(16)
        }
        
        headerDateContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        headerDateLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(4)
            make.top.bottom.equalToSuperview().inset(4)
        }
        
        contentContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        readTracker.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(10)
        }
        
        titlesStack.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview().inset(16)
            make.left.equalTo(readTracker.snp.right).inset(-8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).inset(-24)
        }
        
        moreButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        horizontalEdge = 16
    }
    
    public override func configureViews() {
        container.round()
        container.border(with: .olchaLightNeutralGray, width: 1)
    }
    
    func setup(with data: NotificationModel?, oldData: NotificationModel?) {
        
        let date = data?.date?.formatDate(format)
        let oldDate = oldData?.date?.formatDate(format)
        
        headerDateContainer.isHidden = (date == oldDate)
        headerDateLabel.text = date
        
        moreButton.setTitle("more".localized(), for: .normal)
        titleLabel.text = data?.title
        dateLabel.text = (data?.date ?? "").formated_date_time
        contentLabel.text = data?.content
        readTracker.isHidden = (data?.isRead ?? false)
        
        moreButton.isHidden = contentLabel.calculateMaxLines() < 4
    }
}
