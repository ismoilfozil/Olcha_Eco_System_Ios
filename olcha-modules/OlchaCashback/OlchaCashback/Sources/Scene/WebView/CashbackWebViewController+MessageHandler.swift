import OlchaUI
import OlchaUtils
import WebKit

extension CashbackWebViewController: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == CashbackWebViewController.contentController else { return }
        guard let messageBody = message.body as? [String: Any] else { return }
        guard let methodText = messageBody["method"] as? String else { return }
        guard let method = MessageMethod(rawValue: methodText) else { return }
        guard let body = messageBody["body"] as? [String: Any] else { return }
        
        debugPrint(method, body)
        switch method {
        case .close_webview:
            setViewClosed()
        case .language:
            guard let language = body["language"] as? String else { return }
            setLanguage(with: language)
        case .qr:
            guard let opened = body["opened"] as? Bool else { return }
            setBrightness(opened: opened)
        case .token:
            guard let token = body["token"] as? String else { return }
            setToken(with: token)
        }
    }
}

private extension CashbackWebViewController {
    func setViewClosed() {
        ModuleGeneratorHelper.shared.generateParent()
    }
    
    func setToken(with token: String) {
        
    }
    
    func setLanguage(with language: String) {
        String.setAppLanguage(language)
        LanguageObserver.shared.observer.send()
    }
    
    func setBrightness(opened: Bool) {
        self.brightness = opened ? UIScreen.main.brightness : self.brightness
        UIScreen.setBrightness(to: opened ? 1 : self.brightness)
    }
}
