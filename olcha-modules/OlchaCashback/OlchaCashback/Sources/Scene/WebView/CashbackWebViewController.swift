import UIKit
import Combine
import CoreLocation
import OlchaUI
import OlchaAuth
import OlchaUtils
import WebKit
import SnapKit

public class CashbackWebViewController: UIViewController {
    
    public var brightness: CGFloat = 0
    private let locationManager: LocationManager = .default
    private var bag = Set<AnyCancellable>()
    
    public lazy var userContentController: WKUserContentController = {
        let contentController = WKUserContentController()
        contentController.add(self, name: CashbackWebViewController.contentController)
        let languageJS = makeLanguageSetterJS()
        let languageScript = WKUserScript(source: languageJS, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let tokenJS = makeTokenSetterJS()
        let tokenScript = WKUserScript(source: tokenJS, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let notchJS = makeNotchHeightSetterJS()
        let notchScript = WKUserScript(source: notchJS, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let locationJS = makeLocationSetterJS()
        let locationScript = WKUserScript(source: locationJS, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        contentController.addUserScript(languageScript)
        contentController.addUserScript(tokenScript)
        contentController.addUserScript(notchScript)
        contentController.addUserScript(locationScript)
        return contentController
    }()
    
    public lazy var webView: WKWebView = {
        let preferences = WKPreferences()
        preferences.setValue("@YES", forKey: "allowFileAccessFromFileURLs")
        let config = WKWebViewConfiguration()
        config.preferences = preferences
        config.userContentController = userContentController
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        return webView
    }()
        
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}

extension CashbackWebViewController: WebView {
    public func loadWebView() {
        let url = URL(string: Texts.urls.cashbackWeb)
        guard let url else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    public func setupViews() {
        view.addSubview(webView)
    }
    
    public func configureViews() {
        view.backgroundColor = .white
    }
    
    public func autoLayout() {
        webView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-UIApplication.shared.topInset)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    public func setupObservers() {
        LocationManager.default.$status
            .sink(receiveValue: { [weak self] status in
                guard let self else { return }
                switch status {
                case .authorizedAlways, .authorizedWhenInUse:
                    let script = makeLocationSetterJS()
                    webView.evaluateJavaScript(script)
                case .denied, .restricted:
                    showLocationPermissionAlert()
                default: break
                }
            })
            .store(in: &bag)
    }
}

private extension CashbackWebViewController {
    func makeTokenSetterJS() -> String {
        "window.web_postMessage.token('\(AuthGlobalDefaults.getToken())')"
    }
    
    func makeLanguageSetterJS() -> String {
        "window.web_postMessage.language('\(String.getAppLanguage())')"
    }
    
    func makeNotchHeightSetterJS() -> String {
        "window.web_postMessage.notch(\(Int(UIApplication.shared.topInset)))"
    }
    
    func makeLocationSetterJS() -> String {
        guard locationManager.status ==  .authorizedAlways || locationManager.status == .authorizedWhenInUse else {
            return ""
        }
        guard let location2D = locationManager.currentLocationCoordinate else { return "" }
        let lat = location2D.latitude
        let long = location2D.longitude
        return "window.web_postMessage.location({latitude: \(lat), longitude: \(long)})"
    }
}

public extension CashbackWebViewController {
    enum MessageMethod: String {
        case qr
        case token
        case language
        case close_webview
    }
    
    static let contentController: String = "bridge"
}
