//
//  SuggestionCollectionHeaderReusableView.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 15/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class SuggestionCollectionHeaderReusableView: UICollectionReusableView {
 
    private let headingLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20.0)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func baseSetup() {
        setupViews()
        autolayout()
        configureViews()
    }
    
    public func setupViews() {
        addSubview(headingLabel)
    }
    
    public func autolayout() {
        headingLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func configureViews() {
//        headingLabel.text = "Мастер-класс"
    }
    
    public func setHeading(text: String) {
        headingLabel.text = text
    }
    
}
