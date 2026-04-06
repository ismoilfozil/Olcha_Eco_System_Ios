//
//  WebPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 26/10/22.
//
import WebKit
import UIKit


public class WebPage: BaseViewController<BackNavigationBar> {

    private let webView = WKWebView()
    
    public var urlString: String = ""
    public var headerTitle: String?

    public override func setupViews() {
        container.addSubview(webView)
    }
    
    public override func autolayout() {
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        if let headerTitle {
            navigationBar.setTitle(headerTitle)
        }
        guard let url = URL(string: urlString) else { return }
        webView.load(URLRequest(url: url))
    }
    
}
