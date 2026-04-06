//
//  HtmlVC.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 29/08/22.
//

import UIKit
import Combine
import OlchaUI
import OlchaUtils
class HtmlPage: BaseViewController {
    private let scrollView = UIScrollView()
    private let scrollContainer = UIView()
    private let titlesContainer = UIStackView()
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    
    var url: String = ""

    private var bag = Set<AnyCancellable>()
    private let viewModel = HomePageViewModel()
    
    override func setupViews() {
        super.setupViews()
        container.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        scrollContainer.addSubview(titlesContainer)
        titlesContainer.addArrangedSubview(titleLabel)
        titlesContainer.addArrangedSubview(contentLabel)
    }
    
    override func autolayout() {
        super.autolayout()
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        titlesContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
    }
    
    override func configureViews() {
        super.configureViews()
        navigation.configure(style: .back)
        
        titlesContainer.axis = .vertical
        titlesContainer.alignment = .top
        titlesContainer.spacing = 16
        
        titleLabel.style(.bold, 25)
        titleLabel.textColor = .olchaTextBlack
        
        contentLabel.style(.medium, 17)
        contentLabel.textColor = .olchaTextBlack
        contentLabel.numberOfLines = 0
        
        
    }
    
    override func initialRequest() {
        super.initialRequest()
        viewModel.loadHtmlFile(url: url)
    }
    
    override func setupObservers() {
        super.setupObservers()
        viewModel
            .$htmlModel
            .dropFirst()
            .sink { [weak self] model in
                guard let self = self else { return }
                
                self.titleLabel.text = model?.page?.getTitle()
                
                
                self.navigation.setTitle(model?.page?.getTitle() ?? "")
                
                self.contentLabel.attributedText = (model?.page?.getContent() ?? "")
                    .htmlToAttributedString(textColor: .olchaTextBlack, font: .style(.regular, 16))
                    .attributedStringWithResizedImages(with: self.titlesContainer.frame.width)
                
                
            }.store(in: &bag)
    }

}
