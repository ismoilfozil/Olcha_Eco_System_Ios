//
//  CardColorViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 05/02/23.
//

import UIKit
import OlchaUI
public class CardColorModalViewController: BaseModalViewController {
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collection.registerClass(forCell: CircleColorItem.self)
        collection.delegate = self
        collection.showsHorizontalScrollIndicator = false
        collection.dataSource = self
        
        return collection
    }()
    
    public lazy var saveButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("save".localized())
        return button
    }()
    
    public let colors: [String] = [
        "#EB1537",
        
        "#1abc9c",
        
        "#f39c12",
        
        "#2ecc71",
        
        "#2980b9",
        
        "#34495e",
        
        "#2c3e50"
    ]
    
    
    
    var chosenIndex: Int = 0 {
        didSet {
            collection.reloadData()
        }
    }
    
    public weak var observers: CardSettingsObserver?
    
    public weak var card: UserBankCardModel?
    
    public override func setupViews() {
        container.addSubview(collection)
        container.addSubview(saveButton)
    }
    
    public override func autolayout() {
        
        collection.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(CircleColorItem.circleSize)
            
        }
        
        saveButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(collection.snp.bottom).inset(-66)
            make.bottom.equalToSuperview().inset(16)
        }
        
    }
    
    public func setCurrent(color: String?) {
        if let color = color, let index = colors.firstIndex(where: { $0 == color }) {
            self.chosenIndex = index
        }
    }

    
    public override func configureViews() {
        setHeader(title: "select_color".localized())
        dismissConfiguration()
    }

    public override func initialRequest() {
        setCurrent(color: card?.color)
    }
    
    public override func setupObservers() {
        saveButton.clicked { [weak self] in
            guard let self = self else { return }
            self.card?.color = self.colors[self.chosenIndex]
            self.observers?.cardUpdated.send(self.card)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}
