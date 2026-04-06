//
//  CreditCountProductRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 11/11/22.
//

import UIKit
import Combine
import OlchaUI
class CreditCountProductRoom: BaseTableCell {

    private let productContainer = BasketProduct()
    private let actionsContainer = UIStackView()
    let countButton = BasketCounterButton()
    let acceptButton = OlchaButton()
    private let separator = UIView()
    
    private var product: ProductModel?
    private var bag = Set<AnyCancellable>()
    weak var acceptClickObserver: PassthroughSubject<Int, Never>?
    weak var isReadyAccept: PassthroughSubject<Bool, Never>? {
        didSet {
            optionalObservers()
        }
    }
    weak var countObserver: PassthroughSubject<Int, Never>?
    
    override func setupViews() {
        container.addSubview(productContainer)
        container.addSubview(actionsContainer)
        
        actionsContainer.addArrangedSubview(countButton)
        actionsContainer.addArrangedSubview(acceptButton)
        
        container.addSubview(separator)
    }
    
    override func autolayout() {
        productContainer.snp.remakeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
        
        actionsContainer.snp.remakeConstraints { make in
            make.top.equalTo(productContainer.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(36)
        }
        
        separator.snp.remakeConstraints { make in
            make.height.equalTo(1)
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(actionsContainer.snp.bottom).inset(-16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        actionsContainer.axis = .horizontal
        actionsContainer.spacing = 12
        actionsContainer.distribution = .fillEqually
        
        acceptButton.setTitle("checkout".localized())
        separator.backgroundColor = .olchaLightNeutralGray
        
        setupObservers()
    }
    
    private func setupObservers() {
        acceptButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.acceptClickObserver?.send(self.countButton.count)
        }
        
        countButton
            .$count
            .sink { [weak self] count in
                guard let self = self else { return }
                self.countObserver?.send(count)
            }.store(in: &bag)

    }
    
    private func optionalObservers() {
        
        isReadyAccept?.sink { [weak self] isReady in
            guard let self = self else { return }
            isReady ? self.acceptButton.enableButton() : self.acceptButton.disableButton()
        }.store(in: &bag)
    }
    
    func setup(with data: ProductModel?) {
        self.product = data
        countButton.maxCount = product?.quantity?.int ?? 1
        countButton.disableZero = true
        productContainer.setup(with: product)
    }
}
