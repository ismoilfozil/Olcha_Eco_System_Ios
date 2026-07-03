//
//  ProductPageFactory.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 01/11/23.
//

import UIKit
class ProductPageFactory {
    init() {}
    let actionsRoom = ProductActionsRoomView()
    let brandRoom = ProductBrandRoomView()
    let cashAdRoom = CashAdRoomView()
    let characteristicsRoom = CharacteristicsRoomView()
    let descriptionSegmentsRoom = DescriptionSegmentsRoomView()
    let descriptionsRoom = DescriptionsRoomView()
    let giftProductRoom = ProductsGiftRoomView()
//    let giftRoom = ProductsGiftRoomView()
    let storeProductsRoom = StoreProductsRoomView()
    let priceHistoryRoom = PriceHistoryRoomView()
    let picturesRoom = ProductPicturesRoomView()
    let dataRoom = ProductsDataRoomView()
    let reviewButtonsRoom = ReviewButtonsRoomView()
    let reviewsHeaderRoom = ProductReviewsHeaderRoomView()
    let reviewsRoom = ProductReviewsRoomView()
    let analogProductsRoomHeader = ComponentHeaderView()
    let analogProductsRoom = HorizontalPromotedRoomView()
    let faqsHeaderRoom = ProductFAQsHeaderRoomView()
    let faqsRoom = ProductFAQsRoomView()
    let similarProductsRoomHeader = ComponentHeaderView()
    let similarProductsRoom = HorizontalPromotedRoomView()
    let seenAlsoProductsRoomHeader = ComponentHeaderView()
    let seenAlsoProductsRoom = HorizontalPromotedRoomView()
    let shippingDataRoom = ShippingDataRoomView()
    let showVideoRoom = ShowVideoRoomView()
    let storeGiftRoom = StoreGiftRoomView()
    let variationsRoom = VariationsRoomView()
    let warrantyRoom = WarrantyRoomView()
    let installmentRoom = InlineInstallmentRoomView()
    let trustInfoRoom = TrustInfoRoomView()

    func stateSection(section: ProductPage.Sections, isHidden: Bool) {
        switch section {
        case .images:
            picturesRoom.isHidden = isHidden
        case .reviewButtons:
            reviewButtonsRoom.isHidden = isHidden
        case .video:
            showVideoRoom.isHidden = isHidden
        case .cashAd:
            cashAdRoom.isHidden = isHidden
        case .variations:
            variationsRoom.isHidden = isHidden
        case .gift:
            giftProductRoom.isHidden = isHidden
        case .buyActions:
            actionsRoom.isHidden = isHidden
        case .shippingData:
            shippingDataRoom.isHidden = isHidden
        case .storeProducts:
            storeProductsRoom.isHidden = isHidden
        case .description:
            descriptionSegmentsRoom.isHidden = isHidden
            descriptionsRoom.isHidden = isHidden
            characteristicsRoom.isHidden = isHidden
        case .warranty:
            warrantyRoom.isHidden = isHidden
        case .priceHistory:
            priceHistoryRoom.isHidden = isHidden
        case .brand:
            brandRoom.isHidden = isHidden
        case .analogProducts:
            analogProductsRoomHeader.isHidden = isHidden
            analogProductsRoom.isHidden = isHidden
        case .reviews:
            reviewsHeaderRoom.isHidden = isHidden
            reviewsRoom.isHidden = isHidden
        case .faqs:
            faqsHeaderRoom.isHidden = isHidden
            faqsRoom.isHidden = isHidden
        case .seenAlsoProducts:
            seenAlsoProductsRoomHeader.isHidden = isHidden
            seenAlsoProductsRoom.isHidden = isHidden
        case .similarProducts:
            similarProductsRoomHeader.isHidden = isHidden
            similarProductsRoom.isHidden = isHidden
        case .productsData:
            dataRoom.isHidden = isHidden
        case .installment:
            installmentRoom.isHidden = isHidden
        case .trustInfo:
            trustInfoRoom.isHidden = isHidden
        default: break
        }
    }
}
