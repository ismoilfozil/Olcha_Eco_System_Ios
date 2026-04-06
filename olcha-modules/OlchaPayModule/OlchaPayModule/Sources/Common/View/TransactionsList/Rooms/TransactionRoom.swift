//
//  PaymentListRoom.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 04/02/23.
//

import UIKit
import OlchaUI
public class TransactionRoom: BaseTableCell {
    
    private lazy var stackContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    public lazy var dateTitleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaTextBlack
        label.text = " - "
        return label
    }()
    
    private lazy var transactionContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private let skeletonView = UIView()
    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .olchaLightNeutralGray
        imageView.round(2)
        return imageView
    }()
    
    private lazy var titlesStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaLightTextColornnnnnn
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private lazy var valuesStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .trailing
        return stack
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .olchaBlackNeutral
        label.style(.medium, 14)
        label.textAlignment = .right
        return label
    }()
    
    private let statusView: TransactionStatusView = {
        let view = TransactionStatusView()
        return view
    }()
    
    private let imageSize: CGFloat = 36
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        icon.image = nil
        skeletonView.layoutSkeletonIfNeeded()
    }
    
    public override func setupViews() {
        container.addSubview(stackContainer)
        stackContainer.addArrangedSubview(dateTitleLabel)
        stackContainer.addArrangedSubview(transactionContainer)
        stackContainer.addArrangedSubview(skeletonView)
        
        transactionContainer.addSubview(icon)
        transactionContainer.addSubview(titlesStack)
        transactionContainer.addSubview(valuesStack)
        
        titlesStack.addArrangedSubview(titleLabel)
        titlesStack.addArrangedSubview(subtitleLabel)
        
        
        valuesStack.addArrangedSubview(statusView)
        valuesStack.addArrangedSubview(valueLabel)
    }
    
    public override func autolayout() {
        
        stackContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        dateTitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
        transactionContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
        icon.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(imageSize)
        }
        
        titlesStack.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).inset(-8)
            make.right.equalTo(valuesStack.snp.left).inset(-8)
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        valuesStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.right.equalToSuperview().inset(8)
        }
        
        skeletonView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(35)
        }
    }
    
    public override func configureViews() {
        makeSkeleton(views: [
            skeletonView
        ])
    }
    
    func setup(with data: TransactionModel?, oldData: TransactionModel?, withDate: Bool = true) {

        if withDate {
            dateTitleLabel.isHidden = false
            let date = data?.date()
            let oldDate = oldData?.date()
            
            dateTitleLabel.isHidden = (date == oldDate)
            dateTitleLabel.text = date
        } else {
            dateTitleLabel.isHidden = true
        }
        
        icon.load(from: data?.provider_service?.providers?.logo?.logo,
                  withIndicator: false,
                  withPlaceholder: false)
        
        titleLabel.text = data?.provider_service?.providers?.title_short
        subtitleLabel.text = data?.fields?.first { $0.is_money == false }?.value
        valueLabel.text = data?.amount?.string.originalPrice
        statusView.setup(title: data?.getStatus())
        statusView.setup(color: data?.getColor())
        skeletonView.isHidden = true
    }
 
    func skeletonChecker(isAnimating: Bool) {
        dateTitleLabel.isHidden = isAnimating
        transactionContainer.isHidden = isAnimating
        skeletonView.isHidden = !isAnimating
    }
}
