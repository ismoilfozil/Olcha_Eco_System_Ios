//
//  DetailedNewsViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 16/02/23.
//

import UIKit
import OlchaUI
import AnimatedCollectionViewLayout
import OlchaCore
public class DetailedNewsViewController: UICollectionViewController {

    private let xButton: IconButton = {
        let button = IconButton()
        button.setIcon(.back_circle, edgeSize: 0, isIgnoringEdge: true)
        return button
    }()
    
    var news: [NewsModel] = []
    let paging: Paging
    var currentIndex: Int
    private let viewModel: NewsViewModel
    
    public init(viewModel: NewsViewModel, currentIndex: Int, currentPage: Int = 1) {
        self.viewModel = viewModel
        self.currentIndex = currentIndex
        self.paging = .init(current: currentPage)
        
        
        let layout = AnimatedCollectionViewLayout()
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.animator = ZoomInOutAttributesAnimator(scaleRate: 0.7)
        layout.scrollDirection = .horizontal
    
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        autolayout()
        configureViews()
        setupObservers()
        initialRequest()
    }
    
    public func setupViews() {
        view.addSubview(xButton)

    }
    
    public func autolayout() {
        xButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            make.left.equalToSuperview().inset(24)
            make.width.height.equalTo(40)
        }
        collectionView.snp.remakeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    public func configureViews() {
        view.backgroundColor = .olchaWhite
    
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(forCell: DetailedNewsItem.self)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = .zero
    }
    
    public func setupObservers() {
        xButton.clicked { [weak self] in
            guard let self = self else { return }
            self.navigationController?.pop()
        }
    }
    
    public func initialRequest() {
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func loadMore(_ index: Int) {
        guard canLoad(index: index, paging: paging, list: news) else { return }
        viewModel.loadImages(page: paging.current)
    }
    
}
