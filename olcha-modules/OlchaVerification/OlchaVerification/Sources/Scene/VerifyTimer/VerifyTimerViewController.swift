import UIKit
import OlchaUI
import OlchaAuth

public class VerifyTimerViewController: BaseViewController<EmptyNavigationBar> {
 
    private lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.horizontalEdge()
        scrollView.container.spacing = 16
        scrollView.settings.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 32, right: 0)
        scrollView.settings.alwaysBounceVertical = true
        return scrollView
    }()
    
    private let progressView: TimerProgressView = {
        let view = TimerProgressView()
        view.progress = 0.0
        view.lineWidth = 15
        view.fontSize = 36
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 18)
        label.textColor = .olchaTextBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let supportView: SupportView = {
        let view = SupportView()
        return view
    }()
    
    private let closeButton: IButton = {
        let button = IButton()
        button.backgroundColor = .olchaAccentColor
        button.titleLabel?.style(.semibold, 14)
        button.round(8)
        return button
    }()
    
    private var isVerified: Bool {
        AuthGlobalDefaults.user.isVerified ?? false
    }
    private var timer: Timer?
    private var elapsedTime: Int = 0
    public var timerInterval: Int = 0 {
        didSet { elapsedTime = timerInterval }
    }
    public weak var coordinator: VerificationCoordinatorProtocol?
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTimer()
    }
    
    public override func setupViews() {
        container.addSubview(scrollView)
        container.addSubview(supportView)
        container.addSubview(closeButton)
        scrollView.addArrangedSubview(progressView)
        scrollView.addArrangedSubview(titleLabel)
    }
    
    public override func autolayout() {
        scrollView.container.setCustomSpacing(32, after: progressView)
        scrollView.container.setCustomSpacing(100, after: titleLabel)
        scrollView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.bottom.equalTo(supportView.snp.top)
        }
        progressView.snp.makeConstraints { make in
            make.size.equalTo(180)
        }
        supportView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(72)
        }
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(supportView.snp.bottom).offset(24)
            make.horizontalEdges.bottom.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
    }
    
    public override func configureViews() {
        ignoreNavigationBar = true
        languageUpdated()
    }
    
    public override func setupObservers() {
        handle(
            OlchaVerificationDIContainer.shared.authCreditViewModel().$isVerified,
            showLoader: false,
            withError: false,
            success: { [weak self] _ in
                guard let self = self else { return }
                dismiss(animated: true) { [weak self] in
                    guard let self else { return }
                    stopTimer()
                    isVerified ? coordinator?.presentSuccess() : coordinator?.presentDeny()
                }
            }
        )
        
        closeButton.clicked { [weak self] in
            self?.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    public override func languageUpdated() {
        titleLabel.text = "timer_title".localized(.verification)
        closeButton.setTitle("close".localized(), for: .normal)
    }
    
}

private extension VerifyTimerViewController {
    @objc func updateTime() {
        elapsedTime -= 1
        updateProgress()
    }
    
    @objc func stopTimer() {
        timer?.invalidate()
        timer = nil
        updateProgress()
        OlchaVerificationDIContainer.shared.authCreditViewModel().verifyCredit()
    }
    
    func updateProgress() {
        let minutes = elapsedTime / 60
        let seconds = elapsedTime % 60
        progressView.progress = CGFloat(elapsedTime) / CGFloat(timerInterval)
        progressView.text = "\(minutes):\(seconds)"
        
        if elapsedTime == 0 {
            stopTimer()
        }
    }
    
    func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
}
