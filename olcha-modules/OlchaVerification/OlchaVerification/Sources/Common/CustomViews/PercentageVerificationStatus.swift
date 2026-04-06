import UIKit
import OlchaUI
import SnapKit

public class PercentageVerificationStatus: BaseView {
    
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 4
        return stack
    }()
    
    private let labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.style(.semibold, 18)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let stepLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let progressView: CircularProgressView = {
        let view = CircularProgressView()
        return view
    }()
    
    public override func setupViews() {
        addSubview(containerStack)
        containerStack.addArrangedSubview(labelStack)
        labelStack.addArrangedSubview(titleLabel)
        labelStack.addArrangedSubview(stepLabel)
        containerStack.addArrangedSubview(progressView)
    }
    
    public override func autolayout() {
        containerStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        progressView.snp.makeConstraints { make in
            make.size.equalTo(56)
        }
    }
    
    public override func configureViews() {
        round()
        backgroundColor = .hex("#F3F3F6").withAlphaComponent(0.6)
    }
    
    public func setup(statusStep: VerificationStatusStep) {
        titleLabel.text = statusStep.title
        stepLabel.text = "\(statusStep.step)/\(VerificationStatusStep.allCases.count)"
    }
    
    public func setProgress(_ progress: CGFloat) {
        progressView.progress = progress
    }
}
