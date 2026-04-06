import UIKit
import OlchaUI
import OlchaPayModule

public class EcoHomeBalanceTableCell: BaseTableCell {
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 16
        stack.axis = .vertical
        return stack
    }()

    private let topStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let totalBalance = HomeBalanceItemView()
    private let olchaPayBalance = HomeBalanceItemView()
    private let bonusBalance = HomeBalanceItemView()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        skeletonViews.forEach({ $0.layoutSkeletonIfNeeded() })
    }
    
    public override func setupViews() {
        container.addSubview(contentStack)
        contentStack.addArrangedSubview(topStack)
        contentStack.addArrangedSubview(bonusBalance)
        topStack.addArrangedSubview(olchaPayBalance)
        topStack.addArrangedSubview(totalBalance)
    }
    
    public override func autolayout() {
        contentStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(20)
        }
    }
    
    public override func configureViews() {
        container.round(24)
        layer.zPosition = 1
        configureSkeleton()
    }
    
    public func setup(balance: BalanceData?) {
        totalBalance.setupBalance(
            title: "home_balance_total".localized(.olchaEcoSystemCore),
            balance: balance?.balance?.string
        )
    }
    
    public func setup(payBalance: BalancesData?) {
        olchaPayBalance.setupBalance(
            title: "home_balance_pay".localized(.olchaEcoSystemCore),
            balance: payBalance?.total_sum?.string
        )
    }
    
    public func setup(bonus: BonusData?) {
        var progress: CGFloat?
        if let percent = bonus?.percent {
            progress = CGFloat(percent)
        }
        bonusBalance.setupBalance(
            title: "home_balance_bonus".localized(.olchaEcoSystemCore),
            balance: bonus?.bonus,
            progress: progress,
            hideProgress: false,
            alignment: .center
        )
    }
    
    public func olchaPayItemClicked(clicked: (() -> Void)?) {
        olchaPayBalance.viewClicked = clicked
    }
    
    public func olchaTotalBalance(clicked: (() -> Void)?) {
        totalBalance.viewClicked = clicked
    }

    public func olchaBonusBalance(clicked: (() -> Void)?) {
        bonusBalance.viewClicked = clicked
    }

}

private extension EcoHomeBalanceTableCell {
    func configureSkeleton() {
        makeSkeleton(views: [
            bonusBalance,
            olchaPayBalance,
            totalBalance
        ])
    }
}
