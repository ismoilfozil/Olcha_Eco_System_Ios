//
//  FinishActionsView.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 23/02/23.
//

import UIKit
import OlchaUI
public class FinishActionsView: BaseView {
    public lazy var saveButtonContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    public lazy var retryButtonContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    public lazy var detailButtonContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    public lazy var saveButton: IconButton = {
        let button = IconButton()
        button.backgroundColor = .olchaLightGray
        button.round(30)
        button.setIcon(.star, edgeSize: 15, isIgnoringEdge: false)
        
        return button
    }()
    
    public lazy var retryButton: IconButton = {
        let button = IconButton()
        button.backgroundColor = .olchaLightGray
        button.round(30)
        button.setIcon(.repeat, edgeSize: 15, isIgnoringEdge: false)
        
        return button
    }()
    
    public lazy var detailButton: IconButton = {
        let button = IconButton()
        button.backgroundColor = .olchaLightGray
        button.round(30)
        button.setIcon(.detail, edgeSize: 15, isIgnoringEdge: false)
        
        return button
    }()
    
    private lazy var buttonsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.spacing = 50
        return stackView
    }()
    
    private lazy var retryTitleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaDarkGray
        label.text = "retry".localized()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var saveTitleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaDarkGray
        label.text = "save".localized()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var detailTitleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaDarkGray
        label.text = "detail".localized()
        label.textAlignment = .center
        return label
    }()
    
    public override func setupViews() {
        addSubview(buttonsContainer)
        
        buttonsContainer.addArrangedSubview(saveButtonContainer)
        buttonsContainer.addArrangedSubview(retryButtonContainer)
        buttonsContainer.addArrangedSubview(detailButtonContainer)
        
        saveButtonContainer.addSubview(saveTitleLabel)
        saveButtonContainer.addSubview(saveButton)
        retryButtonContainer.addSubview(retryButton)
        retryButtonContainer.addSubview(retryTitleLabel)
        detailButtonContainer.addSubview(detailTitleLabel)
        detailButtonContainer.addSubview(detailButton)
        
    }
    
    public override func autolayout() {
        
        buttonsContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        retryButton.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        detailButton.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        saveTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).inset(-4)
            make.left.right.bottom.equalToSuperview()
        }
        
        retryTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(retryButton.snp.bottom).inset(-4)
            make.left.right.bottom.equalToSuperview()
        }
        
        detailTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(detailButton.snp.bottom).inset(-4)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    
    public override func configureViews() {
        saveButton.updateLayout(with: 30)
        retryButton.updateLayout(with: 30)
        detailButton.updateLayout(with: 30)
    }
}
