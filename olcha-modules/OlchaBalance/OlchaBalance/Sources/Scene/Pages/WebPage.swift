//
//  WebPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 26/10/22.
//
import WebKit
import UIKit
import OlchaUI

public class BalanceWebPage: BaseViewController<BackNavigationBar> {

    private let webView = WKWebView()
    
    var urlString: String = ""
    
    public weak var coordinator: BalanceCoordinatorProtocol?
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coordinator?.balanceFilled?.send()
    }
    
    public override func setupViews() {
        container.addSubview(webView)
    }
    
    public override func autolayout() {
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        guard let url = URL(string: urlString) else { return }
        webView.load(URLRequest(url: url))
        
        navigationBar.backButton.clicked { [weak self] in
            guard let self = self else { return }
            self.popPage()
        }
    }
    
    public func popPage() {
        coordinator?.dismissToRoot()
    }
}
