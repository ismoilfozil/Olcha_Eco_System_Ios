import WebKit

extension SayohatWebViewController: WKUIDelegate {
    public func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKContextMenuElementInfo) -> Bool {
        return false
    }
}
