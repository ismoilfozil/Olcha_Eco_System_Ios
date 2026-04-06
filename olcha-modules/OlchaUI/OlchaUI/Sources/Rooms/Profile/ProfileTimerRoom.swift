import UIKit
import SnapKit

public class ProfileTimerRoom: BaseTableCell {

    private var timer: Timer?
    private var elapsedTime: Int = 0
    public var timerInterval: Int = 0 {
        didSet { elapsedTime = timerInterval }
    }
    public var stopObserver: (() -> Void)?
    public var refreshObserver: (() -> Void)?
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    private let progressView: TimerProgressView = {
        let view = TimerProgressView()
        view.progress = 0.0
        view.lineWidth = 15
        view.fontSize = 36
        view.alpha = 0
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
    
    private let refreshButton: IButton = {
        let button = IButton()
        button.backgroundColor = .olchaAccentColor
        button.titleLabel?.style(.semibold, 14)
        button.round(8)
        return button
    }()
    
    deinit {
        stopTimer()
    }

    public override func setupViews() {
        container.addSubview(contentStack)
        contentStack.addArrangedSubview(progressView)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(supportView)
        contentStack.addArrangedSubview(refreshButton)
    }
    
    public override func autolayout() {
        contentStack.setCustomSpacing(60, after: titleLabel)
        contentStack.setCustomSpacing(24, after: supportView)
        contentStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        progressView.snp.makeConstraints { make in
            make.height.equalTo(180)
        }
        refreshButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    
    public override func configureViews() {
        setupTimer()
        refreshButton.clicked { [weak self] in
            self?.refreshObserver?()
        }
    }
    
    public func setup() {
        titleLabel.text = "timer_title".localized(.verification)
        refreshButton.setTitle("refresh".localized(), for: .normal)
        supportView.languageUpdated()
    }
    
    public func setElapsedTime(_ time: Int) {
        elapsedTime = time
    }
    
}

private extension ProfileTimerRoom {
    func setupTimer() {
        timer = Timer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        guard let timer else { return }
        RunLoop.main.add(timer, forMode: .common)
    }
    
    @objc func updateTime() {
        elapsedTime -= 1
        if elapsedTime >= 0 {
            progressView.alpha = 1
            updateProgress()
        } else {
            progressView.alpha = 0
        }
    }
    
    @objc func stopTimer() {
        progressView.alpha = 0
        timerInterval = 0
        timer?.invalidate()
        timer = nil
        stopObserver?()
    }
    
    func updateProgress() {
        let minutes = elapsedTime / 60
        let seconds = elapsedTime % 60
        progressView.progress = CGFloat(elapsedTime) / CGFloat(timerInterval)
        progressView.text = String(format: "%02d:%02d", minutes, seconds)
        progressView.alpha = elapsedTime > 0 ? 1 : 0
        
        if elapsedTime == 0 {
            stopTimer()
        }
    }
}
