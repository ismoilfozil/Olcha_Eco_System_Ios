//
//  AllRatingsModalPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 25/07/22.
//

import UIKit
import Cosmos
import Combine
import OlchaUI
class AllRatingsModalPage: BaseViewController {
    
    
    private let ratingContaienr = UIView()
    private let ratingView = CosmosView()
    private let ratingTitle = UILabel()
    private let reviewsTable = UITableView()
    let roomHeight = 32.0
    let count = 6.0
    private var bag = Set<AnyCancellable>()
    weak var viewModel: ReviewsPageViewModel?
    var totalComments: TotalComments?
    
    override func viewDidLoad() {
        
        setupModalViews()
        modalAutolayout()
        configureModalViews(header: "all_rating".localized(), textAlignment: .center)
        setupObservers()
    }
    
    override func setupModalViews() {
        super.setupModalViews()
        
        modalContainer.addSubview(ratingContaienr)
        ratingContaienr.addSubview(ratingView)
        ratingContaienr.addSubview(ratingTitle)
        modalContainer.addSubview(reviewsTable)
    }
    
    override func modalAutolayout() {
        super.modalAutolayout()
        
        ratingContaienr.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        ratingView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.height.equalTo(24)
        }
        
        ratingTitle.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(ratingView.snp.right).inset(-8)
        }
        
        reviewsTable.snp.makeConstraints { make in
            make.top.equalTo(ratingContaienr.snp.bottom).inset(-24)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(roomHeight * count)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    override func configureModalViews(header: String, textAlignment: NSTextAlignment = .left) {
        super.configureModalViews(header: header, textAlignment: textAlignment)
        
        dismissConfiguration()
        ratingContaienr.backgroundColor = .clear
        ratingView.designCosmos(iconSize: 24)
        ratingTitle.textColor = .olchaTextBlack
        ratingTitle.style(.semibold, 18)
        
        reviewsTable.registerClass(forCell: AllReviewRatingRoom.self)
        reviewsTable.delegate = self
        reviewsTable.dataSource = self
        reviewsTable.separatorStyle = .none
        reviewsTable.isScrollEnabled = false
        
        ratingView.settings.updateOnTouch = false
    }
    
    override func setupObservers() {
        super.setupObservers()
        if let viewModel {
            handle(viewModel.$reviews, success: { [weak self] data in
                guard let self else { return }
                ratingView.rating = (data?.total_comments?.rating ?? 0.0).int.double
                totalComments = data?.total_comments
                reviewsTable.reloadData()
            })
        }
    }


}
