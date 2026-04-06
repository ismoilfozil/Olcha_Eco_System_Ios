//
//  ProductPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 15/07/22.
//
import Zoomy
import OlchaUI
import UIKit

//MARK: - Sections
extension ProductPage {
    enum Sections: Int, CaseIterable {
        case images
        case video
        case reviewButtons
        case productsData
        case cashAd
        case variations
        case gift
        case buyActions
        case shippingData
        case storeProducts
        case description
        case warranty
        case priceHistory
        case brand
        case analogProducts
        case reviews
        case faqs
        case seenAlsoProducts
        case similarProducts
        case all
        var height: CGFloat {
            switch self {
            case .reviewButtons: return 64
            default: return UITableView.automaticDimension
            }
        }
        
        var footerHeight: CGFloat {
            switch self {
            case .images:
                return 24
            case .video:
                return 12
            case .reviewButtons:
                return 24
            case .productsData:
                return 16
            case .cashAd:
                return 32
            case .variations:
                return 16
            case .gift:
                return 32
            case .buyActions:
                return 24
            case .shippingData:
                return 24
            case .storeProducts:
                return 24
            case .description:
                return 24
            case .warranty:
                return 24
            case .priceHistory:
                return 24
            case .brand:
                return 24
            case .analogProducts:
                return 48
            case .reviews:
                return 24
            case .faqs:
                return 24
            case .seenAlsoProducts:
                return 48
            case .similarProducts:
                return 48
            case .all:
                return 0
            }
        }
        
        var withSeparator: Bool {
            switch self {
            case .cashAd, .gift, .analogProducts, .seenAlsoProducts, .faqs, .reviews:
                return true
                default: return false
            }
        }
        
        var withEdge: Bool {
            switch self {
            case .gift:
                return true
                default: return false
            }
        }
        
        var maxRows: Int {
            switch self {
            case .description: return 3
            case .analogProducts: return 3
            case .similarProducts: return 3
            case .faqs: return 3
            case .reviews: return 3
            case .storeProducts: return -1
            default: return 2
            }
        }
    }
}
//MARK: - Row cell
extension ProductPage: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.sections[indexPath.section]
        
        switch section {
        case .description, .faqs, .reviews, .similarProducts, .analogProducts, .seenAlsoProducts:
            if indexPath.row == 2 {
                let cell = tableView.dequeue(FooterItem.self, for: indexPath)
                cell.responder.withSeparator = section.withSeparator
                cell.responder.withEdge = section.withEdge
                return cell
            }
        case .storeProducts:
            if isStoreProductSeparator(indexPath) {
                let cell = tableView.dequeue(FooterItem.self, for: indexPath)
                cell.responder.withSeparator = section.withSeparator
                cell.responder.withEdge = section.withEdge
                cell.responder.height = Sections.storeProducts.footerHeight
                return cell
            }
            
            break
        default:
            if indexPath.row == 1 {
                let cell = tableView.dequeue(FooterItem.self, for: indexPath)
                cell.responder.withSeparator = section.withSeparator
                cell.responder.withEdge = section.withEdge
                return cell
            }
            break
        }
        
        switch section {
        case .images:
            let cell = tableView.dequeue(ProductPicturesRoom.self, for: indexPath)
            
            cell.zoomObserver = { [weak self] imageView in
                guard let self = self else { return }
                var settings = ImageZoomControllerSettings.instaZoomSettings
                settings.secondaryBackgroundColor = .olchaWhite
                settings.primaryBackgroundColor = .olchaWhite
                self.addZoombehavior(for: imageView, in: cell, settings: settings)
            }
            
            cell.pushProductMedia = pushProductMedia
            cell.setup(with: self.product)
            
            return cell
        case .video:
            let cell = tableView.dequeue(ShowVideoRoom.self, for: indexPath)
            
            cell.videoButton.settings.clicked { [weak self] in
                guard let self = self,
                      let url = self.product?.video_url else { return }
                let vc = VideoPlayerPage()
                vc.videoURL = url
                self.navigationController?.push(vc)
            }
            
            return cell
        case .reviewButtons:
            let cell = tableView.dequeue(ReviewButtonsRoom.self, for: indexPath)
            cell.setup(with: self.product, reviews: self.reviews)
            cell.reviewButtonClicker = self.reviewButtonClicker
            return cell
        case .productsData:
            let cell = tableView.dequeue(ProductsDataRoom.self, for: indexPath)
            cell.pushBrandObserver = pushBrandObserver
            cell.setup(with: self.product)
            return cell
        case .cashAd:
            let cell = tableView.dequeue(CashAdRoom.self, for: indexPath)
            cell.setup(with: "")
            return cell
        case .variations:
            let cell = tableView.dequeue(VariationsRoom.self, for: indexPath)
            cell.setup(with: self.helper)
            return cell
        case .gift:
            let cell = tableView.dequeue(ProductsGiftRoom.self, for: indexPath)
            cell.productHelper = productHelper
            cell.setup(with: self.product?.gifts ?? [])
            cell.giftInfoButton.clicked { [weak self] in
                guard let self = self else { return }
                self.coordinator?.presentGiftInfo(product: self.product)
            }

            return cell
        case .buyActions:
            let cell = tableView.dequeue(ProductActionsRoom.self, for: indexPath)
            cell.setup(with: fullProduct, product: product)
            cell.basketButton.clicked { [weak self] in
                guard let self = self else { return }
                self.cartPresenter()
            }
            
            cell.simpleBuyButton.clicked { [weak self] in
                guard let self = self else { return }
                
                checkVariation(product: product) { product in
                    self.product = product
                    self.initialRequest()
                    self.table.reloadData()
                    self.coordinator?.presentSimpleBuy(product: self.product,
                                                       type: Funcs.isAvailableOneClick(fullProduct: self.fullProduct) ? .oneClick : .preOrder)
                }
                
            }
            
            cell.creditButton.clicked { [weak self] in
                guard let self = self else { return }
                
                presentCreditVariation()
            }
            
            return cell
        case .storeProducts:
            return getStoreProductRows(tableView, indexPath)
        case .description:
            if indexPath.row == 0 {
                let cell = tableView.dequeue(DescriptionSegmentsRoom.self, for: indexPath)
                cell.mainTableReloader = self.mainTableReloader
                cell.segmentObserver = self.segmentObserver
                cell.selected(type: self.descriptionRoom)
                return cell
            } else {
                if self.descriptionRoom == .characteristics {
                    let cell = tableView.dequeue(CharacteristicsRoom.self, for: indexPath)
                    cell.setup(with: self.characteristicsData)
                    cell.mainTableReloader = self.mainTableReloader
                    cell.scrollToDescription = scrollToDescription
                    return cell
                } else {
                    let cell = tableView.dequeue(DescriptionsRoom.self, for: indexPath)
                    cell.setup(with: product)
                    cell.mainTableReloader = self.mainTableReloader
                    return cell
                }
            }
        case .warranty:
            let cell = tableView.dequeue(WarrantyRoom.self, for: indexPath)
            cell.setup(with: WarrantyHelper.getWarrantyTitle(product))
            return cell
        case .priceHistory:
            let cell = tableView.dequeue(PriceHistoryRoom.self, for: indexPath)
            
            cell.setup(with: pricesHistoryData?.priceHistory ?? [])
            cell.expandeButton.clicked {
                cell.isExpande = !cell.isExpande
                cell.expandeButton.rotate(degree: .pi)

                UIView.animate(withDuration: cell.isExpande ? 0 : 0.3) {
                    cell.contentView.layoutIfNeeded()
                    tableView.performBatchUpdates(nil, completion: nil)
                }

            }
            return cell
        case .brand:
            let cell = tableView.dequeue(ProductBrandRoom.self, for: indexPath)
            cell.style = .lightGray
            cell.pushBrandObserver = pushBrandObserver
            cell.pushCategoryObserver = pushCategoryObserver
            cell.setup(with: self.product?.manufacturer, categories: self.brandCategories?.categories ?? [])
            return cell
        case .shippingData:
            let cell = tableView.dequeue(ShippingDataRoom.self, for: indexPath)
            cell.mainTableReloader = mainTableReloader
            
            cell.setup(with: [product?.store].compactMap { $0 })
            
            return cell
        case .similarProducts:
            if indexPath.row == 0 {
                let cell = tableView.dequeue(ComponentHeader.self, for: indexPath)
                cell.configure(with: .title("similar_products".localized()))
                return cell
            } else {
                let cell = tableView.dequeue(HorizontalPromotedRoom.self, for: indexPath)
                cell.setup(with: self.similarProducts)
                cell.configure(style: .white,
                               withShowAll: true,
                               cellType: .shrink)
                cell.responder.productHelper = productHelper
                
                cell.responder.seeAllButton.clicked { [weak self] in
                    guard let self = self else { return }
                    let filters = self.filters.copy()
                    filters.similarity = .similar
                    self.coordinator?.pushProductsList(filters: filters)
                }
                
                return cell
            }
            
        case .analogProducts:
            if indexPath.row == 0 {
                let cell = tableView.dequeue(ComponentHeader.self, for: indexPath)
                cell.configure(with: .title("analog_products".localized()))
                return cell
            } else {
                let cell = tableView.dequeue(HorizontalPromotedRoom.self, for: indexPath)
                cell.setup(with: self.analogProducts)
                cell.configure(style: .white,
                               withShowAll: true,
                               cellType: .shrink)
                cell.responder.productHelper = productHelper
                
                cell.responder.seeAllButton.clicked { [weak self] in
                    guard let self = self else { return }
                    let filters = self.filters.copy()
                    filters.similarity = .analog
                    self.coordinator?.pushProductsList(filters: filters)
                }
                
                return cell
            }
        case .reviews:
            
            if indexPath.row == 0 {
                let cell = tableView.dequeue(ProductReviewsHeaderRoom.self, for: indexPath)
                cell.pushReviewMedia = pushReviewMedia
                cell.pushAllMedia = pushAllMedia
                cell.setup(with: reviews,
                           product: product,
                           reviewFiles: reviewFiles)
                
                
                cell.infoIcon.clicked { [weak self] in
                    guard let self = self else { return }
                    self.coordinator?.presentAllRatings(viewModel: self.reviewsViewModel)
                }
                cell.writeReviewButton.clicked { [weak self] in
                    guard let self = self else { return }
                    self.coordinator?.pushAddReview(product: self.product)
                }
                return cell
            } else {
                
                let cell = tableView.dequeue(ProductReviewsRoom.self, for: indexPath)
                
                cell.pushAllReviews = pushAllReviews
                cell.pushReviewMedia = pushReviewMedia
                cell.pushReviewReplies = pushReviewReplies
                cell.configuration(indexPath: indexPath, delegate: self)
                cell.likeObserver = likeObserver
                cell.setup(with: reviews,
                           product: product,
                           reviewFiles: reviewFiles)
                
                
                return cell
            }
                
        case .faqs:
            if indexPath.row == 0 {
                let cell = tableView.dequeue(ProductFAQsHeaderRoom.self, for: indexPath)
                cell.setup(with: (faqs?.paginator?.total ?? 0).string)
                
                cell.askQuestion.settings.clicked { [weak self] in
                    guard let self = self else { return }
                    self.coordinator?.pushAskQuestion(product: self.product)
                }
                
                return cell
            } else {
                let cell = tableView.dequeue(ProductFAQsRoom.self, for: indexPath)
                cell.pushFaqReplies = pushFaqReplies
                cell.pushAllFAQs = pushAllFAQs
                cell.likeObserver = likeObserver
                cell.configuration(indexPath: indexPath, delegate: self)
                cell.setup(with: faqs)
                cell.layoutIfNeeded()
                return cell
            }
        default:
            return UITableViewCell()
        }
        
    }
    
    private func getStoreProductRows(_ tableView: UITableView, _ indexPath: IndexPath) -> BaseTableCell {
        
        if isStoreProductHeader(indexPath) {
            let cell = tableView.dequeue(ComponentHeader.self, for: indexPath)
            cell.configure(with: .title("store_products_header".localized()))
            return cell
        }
        
        if isStoreProductItem(indexPath) {
            let cell = tableView.dequeue(StoreProductItem.self, for: indexPath)
            cell.pushStoreObserver = pushStoreObserver
            cell.parentObserver = parentObserver
            
            let actualCount = getActualStoreProductsCount()
            cell.setup(with: product?.storeProducts?[indexPath.row - 1],
                       product: product)
            
            if actualCount == 1 {
                cell.configure(with: .single)
            } else {
                cell.configure(with: .middle)
                if indexPath.row == 1 {
                    cell.configure(with: .top)
                } else if (indexPath.row) == (actualCount) && actualCount == (product?.storeProducts?.count ?? 0) {
                    cell.configure(with: .bottom)
                } else {
                    cell.configure(with: .middle)
                }
                
            }
            
            cell.parentProductButton.isUserInteractionEnabled = !checkVariation(product: self.product, productType: .storeProduct, withMessage: false)
            
            return cell
        }
        
        if isStoreProductFooter(indexPath) {
            let cell = tableView.dequeue(StoreProductFooteritem.self, for: indexPath)
            cell.setup(with: product?.storeProducts?.count ?? 0)
            cell.button.clicked { [weak self] in
                guard let self = self else { return }
                self.openStoreProducts.send(true)
            }
            return cell
        }
        
        return .init()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = self.sections[indexPath.section]
        var height: CGFloat
        
        if let size = tableSize[indexPath] {
            return size
        }
        
        if indexPath.row == (section.maxRows - 1) {
            height = section.footerHeight
        } else {
            height = section.height
        }
        
        
        return tableView.cacheHeights(height, indexPath: indexPath)
    }
    
    func scrollToTop() {
        table.setContentOffset(.zero, animated: true)
    }
 
    func presentCreditVariation() {
        checkVariation(product: product,
                       completion: { [weak self] product in
            guard let self = self else { return }
            self.product = product
            self.initialRequest()
            self.table.reloadData()
            self.coordinator?.presentCreditBuy(product: product)
        })
    }
}
//MARK: Reloader
extension ProductPage: InnerTableViewCellDelegate {
    func innerTableView(forIndex: IndexPath, atSize size: CGFloat) {
        if let s = tableSize[forIndex] {
            if s != size {

                tableSize[forIndex] = size
                self.table.beginUpdates()
                self.table.endUpdates()
                
            }

        } else {

            tableSize[forIndex] = size

            self.table.beginUpdates()
            self.table.endUpdates()
        }
    }
}

//MARK: UITableView Rows Count
extension ProductPage {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        switch section {
        case .images:
            return 2
        case .cashAd:
            return 0
        case .description:
            return ((product?.getTrimmedDescription() ?? "") == "" && (characteristicsData?.features?.isEmpty ?? true)) ? 0 : 3
        case .video:
            return (product?.video_url ?? "").isEmpty ? 0 : 2
        case .variations:
            return rowsCount(in: .variations,
                             rows: (helper.resultVariations.isEmpty) ? 0 : 2)
        case .brand:
            return rowsCount(in: .brand,
                             rows: (brandCategories?.categories?.isEmpty ?? true) ? 0 : 2)
        case .analogProducts:
            return rowsCount(in: .analogProducts,
                             rows: (analogProducts?.products?.isEmpty ?? true) ? 0 : 3)
        case .similarProducts:
            return rowsCount(in: .similarProducts,
                             rows: (similarProducts?.products?.isEmpty ?? true) ? 0 : 3)
        case .storeProducts:
            return rowsCount(in: .storeProducts,
                             rows: getTableStoreProductsCount())
        case .priceHistory:
            return rowsCount(in: .priceHistory,
                             rows: ((pricesHistoryData?.priceHistory?.count ?? 0) < 2) ? 0 : 2)
        case .buyActions:
            return (fullProduct == nil) ? 0 : 2
        case .gift:
            return (product?.gifts?.isEmpty ?? true) ? 0 : 2
        case .faqs:
            return faqsLoaded ? 3 : 0
        case .reviews:
            return reviewsLoaded ? 3 : 0
        case .warranty:
            return WarrantyHelper.isWarrantyEnabled(product) ? 2 : 0
        default: return 2
        }
        
    }
    
    private func rowsCount(in section: ProductPage.Sections, rows: Int) -> Int {
        if !(loadedSection[.brand] ?? false) {
            return 1
        }
        return rows
    }
}

//MARK: Store Product Rows
extension ProductPage {
    var maxCount : Int  { 3 }
    private func isStoreProductHeader(_ indexPath: IndexPath) -> Bool {
        indexPath.row == 0
    }
    
    private func isStoreProductItem(_ indexPath: IndexPath) -> Bool {
        !isStoreProductHeader(indexPath) && !isStoreProductFooter(indexPath) && !isStoreProductSeparator(indexPath)
    }
    
    private func isStoreProductFooter(_ indexPath: IndexPath) -> Bool {
        indexPath.row > 0 && indexPath.row == (getTableStoreProductsCount() - 2) && getActualStoreProductsCount() > maxCount
    }
    
    private func isStoreProductSeparator(_ indexPath: IndexPath) -> Bool {
        indexPath.row > 0 && indexPath.row == (getTableStoreProductsCount() - 1)
    }
    
    private func getTotalStoreProductsCount() -> Int {
        product?.storeProducts?.count ?? 0
    }
    
    private func getTableStoreProductsCount() -> Int {
        guard (getTotalStoreProductsCount() > 0),
              Funcs.isAvailableOneClick(fullProduct: fullProduct) else { return 0 }
        return getActualStoreProductsCount() + 2
    }
    
    private func getActualStoreProductsCount() -> Int {
        
        if getTotalStoreProductsCount() > maxCount {
            return maxCount + 1
        } else {
            return getTotalStoreProductsCount()
        }
    }
}


