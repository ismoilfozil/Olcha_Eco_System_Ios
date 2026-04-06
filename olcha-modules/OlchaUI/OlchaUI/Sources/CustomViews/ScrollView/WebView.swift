//
//  WebView.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 31/10/23.
//

import WebKit
import UIKit
public class WebView: BaseView {
    
    public lazy var settings: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = true
        webView.uiDelegate = self
        return webView
    }()
    
    var contentSize: CGSize? {
        didSet {
            if oldValue != contentSize {
                heightUpdated?(true)
            }
        }
    }
    
    public var heightUpdated: ((Bool) -> Void)?
    
    public override func setupViews() {
        addSubview(settings)
    }
    
    public override func autolayout() {
        settings.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func setup(html: String?) {
        if let html {
            settings.loadHTMLString(html, baseURL: nil)
        }
    }
    
}

extension WebView: WKNavigationDelegate, WKUIDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard !webView.isLoading else { return }
        setupJS()
    }
}
