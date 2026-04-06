import UIKit
import OlchaUI

public class VerificationStatusView: BaseView {
    
    public let container = UIView()
    
    private let expandeContainer = UIView()
    private let separator = Divide()
    private let titlesStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    public var steps: [VerificationStatusStep] = [
        .identification,
        .phones,
        .bankCard
    ]
    
    public var step = 0 {
        didSet {
//            changeStep()
        }
    }
    
    public var verifiedSteps: [VerificationStatusStep] = [] {
        didSet {
            setupTitles()
        }
    }
    
//    public var stepObserver: ((VerificationStatusStep) -> Void)?
    
    public override func setupViews() {
        addSubview(container)
        container.addSubview(titlesStack)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titlesStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        container.round()
        
        setupTitles()
    }
    
    private func setupTitles() {
        titlesStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for step in steps {
            let row = VerificationStatusTextRow()
            row.setup(
                with: step,
                isVerified: verifiedSteps.contains(where: { $0 == step })
            )
            titlesStack.addArrangedSubview(row)
        }
    }
    
}

public final class VerificationStatusTextRow: UIStackView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaPrimaryColor
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.style(.medium, 14)
        label.textColor = .olchaLightTextColornnnnnn
        return label
    }()
    
    private let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .danger
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with step: VerificationStatusStep, isVerified: Bool) {
        titleLabel.textColor = isVerified ? .olchaGreen : .olchaPrimaryColor
        titleLabel.text = step.title
        valueLabel.textColor = isVerified ? .olchaGreen : .olchaLightTextColornnnnnn
        valueLabel.text = "\(step.percentage)%"
        statusImageView.image = isVerified ? .tickCircle : .danger
    }
    
}

private extension VerificationStatusTextRow {
    func setup() {
        setupViews()
        configureViews()
        autoLayout()
    }
    
    func setupViews() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(valueLabel)
        addArrangedSubview(statusImageView)
    }
    
    func configureViews() {
        alignment = .center
        spacing = 4
    }
    
    func autoLayout() {
        statusImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
        }
    }
}
