//
//  SegmentView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/03/23.
//

import UIKit

class SegmentItem {
    var id: Int
    var title: String
    var isChosen: Bool
    
    init(id: Int, title: String, isChosen: Bool) {
        self.id = id
        self.title = title
        self.isChosen = isChosen
    }
}
class SegmentView: UIView {
    private let backgroundContainer = UIView()
    private let buttonsContainer = UIStackView()
    
    var segmentItems: [SegmentItem] = [] {
        didSet {
            drawButtons()
        }
    }
    
    var segmentButtons: [Button] = []
    
    private var segmentClickedObserver: ((SegmentItem) -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        autolayout()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(backgroundContainer)
        backgroundContainer.addSubview(buttonsContainer)
    }
    
    func autolayout() {
        backgroundContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        buttonsContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(2)
            make.top.bottom.equalToSuperview().inset(2)
        }
        
    }
    
    func configureViews() {
        
        backgroundContainer.round(8)
        backgroundContainer.backgroundColor = .lightGrayBackground
        buttonsContainer.axis = .horizontal
        buttonsContainer.distribution = .fillEqually
        
    }
    
    private func unselectedButtonDesign(_ button: UIButton) {
        button.backgroundColor = .clear
        button.round(6)
        button.titleLabel?.style(.medium, 16)
        button.setTitleColor(.olchaTextBlack, for: .normal)
    }
    
    private func selectedButtonDesign(_ button: UIButton) {
        button.backgroundColor = .olchaAccentColor
        button.round(6)
        button.titleLabel?.style(.semibold, 16)
        button.setTitleColor(.olchaWhite, for: .normal)
    }
 
    private func drawButtons() {
        buttonsContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for item in segmentItems {
            let button = Button()
            button.tag = item.id
            button.clicked { [weak self] in
                guard let self = self else { return }
                self.segmentItems.forEach { $0.isChosen = false }
                item.isChosen = true
                self.segmentSelected()
            }
            button.setTitle(item.title, for: .normal)
            buttonsContainer.addArrangedSubview(button)
            segmentButtons.append(button)
        }
        
        updateButtonStates()
    }
    
    func segmentClicked(completion:  @escaping ((SegmentItem) -> Void)) {
        self.segmentClickedObserver = completion
    }
    
    private func segmentSelected() {
        
        guard let selectedItem = segmentItems.first(where: { $0.isChosen == true }) else { return }
        segmentClickedObserver?(selectedItem)
                updateButtonStates()
    }
    
    private func updateButtonStates() {
        for i in 0..<segmentButtons.count {
            let item = segmentItems[i]
            let button = segmentButtons[i]
            item.isChosen ? selectedButtonDesign(button) : unselectedButtonDesign(button)
        }
    }
}
