//
//  WebView+Extension.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 31/10/23.
//

import UIKit
import WebKit
extension WebView {
    func setupJS() {
        
        let javascriptStyle =
    """
        var css = 'img{width: 100%}';
        var head = document.head || document.getElementsByTagName('head')[0];
        var style = document.createElement('style');
        style.type = 'text/css';
        style.appendChild(document.createTextNode(css));
        head.appendChild(style);
        document.body.style.fontSize = '300%';
    """
        settings.evaluateJavaScript(javascriptStyle) { [weak self] (result, error) in
            guard let self else { return }
//            enableSize()
        }
        
    }
    
    func enableSize() {
        settings.frame.size.height = 1
        settings.frame.size = settings.sizeThatFits(.zero)
        settings.scrollView.isScrollEnabled = false
        settings.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(settings.scrollView.contentSize.height)
        }
    }
}
