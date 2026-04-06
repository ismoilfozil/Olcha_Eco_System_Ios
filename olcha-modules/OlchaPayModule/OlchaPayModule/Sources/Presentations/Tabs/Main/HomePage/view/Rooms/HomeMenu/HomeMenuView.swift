//
//  HomeMenuRoom.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 02/02/23.
//

import UIKit
import OlchaUI
public class HomeMenuView: BaseView {
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.registerClass(forCell: HomeMenuItem.self)
        collection.registerClass(forCell: HomeDotsItem.self)
        
        collection.backgroundColor = .clear
        collection.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        collection.showsHorizontalScrollIndicator = false
        
        return collection
    }()
    
    var buttonClickObserver: ( (Section) -> Void)?
    
    
    let sections: [Section] = [
        .my_cards,
        .qr,
//        .dots
    ]


    public override func setupViews() {
        addSubview(collection)
    }
    
    public override func autolayout() {
        collection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(36)
        }
    }
 
    public override func languageUpdated() {
        collection.reloadData()
    }
    
    func clickedObserver(_ observer: ((Section) -> Void)?) {
        self.buttonClickObserver = observer
    }
}
