//
//  CategoryHeader.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 27/03/23.
//


import UIKit
public class CategoryHeader: UICollectionReusableView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .olchaDarkGray
        label.style(.semibold, 14)
        label.numberOfLines = 0
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        autolayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(titleLabel)
    }
    
    private func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview()
        }
    }
    
    public func setup(with title: String) {
        titleLabel.text = title
    }
}
