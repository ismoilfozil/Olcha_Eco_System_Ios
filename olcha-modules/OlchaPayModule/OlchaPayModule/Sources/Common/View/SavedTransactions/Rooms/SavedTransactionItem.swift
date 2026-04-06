//
//  SavedTransactionItem.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 31/03/23.
//

import UIKit
import OlchaUI
import DropDown
public class SavedTransactionItem: BaseCollectionCell {
    
    public let dropDown = DropDown()
    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public lazy var menuButton: IconButton = {
        let button = IconButton()
        button.setIcon(.dots?.withColor((.olchaDarkGray ?? .darkGray)), isIgnoringEdge: true)
        return button
    }()
    
    private lazy var titlesStackview: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 14)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "                           "
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 12)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "                           "
        return label
    }()
    
    public var withBorder: Bool = false {
        didSet {
            container.border(with: .olchaLightNeutralDarkGray, width: withBorder ? 1 : 0)
        }
    }
    
    private var dataModel: SavedTransactionModel?
    
    public var editTransaction: (() -> Void)?
    
    public var deleteTransaction: (() -> Void)?
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = "                           "
        subtitleLabel.text = "                           "
    }
    
    public override func setupViews() {
        container.addSubview(icon)
        container.addSubview(menuButton)
        container.addSubview(titlesStackview)
        titlesStackview.addArrangedSubview(titleLabel)
        titlesStackview.addArrangedSubview(subtitleLabel)
    }
    
    public override func autolayout() {
        horizontalEdge = 4
        verticalEdge = 4
        icon.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(12)
            make.width.height.equalTo(36)
        }
        
        menuButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(8)
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        titlesStackview.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).inset(-2)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.greaterThanOrEqualToSuperview().inset(4)
        }
    }
    
    public override func configureViews() {
        container.round()
        menuButton.isHidden = true
        dropDown.configure(menuButton,
                           ["delete".localized(),
                            "edit".localized()],
                           offset: 50)
        dropDown.selectionBackgroundColor = .olchaWhite
        dropDown.selectionAction = { [weak self] index, _ in
            guard let self = self else { return }
            if index == 0 {
                self.deleteTransaction?()
            } else {
                self.editTransaction?()
            }
        }
        
        makeSkeleton(views: [
            container,
            titleLabel,
            subtitleLabel,
            icon,
            menuButton
        ])
    }
    
    public func setup(data: SavedTransactionModel) {
        self.dataModel = data
        icon.load(from: data.provider_service?.providers?.logo?.logo)
        titleLabel.text = data.name
        subtitleLabel.text = data.service_price?.string.originalPrice
    }
    
}
