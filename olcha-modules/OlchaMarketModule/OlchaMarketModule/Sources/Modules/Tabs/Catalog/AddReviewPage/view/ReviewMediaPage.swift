//
//  MediaViewer.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 01/08/22.
//

import UIKit
import Cosmos
import Combine
import OlchaUI
import OlchaCore
class ReviewMediaPage: BaseViewController {
    
    private let reviewContainer = UIView()
    private let mediaContainer = UIView()
    private let paginationContainer = UIView()
    
    private let ratingView = CosmosView()
    private let reviewText = UITextView()
    private let rightIcon = IconButton()
    let mediaCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let paginationCollection = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    var comment: Comment?
    
    var files: [File] = []
    
    
    var product: ProductModel?
    var currentFile = 0
    
    let viewModel = ReviewsPageViewModel()
    private var bag = Set<AnyCancellable>()
    private let mediaPageObserver = PageObserver()
    
    var currentPage = 1
    var totalPage = 1
    var isLoading = false
    
    weak var coordinator: ReviewCoordinatorProtocol?
    
    let cellSize: CGFloat = 68

    override func setupViews() {
        super.setupViews()
        
        container.addSubview(reviewContainer)
        container.addSubview(mediaContainer)
        container.addSubview(paginationContainer)
        
        reviewContainer.addSubview(ratingView)
        reviewContainer.addSubview(reviewText)
        reviewContainer.addSubview(rightIcon)
        
        mediaContainer.addSubview(mediaCollection)
        
        paginationContainer.addSubview(paginationCollection)
    }
    
    override func autolayout() {
        super.autolayout()
        reviewContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(4)
            make.height.equalTo(56)
        }
        
        ratingView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(4)
            make.width.equalTo(88)
            make.height.equalTo(16)
        }
        
        rightIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
            make.right.equalToSuperview().inset(8)
        }
        
        reviewText.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(4)
            make.top.equalTo(ratingView.snp.bottom)
            make.right.equalTo(rightIcon.snp.left).inset(-4)
        }
        
        paginationContainer.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(4)
            make.left.right.equalToSuperview()
            make.height.equalTo(cellSize)
        }
        
        paginationCollection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mediaContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(reviewContainer.snp.bottom).inset(-24)
            make.bottom.equalTo(paginationContainer.snp.top).inset(-46)
        }
        
        mediaCollection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        super.configureViews()
        self.navigation.configure(style: .review(fromReview: comment != nil))
        self.navigation.setTitle((comment?.user?.name ?? "") + " " + (comment?.user?.lastname ?? ""))
        
        
        view.backgroundColor = .black
        container.backgroundColor = .black
        reviewContainer.backgroundColor = .white.withAlphaComponent(0.2)
        reviewContainer.round()
        ratingView.settings.updateOnTouch = false
        
        rightIcon.setIcon(.rightIcon?.withColor(.white))
        ratingView.designCosmos(iconSize: 16)
        reviewText.backgroundColor = .clear
        reviewText.textColor = .white
        
        reviewText.disable()
        
        paginationCollection.delegate = self
        paginationCollection.dataSource = self
        paginationCollection.registerClass(forCell: CorneredImage.self)
        paginationCollection.isScrollEnabled = false
        paginationCollection.backgroundColor = .clear
        
        mediaCollection.delegate = self
        mediaCollection.dataSource = self
        mediaCollection.registerClass(forCell: ReviewMediaImage.self)
        mediaCollection.backgroundColor = .clear
        mediaCollection.isScrollEnabled = true
        mediaCollection.isPagingEnabled = true
        mediaCollection.backgroundColor = .olchaBackgroundColor
        mediaContainer.backgroundColor = .clear
        
        let manager = OtherLayoutManager()
        paginationCollection.collectionViewLayout = manager.getLayout(with: .cell(size: cellSize))
        
        if let layout = mediaCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.sectionInset = .zero
            mediaCollection.collectionViewLayout = layout
        }
        
        
        fillWithData()
    }
    
    
    override func initialRequest() {
        
    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        viewModel.$reviewFilesError.sink { [weak self] isError in
            guard let self = self else { return }
            self.currentPage -= 1
            self.isLoading = false
        }.store(in: &bag)
        
        handle(viewModel.$reviewFiles, success: { [weak self] data in
            guard let self else { return }
            files.append(contentsOf: data?.files ?? [])
            currentPage = data?.paginator?.current_page ?? 1
            totalPage = data?.paginator?.last_page ?? 1
            isLoading = false
            mediaCollection.reloadData()
            paginationCollection.reloadData()
        })
    }
    
    private func fillWithData() {
        self.ratingView.rating = comment?.rating ?? 0.0
        self.reviewText.text = comment?.review
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.files.count > self.currentFile {
                self.mediaCollection.scrollToItem(at: .init(item: self.currentFile, section: 0), at: .centeredHorizontally, animated: false)
                self.paginationCollection.scrollToItem(at: .init(item: self.currentFile, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
        
        updateLayout()
    }
    
    func loadMore(index: Int) {
        if (files.count-1) == index {
            if !isLoading {
                currentPage += 1
                if currentPage <= totalPage {
                    loadFiles()
                }
            }
        }
    }
    
    func loadFiles() {
        if let id = product?.id {
            isLoading = true
            viewModel.loadReviewsFiles(productID: id, page: currentPage)
        }
    }
    
    func updateLayout() {
        if comment == nil {
            reviewContainer.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            
            reviewContainer.isHidden = true
        }
    }
}
