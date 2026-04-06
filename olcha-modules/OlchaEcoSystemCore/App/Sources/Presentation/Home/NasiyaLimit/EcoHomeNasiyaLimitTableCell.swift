import UIKit
import OlchaUI
import OlchaNasiyaModule

public class EcoHomeNasiyaLimitTableCell: BaseTableCell {
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        return stack
    }()
    
    private let limitIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .nasiyaLimitIcon
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let detailStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillProportionally
        stack.spacing = 6
        stack.axis = .vertical
        return stack
    }()
    
    private let limitTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .olchaBlackNeutral
        label.style(.semibold, 14)
        return label
    }()
    
    private let limitLabel: UILabel = {
        let label = UILabel()
        label.textColor = .olchaLightTextColornnnnnn
        label.style(.medium, 12)
        return label
    }()
    
    private let progressBar: PlainHorizontalProgressBar = {
        let bar = PlainHorizontalProgressBar()
        bar.color = .olchaPrimaryColor
        bar.maskColor = .olchaLightNeutralGray
        bar.isHidden = true
        return bar
    }()
    
    private let arrowIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .altArrowRight
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        skeletonViews.forEach({ $0.layoutSkeletonIfNeeded() })
    }
    
    public override func setupViews() {
        container.addSubview(contentStack)
        contentStack.addArrangedSubview(limitIcon)
        contentStack.addArrangedSubview(detailStack)
        contentStack.addArrangedSubview(arrowIcon)
        detailStack.addArrangedSubview(limitTitleLabel)
        detailStack.addArrangedSubview(progressBar)
        detailStack.addArrangedSubview(limitLabel)
    }
    
    public override func autolayout() {
        container.snp.updateConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(24)
        }
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
            make.height.equalTo(72)
        }
        limitIcon.snp.makeConstraints { make in
            make.height.width.equalTo(56)
        }
        arrowIcon.snp.makeConstraints { make in
            make.width.equalTo(20)
        }
        progressBar.snp.makeConstraints { make in
            make.height.equalTo(8)
        }
    }
    
    public override func configureViews() {
        container.round(16)
        limitTitleLabel.text = "home_nasiya_limit_title".localized(.olchaEcoSystemCore)
        limitLabel.text = "home_nasiya_limit_request".localized(.olchaEcoSystemCore)
        configureSkeleton()
    }
    
    public func setup(with model: InstallmentLimitBalanceData?) {
        guard let model else { return }
        if let amount = model.installment_limit_balance?.amount.orZero.string.originalPrice {
            let limitString = "home_nasiya_limit_value".localized(.olchaEcoSystemCore)
            limitLabel.text = String(format: limitString, amount)
        }
        if model.request_status?.getStatus() == .approved {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.progressBar.isHidden = false
                self.progressBar.progress = CGFloat(model.remaining_percent.orZero)
            }
        }
    }
    
    public func setup() {
        limitTitleLabel.text = "home_nasiya_limit_title".localized(.olchaEcoSystemCore)
        limitLabel.text = "home_nasiya_limit_request".localized(.olchaEcoSystemCore)
    }
    
}

private extension EcoHomeNasiyaLimitTableCell {
    func configureSkeleton() {
        makeSkeleton(views: [
            limitTitleLabel,
            limitLabel
        ])
        
        limitTitleLabel.skeletonConfiguration(
            lines: .custom(1),
            lastLinePercentage: 50,
            height: .relativeToConstraints
        )
        limitLabel.skeletonConfiguration(
            lines: .custom(1),
            lastLinePercentage: 50,
            height: .relativeToConstraints
        )
    }
}
