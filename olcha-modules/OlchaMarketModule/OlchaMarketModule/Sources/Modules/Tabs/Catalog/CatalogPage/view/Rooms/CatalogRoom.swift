//
//  CatalogRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 06/07/22.
//

import UIKit
import Combine
import OlchaUI
class CatalogRoom: BaseTableCell {
    
    
    
    private let containerStack = UIStackView()
    private let headerContainer = UIView()
    private let separator = UIView()
    private let catalogTitle = UILabel()
    private let expandButton = IconButton()
    private var category: CategoryModel?
    
    var expandButtonIsHidden: Bool = false {
        didSet {
            expandButton.isHidden = expandButtonIsHidden
        }
    }
    
    override func setupViews() {
        self.container.addSubview(containerStack)
        self.containerStack.addArrangedSubview(headerContainer)
        self.headerContainer.addSubview(separator)
        self.headerContainer.addSubview(catalogTitle)
        self.headerContainer.addSubview(expandButton)
    }
    
    override func autolayout() {
        self.containerStack.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        self.headerContainer.snp.makeConstraints { make in
            
            make.top.left.right.equalToSuperview()
            make.height.equalTo(44.0)
        }
        self.separator.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        self.catalogTitle.snp.makeConstraints { make in
            make.left.equalTo(self.separator.snp.left)
            make.centerY.equalToSuperview()
            make.right.equalTo(self.expandButton.snp.left).inset(-4)
        }
        
        self.expandButton.snp.makeConstraints { make in
            make.right.equalTo(self.separator.snp.right)
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        
    }
    
    override func configureViews() {
        self.containerStack.axis = .vertical
        self.containerStack.alignment = .top
        self.separator.backgroundColor = .olchaLightNeutralGray
        
        self.catalogTitle.style(.medium, 16)
        self.catalogTitle.textColor = .olchaTextBlack
        
        self.expandButton.setIcon(.unchecked)
        self.expandButton.isUserInteractionEnabled = false
    }
    
    func setup(model: CategoryModel?, step: Int, isSelectedItem: Bool) {
        catalogTitle.text = model?.getName()
        stepInsets(step)
        self.expandButton.setIcon(isSelectedItem ? .checked : .unchecked)
    }
    
    func expandeClick(action: @escaping () -> ()) {
        self.expandButton.clicked(action: action)
    }
    
    private func stepInsets(_ step: Int) {
        containerStack.snp.updateConstraints { make in
            make.left.equalToSuperview().inset(16*step)
        }
    }

}
