//
//  CartPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 13/09/22.
//

import OlchaUI
import OlchaUtils
import UIKit
import OlchaAuth
extension UserCartPage: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section {
            
        case .bonus:
            return observers.bonus == nil ? 0 : 2
        case .emptyBonus:
            return observers.bonus == nil ? 2 : 0
        default:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        
        if isSeparator(indexPath) {
            return getFooterRoom(tableView, indexPath)
        }
        
        switch section {
        case .products:
            let cell = tableView.dequeue(CartProductsGroupRoom.self, for: indexPath)
            cell.presentProducts = observers.navigation.presentProducts
            cell.skeleton = observers.skeleton.products
            cell.setup(products: observers.products)
            cell.openButton.clicked { [weak self] in
                guard let self else { return }
                coordinator?.presentCartProducts(observers: observers)
            }

            return cell
        case .profile:
            let cell = tableView.dequeue(CartItemRoom.self, for: indexPath)
            cell.makeRoundStyle(section.roundStyle, 14)
            cell.setup(section: section,
                       showState: false,
                       value: getUserData())
            return cell
        case .locations:
            let cell = tableView.dequeue(CartItemRoom.self, for: indexPath)
            cell.makeRoundStyle(section.roundStyle, 14)
            cell.setup(section: section, 
                       showState: observers.errorlyChecked,
                       value: observers.selectedAddress?.getFullAddress())
            return cell
        case .orderType:
            let cell = tableView.dequeue(CartItemRoom.self, for: indexPath)
            cell.makeRoundStyle(section.roundStyle, 14)
            let display = getOrderTypeDisplay()
            cell.setup(section: section,
                       showState: observers.errorlyChecked || display.inlineImageSuffix != nil,
                       subtitle: display.subtitle,
                       value: display.value,
                       valueImageURL: display.logoURL,
                       valueImage: display.logoImage,
                       inlineImageSuffix: display.inlineImageSuffix)
            return cell
        case .paymentType:
            let cell = tableView.dequeue(CartItemRoom.self, for: indexPath)
            cell.makeRoundStyle(section.roundStyle, 14)
            cell.setup(section: section,
                       showState: observers.errorlyChecked,
                       value: observers.selectedPayment?.getName(),
                       valueImageURL: observers.selectedPayment?.logo)
            return cell
        case .comment:
            let cell = tableView.dequeue(CartItemRoom.self, for: indexPath)
            cell.makeRoundStyle(section.roundStyle, 14)
            cell.setup(section: section,
                       value: observers.comment)
            return cell
        case .promocode:
            let cell = tableView.dequeue(CartItemRoom.self, for: indexPath)
            cell.makeRoundStyle(section.roundStyle, 14)
            cell.setup(section: section, value: observers.coupon?.code)
            
            let isCouponNotActive = observers.coupon?.couponNotActive() ?? true
            
            cell.setup(section: section,
                       rightImageType: isCouponNotActive ? .anchor : .cancel,
                       value: observers.coupon?.code)
            
            cell.cancelButton.clicked { [weak self] in
                guard let self else { return }
                cancelCoupon()
                datasUpdated()
            }
            
            return cell
        case .bonus:
            let cell = tableView.dequeue(CartItemRoom.self, for: indexPath)
            cell.makeRoundStyle(section.roundStyle, 14)
            cell.isChosen = observers.isBonusUsing
            cell.radioButton.clicked { [weak self] in
                guard let self else { return }
//                observers.isBonusUsing = !observers.isBonusUsing
//                datasUpdated()
                if !observers.isBonusUsing {
                    observers.navigation.bonus.send()
                } else {
                    observers.isBonusUsing = false
                    observers.action.bonus.send()
                }

            }
            cell.setup(section: section,
                       rightImageType: .radio,
                       subtitle: "max_bonus".localized() + " " + (observers.bonus?.bonus?.originalPriceDouble ?? "0")
            )
            return cell
        case .emptyBonus:
            let cell = tableView.dequeue(CartItemRoom.self, for: indexPath)
            cell.makeRoundStyle(section.roundStyle, 14)
            cell.setup(section: section,
                       rightImageType: .empty)
            
            cell.infoButton.clicked { [weak self] in
                guard let self else { return }
                coordinator?.presentEmptyBonusModalPage()
            }
            
            return cell
        case .getCost:
            let cell = tableView.dequeue(CartCostRoom.self, for: indexPath)
            cell.makeRoundStyle(section.roundStyle, 14)
            cell.responder.setup(observers: observers,
                                 costType: .short)
            return cell
        case .action:
            let cell = tableView.dequeue(CartActionsRoom.self, for: indexPath)
            cell.makeRoundStyle(section.roundStyle, 14)
            cell.pushOffer = observers.navigation.offer
            cell.buttonState = checkButtonState(isGetCost: false)
            
            cell.acceptButton.clicked { [weak self] in
                guard let self else { return }
                if AuthGlobalDefaults.isUser(), !OlchaGlobalDefaults.isCreditVerified() {
                    self.showNasiyaAlertView(message: "installment_identification".localized(), type: .reject) { [weak self] in
                        guard let self else { return }
                        self.startVerificationByCurrentStep()
                    }
                    return
                }
                self.order()
            } disableListener: { [weak self] in
                guard let self else { return }
                observers.errorlyChecked = true
                table.reloadData()
            }

            viewModels
                .checkout
                .$orderLoading
                .dropFirst()
                .sink { isLoading in
                    cell.acceptButton.settings.requesting = isLoading
                }.store(in: &bag)
            
            cell.setup()
            return cell
            }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch sections[indexPath.section] {
        case .profile:
            observers.navigation.receiverData.send()
        case .products:
            break
        case .locations:
            observers.navigation.locations.send()
        case .orderType:
            observers.navigation.buyType.send()
        case .paymentType:
            observers.navigation.paymentType.send()
        case .promocode:
            observers.navigation.coupon.send()
        case .bonus:
            observers.navigation.bonus.send()
        case .comment:
            observers.navigation.comment.send()
        default: break
        }
    }
}


//MARK: - Cart Page Table Helpers
extension UserCartPage {
    private func selectAllProducts() {

        let allFalseValue = observers.products.allSatisfy { $0.cartSelected == false }
        let allTrueValue = observers.products.allSatisfy { $0.cartSelected == true }
        
        if allTrueValue {
            observers.products.forEach { $0.cartSelected = false }
        } else if allFalseValue {
            observers.products.forEach { $0.cartSelected = true }
        } else {
            observers.products.forEach { $0.cartSelected = true }
        }
            
        table.reloadData()
    }
    
    private func removeSelectedProducts() {
        var items: [CartItem] = []
        let selectedProducts = observers.products.filter { $0.cartSelected == true }
        
        observers.products.removeAll(where: { $0.cartSelected == true })
        for product in selectedProducts {
            MetricEvents.shared.cartEvent(product, type: .minus)
            items.append(.init(product_id: product.id,
                               store_id: product.getStoreID(),
                               quantity: 0))
        }
        
        
        
        CartViewModel.shared.deleteCart(items: items)
        table.reloadData()
    }
    
    private func changeState(index: Int) {
        let product = observers.products[index]
        product.cartSelected = !(product.cartSelected ?? false)
        table.reloadData()
    }
    
    private func remove(product: ProductModel?) {
        MetricEvents.shared.cartEvent(product, type: .minus)
        CartViewModel.shared.deleteCart(items: [.init(product_id: product?.id,
                                                      store_id: product?.getStoreID(),
                                                      quantity: 0)])
        
        observers.products.removeAll(where: { $0.id == product?.id && $0.store_id == product?.getStoreID() })
        table.reloadData()
    }
    
    private func isSeparator(_ indexPath: IndexPath) -> Bool {
        switch sections[indexPath.section] {
        default: return indexPath.row == 1
        }
    }
    
    fileprivate func getFooterRoom(_ tableView: UITableView, _ indexPath: IndexPath) -> BaseTableCell {
        let section = sections[indexPath.section]
        let cell = tableView.dequeue(FooterItem.self, for: indexPath)
        
        switch section.separatorStyle {
        case .blockSeparator:
            cell.responder.height = 4
            cell.responder.backgroundColor = CartStyle.backgroundColor
            cell.responder.withSeparator = false
            break
        case .separator:
            cell.responder.height = 1
            cell.responder.withEdge = true
            cell.responder.backgroundColor = CartStyle.whiteColor
            cell.responder.withSeparator = true
            break
        case .empty:
            cell.responder.height = 0
            cell.responder.backgroundColor = .olchaWhite
            cell.responder.withSeparator = false
            break
        }
        
        return cell
    }
    
    private func paymentsTypeCount() -> Int {
        if observers.selectedBuyType == .credit, observers.credit?.creditDatas[observers.credit?.creditType ?? .olcha]?.first_fee_sum == 0 {
            return 0
        } else {
            return (!(observers.paymentTypes?.payments?.isEmpty ?? true) || !(observers.paymentTypes?.paymentSystems?.isEmpty ?? true)) ? 2 : 0
        }
    }
    
    private func getOrderTypeDisplay() -> (value: String?, logoURL: String?, logoImage: UIImage?, subtitle: String?, inlineImageSuffix: String?) {
        guard let buyType = observers.selectedBuyType, buyType != .none else {
            return (nil, nil, nil, nil, nil)
        }
        if let ext = observers.credit?.externalInstalment {
            let provider = viewModels.checkout.externalProviders.first { $0.checkoutAlias == ext.alias }
            return (buyType.title, provider?.logoUrl, nil, nil, "\(ext.period) oy")
        }
        if buyType == .credit,
           let instPayTime = observers.credit?.creditDatas[observers.credit?.creditType ?? .olcha]?.inst_pay_time,
           instPayTime > 0 {
            return (buyType.title, nil, .olcha_logo, nil, "\(instPayTime) oy")
        }
        return (buyType.title, nil, nil, nil, nil)
    }

    func checkRegionForPayment() {
        guard let selectedAddress = observers.selectedAddress else { return }
        if MarketTexts.TASHKENT_ID == selectedAddress.region?.id {
            observers.selectedPayment = Payments.getCashPayment()
        } else {
            observers.selectedPayment = Payments.getFargoPayment()
        }
    }
    
    func clearCart() {
        observers.products.removeAll()
        
//        CartViewModel.shared.loadCart()
        productsUpdated()
    }
    
    func getUserData() -> String {
        let name = (observers.name ?? AuthGlobalDefaults.user.name) ?? ""
        let phone = ((observers.phone ?? AuthGlobalDefaults.user.phone) ?? "").formatFullPhoneNumber
        
        var fullName = ""
        if name != "" && phone != "" {
            fullName = (name) + " / " + (phone)
        } else {
            fullName = (name) + (phone)
        }
        
        
        
        return fullName
    }
}
