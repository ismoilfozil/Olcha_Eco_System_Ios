//
//  SearchNavigationBar.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 28/10/22.
//

import SnapKit
import UIKit
public class SearchNavigationBar: UIView, BaseNavigationInput {
    public weak var delegate: BaseNavigationOutput?
    private let container: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 16
        view.alignment = .center
        view.distribution = .fill
        return view
    }()
    public let backButton = IconButton()
    public let searchView = SearchView()
    
    public var backButtonHidden = false {
        didSet {
            backButton.isHidden = backButtonHidden
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViews()
    }
    
    private func initViews() {
        addSubview(container)
        container.addArrangedSubview(backButton)
        container.addArrangedSubview(searchView)
        
        container.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        
        searchView.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        
        configureViews()
    }
    
    private func configureViews() {
        backButton.setIcon(.left_anchor)
        searchView.setPlaceholder()
        
        backButton.clicked { [weak self] in
            guard let self = self else { return }
            self.delegate?.backButtonClicked()
        }
    }
    
}
