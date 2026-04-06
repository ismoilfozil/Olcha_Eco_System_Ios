//
//  CartButton.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 13/09/22.
//


import UIKit
import Combine
import OlchaUI

protocol CartButtonProtocol: UIView {
    var count: Int { get set }
    var parentPush: PassthroughSubject<Bool, Never> { get set }
    var countButton: BasketCounterButton { get set }
    func setup()
    func setup(with data: ProductModel?)
    func checkButtonStates(isSold: Bool, isParentProduct: Bool)
}

open class CartButton: BaseView, CartButtonProtocol {

    //MARK: - UI Elements
    let container = UIStackView()
    let cartContainer = UIStackView()
    open var parentButton = BorderedButton()
    open var countButton = BasketCounterButton()
    open var simpleButton = BorderedButton()
    open var soldButton = BorderedButton()
    
    //MARK: - Reactive
    private var bag = Set<AnyCancellable>()
    @Published var count = 0
    var parentPush = PassthroughSubject<Bool, Never>()
    
    override public func setupViews() {
        addSubview(container)
        container.addArrangedSubview(cartContainer)
        cartContainer.addArrangedSubview(countButton)
        cartContainer.addArrangedSubview(simpleButton)
        container.addArrangedSubview(parentButton)
        container.addArrangedSubview(soldButton)
    }
    
    override public func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override public func configureViews() {
        container.axis = .horizontal
        container.distribution = .fill
        
        cartContainer.axis = .horizontal
        cartContainer.distribution = .fill
        
        
        countButton.disableZero = false
        
        soldButton.isHidden = true
        parentButton.isHidden = true
     
        observers()
    }
    
    private func observers() {
        parentButton.clicked { [weak self] in
            guard let self = self else { return }
            self.parentPush.send(true)
        }
        
        simpleButton.clicked { [weak self] in
            guard let self = self else { return }
            self.countButton.count = 1
            self.countButton.countClicked = .plus
            self.countButton.checkButtonStates()
        }
        
        countButton
            .$count
            .sink { [weak self] count in
                guard let self = self else { return }
                self.count = max(0, count)
                let isSimple = (count == 0)
                self.countButton.isHidden = isSimple
                self.simpleButton.isHidden = !isSimple
                self.countButton.checkButtonStates()
            }.store(in: &bag)
        
    }
    
    func setup() {
        simpleButton.setTitle("to_basket".localized())
        soldButton.setTitle("sold_out".localized())
        parentButton.setTitle("to_basket".localized())
    }
    
    func checkButtonStates(isSold: Bool, isParentProduct: Bool) {
        
        cartContainer.isHidden = true
        parentButton.isHidden = true
        soldButton.isHidden = true
        
        if isSold {
            soldButton.isHidden = false
        } else {
            if isParentProduct {
                parentButton.isHidden = false
            } else {
                cartContainer.isHidden = false
            }
        }
    }
    
    func setup(with product: ProductModel?) {
        countButton.count = product?.cart_count ?? 0
        countButton.maxCount = product?.quantity?.int ?? Int.max
        
        let outOfStock = product?.out_of_stock ?? false
        let isParent = product?.isParentProduct() ?? false
        checkButtonStates(isSold: outOfStock, isParentProduct: isParent)
    }
}
