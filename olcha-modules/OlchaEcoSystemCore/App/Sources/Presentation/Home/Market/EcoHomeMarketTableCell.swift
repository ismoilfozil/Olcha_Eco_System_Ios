import UIKit
import OlchaUI
import OlchaUtils

public class EcoHomeMarketTableCell: BaseTableCell {
    
    public weak var observers: EcoHomeObservers? {
        didSet {
            collectionFlowDelegate.observers = observers
        }
    }
    
    private let collectionDataSource = BuilderCollectionViewDataSource()
    private let collectionFlowDelegate = BuilderCollectionViewFlowLayoutDelegate()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()

    private let headerView = EcoHomeSectionHeader()
    
    private lazy var collection: DynamicCollection = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 12
        layout.scrollDirection = .horizontal
        let collection = DynamicCollection(frame: .zero, collectionViewLayout: layout)
        collection.registerClass(forCell: GridBannerCollectionCell.self)
        collection.registerClass(forCell: GridCategoryCollectionCell.self)
        collection.registerClass(forCell: VerticalBannerCollectionCell.self)
        collection.registerClass(forCell: HorizontalCategoryCollectionCell.self)
        collection.delegate = collectionFlowDelegate
        collection.dataSource = collectionDataSource
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return collection
    }()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        collection.collectionViewLayout.invalidateLayout()
    }
    
    public override func setupViews() {
        container.addSubview(contentStack)
        contentStack.addArrangedSubview(headerView)
        contentStack.addArrangedSubview(collection)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview().inset(10)
        }
        contentStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(20)
        }
        collection.snp.makeConstraints { make in
            make.height.equalTo(136)
        }
    }
    
    public override func configureViews() {
        collectionFlowDelegate.collectionDataSource = collectionDataSource
        collectionFlowDelegate.module = .olcha
        
        container.round(24)
        layer.zPosition = 1
        clipsToBounds = false
        contentView.clipsToBounds = false
        container.backgroundColor = .white
        headerView.setAllButton { [weak self] in
            guard let self else { return }
            observers?.clickActionSubject.send(MarketClickAction.catalog)
        }
    }
    
    public func setup(with model: BuilderSection) {
        collectionFlowDelegate.sectionModel = model
        headerView.setSectionLabel(model.section_name ?? "", image: .olchaMarketSection)
        collectionDataSource.cellData = model.items.map({ item in
            (cellType: model.cellType, data: item)
        })
        collection.reloadData()
    }
    
    public func setup() {
        headerView.setAllButtonLabel("home_section_all".localized(.olchaEcoSystemCore))
    }
    
}
