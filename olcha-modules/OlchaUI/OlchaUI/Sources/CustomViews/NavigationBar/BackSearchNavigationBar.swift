//
//  BackSearchNavigationBar.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 12/02/23.
//

import Foundation
public class BackSearchNavigationBar: BaseView, BaseNavigationInput {
    public weak var delegate: BaseNavigationOutput?
    lazy var backButton: IconButton = {
        let button = IconButton()
        button.setIcon(.left_anchor)
        return button
    }()
    
    lazy var searchView: SearchView = {
        let view = SearchView()
        view.setPlaceholder("search".localized() + "...")
        return view
    }()
    
    public override func setupViews() {
        addSubview(backButton)
        addSubview(searchView)
    }
    
    public override func autolayout() {
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        searchView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(backButton.snp.right).inset(-16)
            make.height.equalTo(36)
        }
    }
    
    public override func configureViews() {
        backButton.clicked { [weak self] in
            guard let self = self else { return }
            self.delegate?.backButtonClicked()
        }
    }
}
