

import UIKit
import Combine
import OlchaUI
class CartVariationHeaderRoom: BaseTableCell {
    private var bag = Set<AnyCancellable>()

    private let productContainer = BasketProduct()
    let productButton = IButton()
    
    var fullProduct: FullProductData?
    var product: ProductModel?
    weak var productHelper: ProductHelper?
    
    override func setupViews() {
        container.addSubview(productContainer)
        
        container.addSubview(productButton)
    }
    
    override func autolayout() {
        productContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
            
        }
        
        productButton.snp.makeConstraints { make in
            make.edges.equalTo(productContainer)
        }
    }
    
    override func configureViews() {
        productContainer.backgroundColor = .clear
        setupObservers()
    }
    
    private func setupObservers() {
        productButton.clicked { [weak self] in
            guard let self = self else { return }
            self.productHelper?.pushProduct.send(self.product)
        }
    }
    
    func setup(with data: ProductModel?, fullProduct: FullProductData?) {
        self.product = data
        fillWithData()
    }
    
    private func fillWithData() {
        productContainer.setup(with: product)
    }
    
}
