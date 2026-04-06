//
//  AddCardFinishViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 21/02/23.
//

import UIKit
import OlchaUI
public class AddCardFinishViewController: BaseViewController<BackNavigationBar> {
    
    private lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.container.spacing = 24
        scrollView.container.alignment = .leading
        return scrollView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "check_card_data_subtitle".localized()
        label.numberOfLines = 0
        label.style(.regular, 14)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private lazy var cardContainer: UIView = {
        let view = UIView()
        view.round()
        view.darkBorder()
        return view
    }()
    
    private lazy var cardContainerStack: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var nextButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("close".localized())
        button.configure(type: .pay)
        return button
    }()
    
    weak var coordinator: AddCardCoordinatorProtocol?
    
    public override func setupViews() {
        container.addSubview(scrollView)
        scrollView.addArrangedSubview(titleLabel)
        scrollView.addArrangedSubview(cardContainer)
        cardContainer.addSubview(cardContainerStack)
        scrollView.addArrangedSubview(nextButton)
    }
    
    public override func autolayout() {
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        cardContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        cardContainerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        navigationBar.setTitle("adding_card".localized())
        fillCardDatas()
    }

    private func fillCardDatas() {
        cardContainerStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        cardContainerStack.addArrangedSubview(createStackItem("card_number".localized(), "8600 0044 5548 4488"))
        
        cardContainerStack.addArrangedSubview(createStackItem("name".localized(), "Khodjaev Abdulla"))
        
        cardContainerStack.addArrangedSubview(createStackItem("due_to".localized(), "12/24"))
    }
    
    private func createStackItem(_ title: String,_ value: String) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .lastBaseline
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.style(.medium, 14)
        titleLabel.textColor = .olchaLightTextColornnnnnn
        titleLabel.numberOfLines = 0
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.style(.semibold, 14)
        valueLabel.textColor = .olchaTextBlack
        valueLabel.numberOfLines = 0
        valueLabel.textAlignment = .right
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueLabel)
        
        return stackView
    }
    
    public override func setupObservers() {
        nextButton.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.completed?()
        }
    }
}
