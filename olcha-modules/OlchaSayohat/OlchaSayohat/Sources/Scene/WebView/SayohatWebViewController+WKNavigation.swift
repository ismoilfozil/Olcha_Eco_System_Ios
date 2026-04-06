import WebKit

extension SayohatWebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        splashContainer.isHidden = false
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        switch navigationAction.navigationType {
        case .linkActivated:
            decisionHandler(.cancel)
        default:
            decisionHandler(.allow)
        }
    }
    
    public func evaluateScripts() {
        if isFirstLoading {
            webView.evaluateJavaScript(makeTokenSetterJS())            
        }
        webView.evaluateJavaScript(makeLanguageSetterJS())
//        webView.evaluateJavaScript(makeNotchHeightSetterJS())
        webView.evaluateJavaScript(makeShowItemsSetterJS())
    }
}
