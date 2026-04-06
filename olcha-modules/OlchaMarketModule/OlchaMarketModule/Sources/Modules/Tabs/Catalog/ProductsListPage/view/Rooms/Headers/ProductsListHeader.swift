//
//  ProductsListHeader.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/07/22.
//

import UIKit
import SnapKit
import OlchaUI
extension ProductsListHeader {
    func sortButtonClicked() {
        
        ///getting buttons frame inside main superview  to show menu panel
        delegate?.sortClicked(self.sortButton)
    }
    
    func expandeButtonClicked() {
        changeIcon()
        delegate?.changeProductType()
    }
}
protocol ProductsListHeaderProtocol: AnyObject {
    func changeProductType()
    func sortClicked(_ sender: UIView)
}
class ProductsListHeader: UICollectionReusableView {
    
    enum Section {
        case category
        case price
        case manufacturer
        case feature
    }
    
    let viewModel = ProductsListHeaderViewModel()
    private let contentContainer = UIView()
    private var type: ProductCell.CellType = .shrink {
        didSet {
            if type == .shrink {
                expandIcon.setIcon(.shrink)
            } else {
                expandIcon.setIcon(.expand)
            }
        }
    }
    private let container = UIView()
    private let edgeContainer = UIView()
    let separator = UIView()
    private let sortContainer = UIView()
    private let expandIcon = IconButton()
    private let sortButton = HButtonIcon()
    let tagCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let filterCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    weak var filters: ProductListFilters? {
        didSet {
            updateLayout()
            selectedSortItem = filters?.selectedSort ?? .popular
            filterCollection.reloadData()
            tagCollection.reloadData()
        }
    }
    
    var selectedSortItem: ProductsSortItem = .new {
        didSet {
            sortButton.setTitle(selectedSortItem.text)
        }
    }
    
    weak var delegate: ProductsListHeaderProtocol?
    
    var hideFilters: Bool = false {
        didSet {
            separator.isHidden = true
            filterCollection.snp.updateConstraints { make in
                make.top.equalTo(sortContainer.snp.bottom).inset(0)
                make.height.equalTo(0)
            }
            
            separator.snp.updateConstraints { make in
                make.top.equalTo(tagCollection.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(1)
            }
        }
    }
    
    var headerSections: [Section] = [
        .category,
        .price,
        .manufacturer,
        .feature
    ]
    
    var isShown: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        autolayout()
        configureViews()
    }
    
    private func setupViews() {
        addSubview(contentContainer)
        contentContainer.addSubview(container)
        container.addSubview(edgeContainer)
        edgeContainer.addSubview(tagCollection)
        edgeContainer.addSubview(separator)
        edgeContainer.addSubview(sortContainer)
        edgeContainer.addSubview(filterCollection)
        
        sortContainer.addSubview(sortButton)
        sortContainer.addSubview(expandIcon)
    }
    
    private func autolayout() {
        contentContainer.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        container.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(0)
            make.top.equalToSuperview().inset(0)
            make.left.right.equalToSuperview().inset(0)
        }
        
        edgeContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(0)
            make.bottom.equalToSuperview().inset(0)
            make.top.equalToSuperview().inset(0)
        }
        
        tagCollection.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(32)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(tagCollection.snp.bottom).inset(-16)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        sortContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(separator.snp.bottom).inset(-16)
            make.height.equalTo(32)
        }
        
        filterCollection.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(sortContainer.snp.bottom).inset(-16)
            make.height.equalTo(32)
        }
        
        sortButton.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(180)
        }
        
        expandIcon.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.height.width.equalTo(24)
            make.centerY.equalToSuperview()
        }
    }
    
    private func configureViews() {
        
        contentContainer.backgroundColor = .clear
        
        backgroundColor = .clear
        container.backgroundColor = .clear
        edgeContainer.backgroundColor = .olchaWhite
        separator.backgroundColor = .olchaLightNeutralGray
        expandIcon.setIcon(.shrink)
        sortButton.setTitle(" ")
        sortButton.round(8)
        sortButton.darkBorder()
        sortButton.setIcon(.down_anchor_black?.withColor(.olchaAccentColor))
        
        filterCollection.registerClass(forCell: HeaderFilterItem.self)
        filterCollection.backgroundColor = .olchaBackgroundColor
        tagCollection.registerClass(forCell: FilterItem.self)
        tagCollection.backgroundColor = .olchaBackgroundColor
        
        let filterLayout = UICollectionViewFlowLayout()
        filterLayout.scrollDirection = .horizontal
        filterLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        filterLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        filterLayout.minimumLineSpacing = .zero
        filterLayout.minimumInteritemSpacing = .zero
        
        filterCollection.delegate = self
        filterCollection.dataSource = self
        filterCollection.collectionViewLayout = filterLayout
        filterCollection.showsHorizontalScrollIndicator = false
        filterCollection.contentInset = .zero
        
        let tagLayout = UICollectionViewFlowLayout()
        tagLayout.scrollDirection = .horizontal
        tagLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        tagLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        tagLayout.minimumLineSpacing = 6
        tagLayout.minimumInteritemSpacing = 6
        
        
        tagCollection.delegate = self
        tagCollection.dataSource = self
        tagCollection.collectionViewLayout = tagLayout
        tagCollection.showsHorizontalScrollIndicator = false
        
        configureActions()
    }
    
    private func configureActions() {
        expandIcon.clicked { [weak self] in
            guard let self = self else { return }
            self.expandeButtonClicked()
        }
        
        sortButton.clicked { [weak self] in
            guard let self = self else { return }
            self.sortButtonClicked()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        autolayout()
        configureViews()
    }
    
    private func changeIcon() {
        if type == .shrink {
            type = .expand
        } else {
            type = .shrink
        }
    }
    
    private func updateLayout() {
        tagCollection.snp.updateConstraints { make in
            make.height.equalTo( (filters?.tags.isEmpty ?? true) ? 0 : 32 )
        }
    }
    
    func setup(filters: ProductListFilters) {
        self.filters = filters
        self.type = filters.cellType
    }
    
    func animate(show: Bool, withAnimation: Bool = true , completed: (() -> Void )? = nil) {
        
        edgeContainer.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(show ? 0 : 300)
            make.top.equalToSuperview().inset(show ? 0 : -300)
        }
        
        if withAnimation && (isShown != show) {
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let self = self else { return }
                self.layoutIfNeeded()
            } completion: { _ in
                completed?()
            }
        } else {
            self.layoutIfNeeded()
        }
        
        isShown = show
    }
}

class EmptyHeader: UICollectionReusableView {
    private let container = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        autolayout()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        autolayout()
        configureViews()
    }
    
    private func setupViews() {
        addSubview(container)
    }
    
    private func autolayout() {
        container.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(0)
            make.top.equalToSuperview().inset(0)
            make.left.right.equalToSuperview().inset(0)
        }
    }
    
    private func configureViews() {
        container.backgroundColor = .clear
    }
    
}
