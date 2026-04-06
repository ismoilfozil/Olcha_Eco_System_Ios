//
//  AskQuestionPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 02/08/22.
//

import UIKit
import Combine
import OlchaUI
class AskQuestionPage: BaseViewController {
    
    private let viewModel = ReviewsPageViewModel()
    private let faqField = TMultiField()
    private let sendButton = OlchaButton()
    
    
    private var bag = Set<AnyCancellable>()
    var product: ProductModel?
    
    weak var coordinator: ReviewCoordinatorProtocol?
    
    override func setupViews() {
        super.setupViews()
        container.addSubview(faqField)
        container.addSubview(sendButton)
    }
    
    override func autolayout() {
        super.autolayout()
        faqField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        sendButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    override func configureViews() {
        super.configureViews()
        navigation.configure(style: .back)
        navigation.setTitle("ask_question".localized())
        
        faqField.title = "question".localized()
        faqField.placeholder = "faq_placeholder".localized()
        sendButton.setTitle("send_question".localized())
    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        
        sendButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            
            let question = self.faqField.settings.currentText
            
            guard let id = self.product?.id, question != "" else { return }
            self.sendButton.settings.requesting = true
            self.viewModel.send(question: question, productID: id)
        }
        
        viewModel.$questionSuccess.sink { [weak self] isSuccess in
            guard let self = self else { return }
            if isSuccess {
                self.coordinator?.pushReviewFinish(type: .question,
                                                   lastPage: Self.self)
            }
            self.sendButton.settings.requesting = false
        }.store(in: &bag)
    }
}
