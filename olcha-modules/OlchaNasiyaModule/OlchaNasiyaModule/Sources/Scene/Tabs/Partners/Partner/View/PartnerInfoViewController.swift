//
//  PartnerInfoViewController.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 19/05/23.
//

import UIKit
import OlchaUI
public class PartnerInfoViewController: BaseViewController<BackNavigationBar> {

    public lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.settings.delegate = self
        return scrollView
    }()
    
    public let sections: [Section] = [
        .header,
        .location,
        .description,
        .category
    ]
    
    public var sectionViews: [Section: UIView] = [:]
    
    let viewModel: PartnerViewModel
    var input: Input
    var output: Output
    
    weak var coordinator: PartnerCoordinatorProtocol?
    
    public init(viewModel: PartnerViewModel,
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
    
    public override func setupViews() {
        container.addSubview(scrollView)
    }
    
    public override func autolayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        withNavigationSeparator = true
        createRooms()
    }

    public override func initialRequest() {
        viewModel.loadPartner(slug: input.partnerModel?.slug)
    }
    
    public override func setupObservers() {
        handle(viewModel.$partner) { [weak self] data in
            guard let self = self else { return }
            input.partnerModel = data?.store
            createRooms()
        } failure: { [weak self] error in
            guard let self = self else { return }
        } loading: { [weak self] isLoading in
            guard let self = self else { return }
        }
    }
}
