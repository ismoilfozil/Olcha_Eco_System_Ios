//
//  ProductDescriptionsModalPage.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 19/02/24.
//

import UIKit
import OlchaUI
import WebKit
class ProductDescriptionsModalPage: BaseModalViewController {
    
    private let webView: WebView = {
        let webView = WebView()
        return webView
    }()
    
    override func setupViews() {
        container.addSubview(webView)
    }
    
    override func autolayout() {
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
//            make.height.equalTo(UIScreen.main.bounds.height)
        }
    }
    
    override func configureViews() {
        setHeader(title: "description".localized())
        xButton.isHidden = true
        setContainerHeight()
    }
    
    func setup(product: ProductModel?) {
        if product?.getDescription().isEmpty ?? true {
            webView.setup(html: product?.getShortDescription())
        } else {
            webView.setup(html: product?.getDescription())
        }
    }
    
}
