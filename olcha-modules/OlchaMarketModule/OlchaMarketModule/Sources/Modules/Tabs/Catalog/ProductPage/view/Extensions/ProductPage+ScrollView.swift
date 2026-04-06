//
//  ProductPage+ScrollView.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 01/11/23.
//

import UIKit
import Zoomy
import SnapKit
extension ProductPage {
    
    func setupScrollView() {
        for section in sections {
            switch section {
            case .images:
                imagesSetup()
            case .video:
                videoSetup()
            case .reviewButtons:
                reviewButtonsSetup()
            case .productsData:
                dataSetup()
            case .cashAd:
                cashAdSetup()
            case .variations:
                variationsSetup()
            case .gift:
                giftSetup()
            case .buyActions:
                buyActionsSetup()
            case .shippingData:
                shippingDataSetup()
            case .storeProducts:
                storeProductsSetup()
            case .description:
                descriptionSetup()
            case .warranty:
                warrantySetup()
            case .priceHistory:
                priceHistorySetup()
            case .brand:
                brandSetup()
            case .analogProducts:
                analogProductsSetup()
            case .reviews:
                reviewsSetup()
            case .faqs:
                faqsSetup()
            case .seenAlsoProducts:
                seenAlsoProductsSetup()
            case .similarProducts:
                similarProductsSetup()
            default:
                break
            }
        }
        
        setupScrollViewData()
    }
    
    func setupScrollViewData() {
        for section in sections {
            reloadSection(section: section)
        }
    }
    func reloadSection(section: Sections) {
        switch section {
        case .images:
            factory.picturesRoom.setup(with: product)
        case .video:
            factory.stateSection(section: .video, isHidden: (product?.video_url ?? "").isEmpty)
        case .reviewButtons:
            factory.reviewButtonsRoom.setup(with: product, reviews: reviews, faqs: faqs)
        case .productsData:
            factory.dataRoom.setup(with: product)
        case .cashAd:
            factory.cashAdRoom.setup(with: "")
            factory.stateSection(section: .cashAd, isHidden: true)
        case .variations:
            factory.variationsRoom.setup(with: self.helper)
            factory.stateSection(section: .variations, isHidden: helper.resultVariations.isEmpty)
        case .gift:
            factory.giftProductRoom.setup(with: self.product?.gifts ?? [])
            factory.stateSection(section: .gift, isHidden: product?.gifts?.isEmpty ?? true)
        case .buyActions:
            factory.actionsRoom.setup(with: fullProduct, product: product)
            factory.stateSection(section: .buyActions, isHidden: fullProduct == nil)
        case .description:
            let isEmpty = ((product?.getDescription() ?? "")  == "") && (characteristicsData?.features?.isEmpty ?? true)
            
            factory.descriptionSegmentsRoom.selected(type: self.descriptionRoom)
            factory.descriptionsRoom.setup(with: product)
            factory.characteristicsRoom.setup(with: characteristicsData)
            if isEmpty {
                factory.stateSection(section: .description, isHidden: true)
            } else {
                factory.stateSection(section: .description, isHidden: false)
                factory.descriptionsRoom.isHidden = (descriptionRoom == .characteristics)
                factory.characteristicsRoom.isHidden = (descriptionRoom == .description)
            }
        case .warranty:
            factory.warrantyRoom.setup(with: WarrantyHelper.getWarrantyTitle(product))
            factory.stateSection(section: .warranty, isHidden: !WarrantyHelper.isWarrantyEnabled(product))
        case .priceHistory:
            factory.priceHistoryRoom.setup(with: pricesHistoryData?.priceHistory ?? [])
            factory.stateSection(section: .priceHistory, isHidden:  ((pricesHistoryData?.priceHistory?.count ?? 0) < 2))
        case .brand:
            factory.brandRoom.setup(with: self.product?.manufacturer, categories: self.brandCategories?.categories ?? [])
            factory.stateSection(section: .brand, isHidden: brandCategories?.categories?.isEmpty ?? true)
        case .shippingData:
            factory.shippingDataRoom.setup(with: [product?.store].compactMap { $0 })
        case .reviews:
            factory.reviewsHeaderRoom.setup(with: reviews,
                                            product: product,
                                            reviewFiles: reviewFiles)
            factory.reviewsRoom.setup(with: reviews,
                                      product: product,
                                      reviewFiles: reviewFiles)
        case .faqs:
            factory.faqsHeaderRoom.setup(with: (faqs?.paginator?.total ?? 0).string)
            factory.faqsRoom.setup(with: faqs)
        case .storeProducts:
            factory.storeProductsRoom.setup(product: product,
                                            fullProduct: fullProduct,
                                            parentProductEnabled: !checkVariation(product: self.product,
                                                                                  productType: .storeProduct,
                                                                                  withMessage: false))
            factory.stateSection(section: .storeProducts,
                                 isHidden: factory.storeProductsRoom.getTableStoreProductsCount() == 0)
        case .similarProducts:
            factory.similarProductsRoomHeader.configure(with: .title("similar_products".localized()))
            factory.similarProductsRoom.setup(with: self.similarProducts)
            factory.similarProductsRoom.configure(style: .white,
                                                  withShowAll: true,
                                                  cellType: .shrink)
            factory.stateSection(section: .similarProducts, isHidden: similarProducts?.products?.isEmpty ?? true)
        case .seenAlsoProducts:
            factory.seenAlsoProductsRoomHeader.configure(with: .title("seen_with_product".localized()))
            factory.seenAlsoProductsRoom.setup(with: seenAlsoProducts)
            factory.seenAlsoProductsRoom.configure(style: .white,
                                                  withShowAll: true,
                                                  cellType: .shrink)
            factory.stateSection(section: .seenAlsoProducts, isHidden: seenAlsoProducts?.products?.isEmpty ?? true)
        case .analogProducts:
            factory.analogProductsRoomHeader.configure(with: .title("analog_products".localized()))
            factory.analogProductsRoom.setup(with: self.analogProducts)
            factory.analogProductsRoom.configure(style: .white,
                                                 withShowAll: true,
                                                 cellType: .shrink)
            factory.stateSection(section: .analogProducts, isHidden: analogProducts?.products?.isEmpty ?? true)
        default:
            break
        }
    }
    
    private func imagesSetup() {
        scrollView.addArrangedSubview(view: factory.picturesRoom)
        factory.picturesRoom.zoomObserver = { [weak self] imageView in
            guard let self = self else { return }
            var settings = ImageZoomControllerSettings.instaZoomSettings
            settings.secondaryBackgroundColor = .olchaWhite
            settings.primaryBackgroundColor = .olchaWhite
            self.addZoombehavior(for: imageView,
                                 in: factory.picturesRoom,
                                 settings: settings)
        }
        factory.picturesRoom.pushProductMedia = pushProductMedia
    }
    private func videoSetup() {
        scrollView.addArrangedSubview(view: factory.showVideoRoom)
        factory.showVideoRoom.isHidden = true
        factory.showVideoRoom.videoButton.settings.clicked { [weak self] in
            guard let self = self,
                  let url = self.product?.video_url else { return }
            let vc = VideoPlayerPage()
            vc.videoURL = url
            self.navigationController?.push(vc)
        }
    }
    private func reviewButtonsSetup() {
        scrollView.addArrangedSubview(view: factory.reviewButtonsRoom)
        factory.reviewButtonsRoom.reviewButtonClicker = self.reviewButtonClicker
    }
    private func dataSetup() {
        scrollView.addArrangedSubview(view: factory.dataRoom)
        factory.dataRoom.pushBrandObserver = pushBrandObserver
    }
    private func storeProductsSetup() {
        scrollView.addArrangedSubview(view: factory.storeProductsRoom)
        factory.storeProductsRoom.pushStoreObserver = pushStoreObserver
        factory.storeProductsRoom.parentObserver = parentObserver
        factory.storeProductsRoom.openStoreProducts = openStoreProducts
    }
    private func cashAdSetup() {
        scrollView.addArrangedSubview(view: factory.cashAdRoom)
    }
    private func variationsSetup() {
        scrollView.addArrangedSubview(view: factory.variationsRoom)
    }
    private func giftSetup() {
        scrollView.addArrangedSubview(view: factory.giftProductRoom)
        factory.giftProductRoom.productHelper = productHelper
        factory.giftProductRoom.giftInfoButton.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.presentGiftInfo(product: self.product)
        }
    }
    private func buyActionsSetup() {
        scrollView.addArrangedSubview(view: factory.actionsRoom)
        factory.actionsRoom.basketButton.clicked { [weak self] in
            guard let self = self else { return }
            self.cartPresenter()
        }
        
        factory.actionsRoom.simpleBuyButton.clicked { [weak self] in
            guard let self = self else { return }
            
            checkVariation(product: product) { product in
                self.product = product
                self.initialRequest()
                self.table.reloadData()
                self.coordinator?.presentSimpleBuy(product: self.product,
                                                   type: Funcs.isAvailableOneClick(fullProduct: self.fullProduct) ? .oneClick : .preOrder)
            }
            
        }
        
        factory.actionsRoom.creditButton.clicked { [weak self] in
            guard let self = self else { return }
            
            presentCreditVariation()
        }
    }
    private func descriptionSetup() {
        scrollView.addArrangedSubview(view: factory.descriptionSegmentsRoom)
        factory.descriptionSegmentsRoom.mainTableReloader = mainTableReloader
        factory.descriptionSegmentsRoom.segmentObserver = segmentObserver
        factory.descriptionSegmentsRoom.selected(type: descriptionRoom)
        
        scrollView.addArrangedSubview(view: factory.characteristicsRoom)
        factory.characteristicsRoom.mainTableReloader = mainTableReloader
        factory.characteristicsRoom.scrollToDescription = scrollToDescription
        
        scrollView.addArrangedSubview(view: factory.descriptionsRoom)
        factory.descriptionsRoom.mainTableReloader = mainTableReloader
        
        factory.descriptionsRoom.showAllButton.clicked { [weak self] in
            guard let self else { return }
            coordinator?.presentProductDescription(product: product)
        }
        
        factory.characteristicsRoom.showAllButton.clicked { [weak self] in
            guard let self else { return }
            coordinator?.presentProductCharacteristics(data: characteristicsData)
        }
    }
    private func warrantySetup() {
        scrollView.addArrangedSubview(view: factory.warrantyRoom)
    }
    private func priceHistorySetup() {
        scrollView.addArrangedSubview(view: factory.priceHistoryRoom)
        factory.priceHistoryRoom.expandeButton.clicked { [weak self] in
            guard let self else { return }
            factory.priceHistoryRoom.isExpande = !factory.priceHistoryRoom.isExpande
            factory.priceHistoryRoom.expandeButton.rotate(degree: .pi)

            UIView.animate(withDuration: factory.priceHistoryRoom.isExpande ? 0 : 0.3) {
                self.factory.priceHistoryRoom.container.layoutIfNeeded()
            }
        }
    }
    private func brandSetup() {
        scrollView.addArrangedSubview(view: factory.brandRoom)
        factory.brandRoom.style = .lightGray
        factory.brandRoom.pushBrandObserver = pushBrandObserver
        factory.brandRoom.pushCategoryObserver = pushCategoryObserver
    }
    private func shippingDataSetup() {
        scrollView.addArrangedSubview(view: factory.shippingDataRoom)
        factory.shippingDataRoom.mainTableReloader = mainTableReloader
    }
    private func reviewsSetup() {
        scrollView.addArrangedSubview(view: factory.reviewsHeaderRoom)
        factory.reviewsHeaderRoom.pushReviewMedia = pushReviewMedia
        factory.reviewsHeaderRoom.pushAllMedia = pushAllMedia
        factory.reviewsHeaderRoom.infoIcon.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.presentAllRatings(viewModel: self.reviewsViewModel)
        }
        factory.reviewsHeaderRoom.writeReviewButton.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.pushAddReview(product: self.product)
        }
        
        scrollView.addArrangedSubview(view: factory.reviewsRoom)
        factory.reviewsRoom.pushAllReviews = pushAllReviews
        factory.reviewsRoom.pushReviewMedia = pushReviewMedia
        factory.reviewsRoom.pushReviewReplies = pushReviewReplies
        factory.reviewsRoom.likeObserver = likeObserver
        
    }
    private func analogProductsSetup() {
        scrollView.addArrangedSubview(view: factory.analogProductsRoomHeader)
        
        scrollView.addArrangedSubview(view: factory.analogProductsRoom)
        factory.analogProductsRoom.productHelper = productHelper
        factory.analogProductsRoom.seeAllButton.clicked { [weak self] in
            guard let self = self else { return }
            let filters = self.filters.copy()
            filters.similarity = .analog
            self.coordinator?.pushProductsList(filters: filters)
        }
        
        scrollView.container.setCustomSpacing(0, after: factory.analogProductsRoomHeader)
    }
    private func similarProductsSetup() {
        scrollView.addArrangedSubview(view: factory.similarProductsRoomHeader)
        
        scrollView.addArrangedSubview(view: factory.similarProductsRoom)
        factory.similarProductsRoom.productHelper = productHelper
        factory.similarProductsRoom.seeAllButton.clicked { [weak self] in
            guard let self = self else { return }
            let filters = self.filters.copy()
            filters.similarity = .similar
            self.coordinator?.pushProductsList(filters: filters)
        }
        
        scrollView.container.setCustomSpacing(0, after: factory.similarProductsRoomHeader)
    }
    private func seenAlsoProductsSetup() {
        scrollView.addArrangedSubview(view: factory.seenAlsoProductsRoomHeader)
        
        scrollView.addArrangedSubview(view: factory.seenAlsoProductsRoom)
        factory.seenAlsoProductsRoom.productHelper = productHelper
        factory.seenAlsoProductsRoom.seeAllButton.clicked { [weak self] in
            guard let self = self else { return }
            let filters = self.filters.copy()
            filters.similarity = .analog
            self.coordinator?.pushProductsList(filters: filters)
        }
    }
    private func faqsSetup() {
        scrollView.addArrangedSubview(view: factory.faqsHeaderRoom)
        factory.faqsHeaderRoom.askQuestion.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.pushAskQuestion(product: self.product)
        }
        
        scrollView.addArrangedSubview(view: factory.faqsRoom)
        factory.faqsRoom.pushFaqReplies = pushFaqReplies
        factory.faqsRoom.pushAllFAQs = pushAllFAQs
        factory.faqsRoom.likeObserver = likeObserver
    }
}
