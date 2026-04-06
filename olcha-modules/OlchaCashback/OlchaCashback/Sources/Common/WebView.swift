import Foundation

@MainActor public protocol WebView {
    func setup()
    func loadWebView()
    func setupViews()
    func configureViews()
    func autoLayout()
    func setupObservers()
}

public extension WebView {
    func setup() {
        loadWebView()
        setupViews()
        configureViews()
        autoLayout()
        setupObservers()
    }
}
