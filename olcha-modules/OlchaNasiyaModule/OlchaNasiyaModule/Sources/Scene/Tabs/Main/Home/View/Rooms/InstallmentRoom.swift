//
//  InstallmentRoom.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 11/05/23.
//

import UIKit
import OlchaUI
import OlchaUtils
class InstallmentRoom: BaseTableCell {
    
    private let titlesStackContainer = UIView()
    
    private let titlesStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.textColor = .olchaBlue
        label.style(.medium, 14)
        label.text = "                                                                            "
        return label
    }()
    
    private let statusView: InstallmentStatusView = {
        let view = InstallmentStatusView()
        return view
    }()
    
    public let moreButton: RightIconButton = {
        let button = RightIconButton()
        button.round()
        button.backgroundColor = .olchaAccentColor
        button.buttonTitle.textColor = .olchaWhite
        button.buttonTitle.style(.regular, 11)
        return button
    }()
    
    var data: InstallmentModel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        data = nil
        setup(with: nil)
    }
    
    override func setupViews() {
        container.addSubview(headerView)
        headerView.addSubview(idLabel)
        headerView.addSubview(statusView)
        container.addSubview(titlesStackContainer)
        titlesStackContainer.addSubview(titlesStack)
        container.addSubview(moreButton)
    }
    
    override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 8
        
        headerView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(16)
            make.bottom.equalTo(titlesStack.snp.top).inset(-12)
        }
        
        idLabel.snp.makeConstraints { make in
            make.bottom.top.left.equalToSuperview()
        }
        
        statusView.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
        }
        
        titlesStackContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
        titlesStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(titlesStack.snp.bottom).inset(-16)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(30)
            make.right.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        container.backgroundColor = .lightGrayBackground
        container.round(12)
        createExtraTitles()
        
        makeSkeleton(views: [
            
            container,
            titlesStackContainer,
            headerView,
            statusView,
            idLabel,
            moreButton
            
        ])

    }
    
    public func setup(with data: InstallmentModel?) {
        self.data = data
        
        idLabel.text = "№\(data?.id ?? 0)"
        statusView.setup(installment: data)
        
        createExtraTitles()
        
        moreButton.configure(image: .right_arrow,
                             title: "detailed".localized(.olchaNasiyaModule),
                             size: 14,
                             padding: 16)
    }
    
    
    private func createExtraTitles() {
        
        titlesStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let items: [KeyValueModel] = [
            .init(key: "price".localized(), value: data?.total_cost?.string.originalPrice ?? " "),
            .init(key: "next_payment".localized(.olchaNasiyaModule),
                  value: (data?.next_payment ?? " ").formatDate((input: Date.dateFormat,
                                                                 output: "yyyy-MM-dd"))),
            .init(key: "store".localized(.olchaNasiyaModule), value: data?.name ?? " "),
        ]
        
        for item in items {
            let separator = Divide()
            titlesStack.addArrangedSubview(separator)
            separator.snp.makeConstraints { $0.left.right.equalToSuperview() }
            
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            
            
            let leftTitle = UILabel()
            leftTitle.style(.semibold, 14)
            leftTitle.textColor = .black
            leftTitle.textAlignment = .left
            leftTitle.numberOfLines = 0
            leftTitle.text = item.key
            
            let rightTitle = UILabel()
            rightTitle.style(.regular, 14)
            rightTitle.textColor = .black
            rightTitle.textAlignment = .right
            rightTitle.numberOfLines = 0
            rightTitle.text = item.value
            
            stackView.addArrangedSubview(leftTitle)
            stackView.addArrangedSubview(rightTitle)
            
            titlesStack.addArrangedSubview(stackView)
        }
    }
}
