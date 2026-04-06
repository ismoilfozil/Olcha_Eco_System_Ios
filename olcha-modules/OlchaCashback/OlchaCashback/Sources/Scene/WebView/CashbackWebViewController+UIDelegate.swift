import WebKit

extension CashbackWebViewController: WKUIDelegate {
    public func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKContextMenuElementInfo) -> Bool {
        return false
    }
}
