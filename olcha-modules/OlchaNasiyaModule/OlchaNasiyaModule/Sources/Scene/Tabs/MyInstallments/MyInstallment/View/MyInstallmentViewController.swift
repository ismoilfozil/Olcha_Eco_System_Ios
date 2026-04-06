//
//  MyInstallmentViewController.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 16/05/23.
//

import UIKit
import OlchaUI
import BetterSegmentedControl
import OlchaUtils
import OlchaBilling
public class MyInstallmentViewController: BaseViewController<BackNavigationBar> {

    private let headerGraph: InstallmentGraphHeader = {
        let view = InstallmentGraphHeader()
        return view
    }()
    
    private lazy var segmentContainer: BetterSegmentedControl = {
        let view = BetterSegmentedControl()
        view.backgroundColor = .lightGrayBackground
        view.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        return view
    }()
    
    private let indicator: UIView = {
        let view = UIView()
        view.backgroundColor = .olchaPrimaryColor
        return view
    }()
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: InstallmentGraphRoom.self)
        table.registerClass(forCell: InstallmentDetailRoom.self)
        table.contentInset = .init(top: 0, left: 0, bottom: 60, right: 0)
        table.configure()
        return table
    }()
    
    private let payButton: NasiyaButton = {
        let button = NasiyaButton()
        button.isHidden = true
        return button
    }()
    
    private var tooltips: [MyInstallmentViewControllerTooltip] {
        let segments = segmentContainer.segments
        guard let graphicSegment = segments.first?.normalView else { return [] }
        guard let detailSegment = segments.last?.normalView else { return [] }
        
        return [
            .installmentNumber(in: headerGraph.titleLabel),
            .paidContent(in: headerGraph.paidContent),
            .needContent(in: headerGraph.needContent),
            .graphicSegment(in: graphicSegment),
            .detailSegment(in: detailSegment),
        ]
    }
    
    private let tooltipManager = TooltipManager()

    weak var coordinator: MyInstallmentsCoordinatorProtocol?

    var input = Input()
    var output = Output()
    
    public let viewModel: InstallmentViewModel
    
    public init(viewModel: InstallmentViewModel,
                input: Input = .init(),
                output: Output = .init()) {
        self.input = input
        self.output = output
        self.viewModel = viewModel
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tooltipManager.didViewAppear = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tooltipManager.destroy()
    }
    
    public override func setupViews() {
        container.addSubview(headerGraph)
        container.addSubview(segmentContainer)
        segmentContainer.addSubview(indicator)
        container.addSubview(table)
        container.addSubview(payButton)
        table.addSubview(refreshControl)
    }
    
    public override func autolayout() {
        headerGraph.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
        
        segmentContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headerGraph.snp.bottom).inset(-20)
            make.height.equalTo(36)
        }
        
        updateIndicator()
        
        table.snp.makeConstraints { make in
            make.top.equalTo(segmentContainer.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        payButton.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        headerGraph.setup(with: .init(id: 0,
                                      date: " - ",
                                      paid: 0,
                                      need_pay: 0,
                                      total_pay: 0
                                     )
        )
        languageUpdated()
    }
    
    public override func setupObservers() {
        payButton.clicked { [weak self] in
            guard let self = self else { return }
            coordinator?.pushBillingPayment(
                filter: .init(
                    order: .init(id: input.installment?.id,
                                 max_value: input.installment?.getRemainder(),
                                 currency: input.installment?.currency,
                                 current_value: input.installment?.getCurrentPayment()
                                ),
                    settings: .init(reflection: input.installment?.getReflection())
                )
            )
        }
        
        handle(viewModel.$installment,
               success: { [weak self] data in
            guard let self = self,
                  let data = data else { return }
            
            input.installment = data
            setupData()
            checkPayAction()
            if let topView {
                tooltipManager.setup(tooltips: tooltips, darkView: topView)
            }
        }, loading: { [weak self] loading in
            guard let self else { return }
            input.skeleton.isAnimating = loading
            table.reloadData()
        })
    }
    
    private func checkPayAction() {
        guard output.shouldPay else { return }
        output.shouldPay = false
        coordinator?.pushBillingPayment(
            filter: .init(
                order: .init(id: input.installment?.id,
                             max_value: input.installment?.getRemainder(),
                             currency: Texts.currency_alias,
                             current_value: input.installment?.getCurrentPayment()
                            ),
                settings: .init(reflection: input.installment?.getReflection())
            )
        )
    }
    
    public override func languageUpdated() {
        setupSegmentTitles()
        payButton.setTitle("pay".localized())
    }

    public override func initialRequest() {
        loadInstallment(id: input.installment?.id)
    }
    
    public func loadInstallment(id: Int?) {
        viewModel.loadInstallment(id: id)
    }
    
    private func setupSegmentTitles() {
        segmentContainer.segments = LabelSegment.segments(
            withTitles: ["graph".localized(.olchaNasiyaModule),
                         "detailed".localized(.olchaNasiyaModule)],
            normalBackgroundColor: .lightGrayBackground,
            normalFont: .style(.medium, 14),
            normalTextColor: .olchaDarkNeutralGray,
            selectedBackgroundColor: .lightGrayBackground,
            selectedFont: .style(.medium, 14),
            selectedTextColor: .olchaTextBlack
        )
    }
    
    @objc func segmentChanged(_ sender: BetterSegmentedControl) {
        table.setContentOffset(.zero, animated: true)
        switch sender.index  {
        case 0:
            output.currentState = .graph
        default:
            output.currentState = .detailed
        }
        table.reloadData()
        updateIndicator()
    }
    
    private func updateIndicator() {
        indicator.snp.remakeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            if output.currentState == .graph {
                make.left.equalToSuperview()
            } else {
                make.right.equalToSuperview()
            }
        }
    }
    
    private func setupData() {
        table.reloadData()
        headerGraph.setup(with: input.graphHeader)
        checkButtonState()
    }
    
    private func checkButtonState() {
        let isNotActive = (input.installment?.getStatus() != .active)
//        let isHidden = !((input.installment?.getRemainder() ?? 0) > 0)
        payButton.isHidden = isNotActive
    }
    
    public override func refreshList(_ sender: AnyObject) {
        refreshControl.endRefreshing()
        input.resetDatas()
        initialRequest()
    }
}
