//
//  FaqViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 30/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import OlchaCommon

public class FaqViewController: BaseViewController<TitleNavigationBar> {
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: FaqTableCell.self)
        table.configure()
        table.contentInset = .init(top: 0, left: 0, bottom: 300, right: 0)
        return table
    }()
    
    private let bottomContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .olchaWhite
        return view
    }()
    
    private let bottomTitleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 22)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let bottomSubtitleLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaTextBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let askFAQButton: InvestOlchaButton = {
        let button = InvestOlchaButton()
        return button
    }()
    
    public var input: Input
    public var output: Output
    public let viewModel: CommonViewModel
    public weak var coordinator: HelpCoordinatorProtocol?
    
    public init(
        input: Input = .init(),
        output: Output = .init(),
        viewModel: CommonViewModel
    ) {
        self.input = input
        self.output = output
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(table)
        container.addSubview(bottomContainer)
        table.addSubview(refreshControl)
        bottomContainer.addSubview(bottomTitleLabel)
        bottomContainer.addSubview(bottomSubtitleLabel)
        bottomContainer.addSubview(askFAQButton)
    }
    
    public override func autolayout() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomContainer.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        
        bottomTitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(26)
            make.top.equalToSuperview().inset(16)
        }
     
        bottomSubtitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(36)
            make.top.equalTo(bottomTitleLabel.snp.bottom).inset(-8)
        }
        
        askFAQButton.snp.makeConstraints { make in
            make.top.equalTo(bottomSubtitleLabel.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        languageUpdated()
        bottomContainer.layoutIfNeeded()
        table.contentInset = .init(top: 0, left: 0, bottom: bottomContainer.frame.height + 32, right: 0)
     }
    
    public override func languageUpdated() {
        navigationBar.setTitle("faq".localized(.olchaInvestCore))
        askFAQButton.setTitle("faq_ask_question".localized(.olchaInvestCore))
        bottomTitleLabel.text = "faq_title".localized(.olchaInvestCore)
        bottomSubtitleLabel.text = "faq_detail".localized(.olchaInvestCore)
        table.reloadData()
    }
 
    public override func setupObservers() {
        handle(viewModel.$faqs, success: { [weak self] data in
            guard let self = self, let faqs = data?.faqs else { return }
            input.faqs = faqs
            table.reloadData()
        }, loading: { [weak self] isLoading in
            guard let self else { return }
            input.faqsSkeleton.isAnimating = isLoading
            table.reloadData()
        })

        askFAQButton.clicked { [weak self] in
            guard let self else { return }
            coordinator?.pushWriteUsViewController()
        }
    }
    
    public override func initialRequest() {
        viewModel.loadFAQs(page: 1)
    }
    
    public override func refreshList(_ sender: AnyObject) {
        input.reset()
        table.reloadData()
        initialRequest()
        refreshControl.endRefreshing()
    }
}
