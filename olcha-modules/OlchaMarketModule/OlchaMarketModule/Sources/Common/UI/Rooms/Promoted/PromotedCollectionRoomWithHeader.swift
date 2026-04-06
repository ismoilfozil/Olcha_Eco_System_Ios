//
//  PromotedCollectionRoomWithHeader.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 16/12/22.
//

import UIKit
import Combine
import OlchaUI
class PromotedCollectionRoomWithHeader: BaseCollectionCell {
    private var bag = Set<AnyCancellable>()
    let header = ComponentHeaderView()
    let responder = PromotedRoomView()
    
    var category: CategoryModel?
    
    weak var categoryProductsObserver: PassthroughSubject<(CategoryModel?, ProductsData?), Never>? {
        didSet {
            setupObservers()
        }
    }
    
    override func setupViews() {
        container.addSubview(header)
        container.addSubview(responder)
    }
    
    override func configureViews() {
    }
    
    private func setupObservers() {
        categoryProductsObserver?.sink(receiveValue: { [weak self] value in
            guard let self = self,
                  let category = value.0,
                  let productsData = value.1,
                  category == self.category
            else { return }
            self.header.configure(with: .title(category.getName()))
        }).store(in: &bag)
    }
    
    override func autolayout() {
        
        header.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.right.equalToSuperview()
        }
        
        responder.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}
