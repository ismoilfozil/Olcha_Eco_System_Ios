//
//  AddReviewPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 02/08/22.
//

import UIKit
import OlchaUtils
import Combine
import OlchaUI
class AddReviewPage: BaseViewController {
    
    
    
    //MARK: - UI
    private let table = UITableView()
    private let sendReviewButton = OlchaButton()
    
    let addReviewSections: [AddReviewPage.Section] = [
        .rating,
        .product,
        .productRating,
        .review,
        .shippingRating,
        .callRating,
        .anonym,
        .images,
//        .videos
    ]
    
    let editReviewSections: [AddReviewPage.Section] = [
        .rating,
        .product,
        .productRating,
        .review,
        .images
    ]
        
    //MARK: - LOGIC
    private let uploadViewModel = UploadViewModel()
    let viewModel = ReviewsPageViewModel()
    private var bag = Set<AnyCancellable>()
    
    let presentAddMedia = PassthroughSubject<MediaPicker.MediaType, Never>()
    let selectedImageObserver = PassthroughSubject<UIImage?, Never>()
    let selectedVideoObserver = PassthroughSubject<Video?, Never>()
    let playVideoObserver = PassthroughSubject<Video, Never>()
    //MARK: - Coordinator
    weak var coordinator: ReviewCoordinatorProtocol?
        
    var product: ProductModel?
    
    let observers = AddReviewObserver()
    
    var type: ReviewStateType = .add
    
    var editingReview: Comment?
    
    override func setupViews() {
        super.setupViews()
        container.addSubview(table)
        container.addSubview(sendReviewButton)
    }
    
    override func autolayout() {
        super.autolayout()
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        sendReviewButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        super.configureViews()
        navigation.configure(style: .back)
        navigation.setTitle(product?.getName() ?? "" )
        navigation.back.rightButtonState(isHidden: true)
        
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.registerClass(forCell: ReviewIconsRoom.self)
        table.registerClass(forCell: ReviewProductRoom.self)
        table.registerClass(forCell: ServiceRatingRoom.self)
        table.registerClass(forCell: ReviewFieldRoom.self)
        table.registerClass(forCell: ReviewImagesRoom.self)
        table.registerClass(forCell: ReviewVideosRoom.self)
        table.registerClass(forCell: AnonymReviewRoom.self)
        
        table.contentInset = .init(top: 0, left: 0, bottom: 56, right: 0)
        
        sendReviewButton.setTitle("send_review".localized())
        
    }
    
    override func initialRequest() {
        observers.checkButtonState.send(true)
    }
    
    override func setupObservers() {
        self.baseSetupObservers(viewModel: viewModel)
        
        presentAddMedia.sink { [weak self] type in
            guard let self = self else { return }
            self.coordinator?.presentMediaType(mediaType: type,
                                               imageObserver: self.selectedImageObserver,
                                               videoObserver: self.selectedVideoObserver)
        }.store(in: &bag)
        
        uploadViewModel.$image.sink { [weak self] file in
            guard let self = self else { return }
            if let file = file {
                self.viewModel.images.append(file)
                self.viewModel.reloadTable = true
            }
        }.store(in: &bag)
        
        viewModel.$images.sink { [weak self] data in
            guard let self = self else { return }
            print("check errrrrr", data.count)
            self.table.reloadData()
        }.store(in: &bag)
        
        viewModel.$videos.sink { [weak self] data in
            guard let self = self else { return }
            self.table.reloadData()
        }.store(in: &bag)
        
        
        uploadViewModel.uploadIndicator.sink { [weak self] isUploading in
            guard let self = self else { return }
            isUploading ? self.showCenterProgress() : self.hideCenterProgress()
        }.store(in: &bag)
        
        sendReviewButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            
            switch type {
            case .add:
                sendReview()
            case .edit:
                editReview()
            }
            
        }
        
        selectedImageObserver.sink { [weak self] image in
            guard let self = self else { return }
            self.uploadViewModel.upload(image: image)
        }.store(in: &bag)
        
        selectedVideoObserver.sink { [weak self] video in
            guard let self = self else { return }
            if let video = video {
                self.viewModel.videos.append(video)
            }
        }.store(in: &bag)
        
        playVideoObserver.sink { [weak self] video in
            guard let self = self else { return }
            self.coordinator?.presentVideoPlayer(video: video)
        }.store(in: &bag)
        
        viewModel.$reviewSuccess.sink { [weak self] isSuccess in
            guard let self = self else { return }
            if isSuccess {
                self.coordinator?.pushReviewFinish(type: .review,
                                                   lastPage: Self.self)
            }
            self.sendReviewButton.settings.requesting = false
        }.store(in: &bag)
        
        viewModel.$editReviewSuccess.sink { [weak self] isSuccess in
            guard let self else { return }
            if isSuccess {
                self.coordinator?.pushReviewFinish(type: .review,
                                                   lastPage: Self.self)
            }
            self.sendReviewButton.settings.requesting = false
        }.store(in: &bag)
        
        observers
            .reloader
            .sink { [weak self] canReload in
                guard let self = self, canReload else { return }
                self.table.reloadData()
            }.store(in: &bag)
        
        observers
            .checkButtonState
            .sink { [weak self] canCheck in
                guard let self = self, canCheck else { return }
                let isEnabled = self.observers.checkCanReview()
                isEnabled ? self.sendReviewButton.enableButton() : self.sendReviewButton.disableButton()
            }.store(in: &bag)
    }
    
    func setupEditingReview(review: Comment) {
        type = .edit
        self.editingReview = review
        product = review.product
        viewModel.images.append(contentsOf: review.files ?? [])
        observers.productReview = review.review ?? ""
        observers.totalRating = RatingType(rawValue: Int(review.rating ?? -1)) ?? .none
        
        
        viewModel.reloadTable = true
        
    }
    
    private func sendReview() {
        
        guard let id = self.product?.id else { return }
        sendReviewButton.settings.requesting = true
        viewModel.sendReview(productID: id,
                             observers: observers)
        
    }
    
    private func editReview() {
        guard let reviewID = editingReview?.id else { return }
        sendReviewButton.settings.requesting = true
        viewModel.editReview(reviewID: reviewID, observers: observers)
    }
}
