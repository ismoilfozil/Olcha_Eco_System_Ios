import UIKit
import OlchaUI
import SnapKit
import Combine

public class EcoHomeAppTableCell: BaseTableCell {
    
    public lazy var collection: DynamicCollection = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = Constants.lineSpacing
        let collection = DynamicCollection(frame: .zero, collectionViewLayout: layout)
        collection.registerClass(forCell: EcoHomeAppCollectionCell.self)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return collection
    }()
    
    weak var appServiceSubject: PassthroughSubject<EcoHomeViewController.EcoAppService, Never>?
    
    public override func setupViews() {
        container.addSubview(collection)
    }
    
    public override func autolayout() {
        collection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(170)
            
            /*
             make.centerX.equalToSuperview()
             make.height.equalTo(170)
             make.width.equalTo(collectionWidth)
             */
        }
    }
    
    public override func configureViews() {
        verticalEdge = 10
        container.backgroundColor = .clear
    }
    
}
