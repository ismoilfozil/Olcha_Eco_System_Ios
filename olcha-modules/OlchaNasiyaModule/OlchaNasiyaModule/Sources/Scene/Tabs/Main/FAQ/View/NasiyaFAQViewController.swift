//
//  NasiyaFAQViewController.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 14/05/23.
//

import UIKit
import OlchaUI
import OlchaCommon
public class NasiyaFAQViewController: BaseViewController<TitleNavigationBar> {
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: NasiyaFAQRoom.self)
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
    
    private let askFAQButton: NasiyaButton = {
        let button = NasiyaButton()
        return button
    }()
    
    weak var coordinator: NasiyaHomeCoordinatorProtocol?
    
    let viewModel: CommonViewModel
    
    var input: Input
    var output: Output
    
    public init(viewModel: CommonViewModel,
                input: Input = .init(),
                output: Output = .init()
    ) {
        self.viewModel = viewModel
        self.input = input
        self.output = output
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(table)
        container.addSubview(bottomContainer)
        
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
        navigationBar.setTitle("most_faqs".localized(.olchaNasiyaModule))
        languageUpdated()
     }
    
    public override func languageUpdated() {
        askFAQButton.setTitle("ask_question".localized())
        bottomTitleLabel.text = "not_found_faq".localized(.olchaNasiyaModule)
        bottomSubtitleLabel.text = "not_found_faq_subtitle".localized(.olchaNasiyaModule)
        
        bottomContainer.layoutIfNeeded()
        table.contentInset = .init(top: 0, left: 0, bottom: bottomContainer.frame.height + 32, right: 0)
    }
 
    public override func setupObservers() {
        askFAQButton.clicked { [weak self] in
            guard let self = self else { return }
            openTelegram()
        }
        
        handle(viewModel.$faqs, showLoader: true) { [weak self] data in
            guard let self = self else { return }
            input.faqs.append(data?.faqs)
            input.faqs.paging.finished(paginator: data?.paginator)
            tableReloader()
        } failure: { [weak self] error in
            guard let self = self else { return }
            input.faqs.paging.errorFinished()
            tableReloader()
        } loading: { [weak self] isLoading in
            guard let self = self else { return }
            input.faqs.paging.isLoading = isLoading
            input.faqs.paging.isInitialLoad() ? showLoader() : hideLoader()
        }

    }
    
    public override func initialRequest() {
        viewModel.loadFAQs(page: 1)
    }
    
    public func loadMore(index: Int) {
        guard canLoad(index: index,
                      paging: input.faqs.paging,
                      list: input.faqs.models) else {
            return
        }
        
        viewModel.loadFAQs(page: input.faqs.paging.current)
    }
    
    func tableReloader() {
        table.reloadData()
    }
}
