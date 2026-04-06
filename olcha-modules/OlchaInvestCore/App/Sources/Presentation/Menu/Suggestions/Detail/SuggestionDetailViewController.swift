//
//  SuggestionDetailViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 27/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class SuggestionDetailViewController: BaseViewController<BackNavigationBar> {
    
    private lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.horizontalEdge()
        scrollView.container.spacing = 14
        scrollView.settings.contentInset.top = 20
        return scrollView
    }()
    
    private let suggestionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 12)
        label.textColor = .olchaLightTextColornnnnnn
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let headingLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    public var postId: Int?
    public let viewModel: SuggestionViewModel
    
    public init(viewModel: SuggestionViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(suggestionImageView)
        container.addSubview(scrollView)
        scrollView.addArrangedSubview(categoryLabel)
        scrollView.addArrangedSubview(headingLabel)
        scrollView.addArrangedSubview(descriptionLabel)
    }
    
    public override func autolayout() {
        scrollView.container.setCustomSpacing(8, after: categoryLabel)
        suggestionImageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(200)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(suggestionImageView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    public override func configureViews() {
        navigationBar.clearNavigationBackground()
    }
    
    public override func initialRequest() {
        guard let postId = postId else { return }
        viewModel.loadSuggestion(id: postId)
    }
    
    public override func setupObservers() {
        handle(viewModel.$suggestion, showLoader: true, success: { [weak self] data in
            guard let self = self, let data = data else { return }
            setup(with: data)
        })
    }
    
    private func setup(with data: SuggestionItemModel) {
        headingLabel.text = data.title
        categoryLabel.text = data.section_name
        descriptionLabel.text = data.descrption
        suggestionImageView.load(from: data.image.unwrap, withIndicator: false)
    }

}
