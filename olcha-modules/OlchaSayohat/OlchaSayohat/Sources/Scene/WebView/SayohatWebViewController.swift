import UIKit
import Combine
import CoreLocation
import OlchaUI
import OlchaAuth
import OlchaUtils
import WebKit
import SnapKit

public class SayohatWebViewController: UIViewController {
    
    public var brightness: CGFloat = 0
    public var isFirstLoading: Bool = true
    private let locationManager: LocationManager = .default
    private var bag = Set<AnyCancellable>()
    
    public lazy var userContentController: WKUserContentController = {
        let contentController = WKUserContentController()
        contentController.add(self, name: SayohatWebViewController.contentController)
        return contentController
    }()
    
    public lazy var webView: WKWebView = {
        let preferences = WKPreferences()
        preferences.setValue("@YES", forKey: "allowFileAccessFromFileURLs")
        preferences.javaScriptEnabled = true
        let config = WKWebViewConfiguration()
        config.preferences = preferences
        config.userContentController = userContentController
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        return webView
    }()
    
    public lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshWebView), for: .valueChanged)
        return refreshControl
    }()
    
    public let splashContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let splashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .sayohatLogo
        imageView.contentMode = .scaleAspectFit
        return imageView
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

extension SayohatWebViewController: WebView {
    public func loadWebView() {
        let url = URL(string: Texts.sayohatUrl.base)
        guard let url else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    public func setupViews() {
        view.addSubview(webView)
        view.addSubview(splashContainer)
        splashContainer.addSubview(splashImageView)
        webView.scrollView.addSubview(refreshControl)
    }
    
    public func configureViews() {
        view.backgroundColor = .white
    }
    
    public func autoLayout() {
        webView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        splashContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        splashImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(110)
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
        NetworkMonitor.default.statusSubject
            .sink(receiveValue: { [weak self] isReachable in
                guard let self, isFirstLoading else { return }
                if isReachable {
                    loadWebView()
                    dismiss(animated: true)
                } else {
                    showNetworkStatusAlertView {
                        self.dismiss(animated: true, completion: self.setViewClosed)
                    }
                }
            })
            .store(in: &bag)
    }
}

public extension SayohatWebViewController {
    @objc func refreshWebView() {
        webView.reload()
        refreshControl.endRefreshing()
    }
}

public extension SayohatWebViewController {
    func makeTokenSetterJS() -> String {
        """
        window.web_postMessage.token({
            access_token: "\(AuthGlobalDefaults.access_token ?? "")",
            refresh_token: "\(AuthGlobalDefaults.refresh_token ?? "")"
        })
        """
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
    
    func makeShowItemsSetterJS() -> String {
        "window.web_postMessage.showItems({footer: false, backButton: true})"
    }
}

public extension SayohatWebViewController {
    enum MessageMethod: String {
        case qr
        case token
        case language
        case close_webview
        case onLoad = "on:load"
        case onLogout = "on:logout"
        case onLogin = "on:login"
        case onRegister = "on:register"
        case onShare = "on:share"
    }
    
    static let contentController: String = "bridge"
}
