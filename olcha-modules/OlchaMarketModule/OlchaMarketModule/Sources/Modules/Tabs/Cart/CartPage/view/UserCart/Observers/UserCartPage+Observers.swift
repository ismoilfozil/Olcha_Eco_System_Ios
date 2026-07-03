//
//  CartPage+Observers.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 19/01/24.
//

import Foundation
import OlchaVerification
extension UserCartPage {
    func setupStaticObserver() {
        
        placeholderButton { [weak self] in
            guard let self = self else { return }
            popToMainTab(mainTabIndex: OlchaTab.home)
        }
        
//        bottomOrderButton.settings.clicked { [weak self] in
//            guard let self = self else { return }
//            self.order()
//        }
        
        observers
            .navigation
            .productHelper
            .pushParentProduct
            .sink { [weak self] data in
                guard let self = self else { return }
                self.coordinator?.presentCartVariation(product: data, productType: .product)
            }.store(in: &bag)

        commentObservers()
    }
    
    func networkingObservers() {
        
        CartViewModel
            .shared
            .cartItemChanged
            .sink { [weak self] cartItem in
                guard let self = self else { return }
                let shouldPreserveInitialCreditOrder = self.initialCreditOrder != nil
//                self.alsoSeenProducts?.products?.changeCartCount(cartItem: cartItem) {
//                    DispatchQueue.main.async {
//                        self.observers.cart.productsUpdated.send(true)
//                    }
//                }
                observers.products.cartChanged(cartItem: cartItem)
                observers.action.buyTypeSelected.send(.none)
                observers.getCost = nil
                loadShippingTypes()
                cancelCoupon()
                bottomNavigationDatas()
                productsUpdated()
                applyInitialCreditOrderIfNeeded(consume: true)
                if !shouldPreserveInitialCreditOrder {
                    navigationController?.popToRootViewController(animated: true)
                }
            }.store(in: &bag)
        
        CartViewModel
            .shared
            .loadCartItems
            .sink { canLoad in
                guard canLoad else { return }

                CartViewModel.shared.loadCart()

            }.store(in: &bag)
        
        CartViewModel
            .shared
            .$cartItems
            .sink { [weak self] items in
                guard let self = self else { return }
                viewModels.checkout.loadCartProducts(cartItems: items)
            }.store(in: &bag)
        
        handle(viewModels.checkout.$cartProducts,
               success: { [weak self] data in
            guard let self else { return }
            observers.appendProducts(data ?? []) {
                self.loadShippingTypes()
                self.observers.action.productsUpdated.send()
            }
        },
               loading: { [weak self] isLoading in
            guard let self else { return }
            setProductsSkeletonAnimating(isLoading)
        })
        
        handle(viewModels.locations.$userAddressListData) { [weak self] data in
            guard let self else { return }
            observers.appendLocations(data?.data ?? [])
            observers.action.tableReloader.send()
        } loading: { [weak self] isLoading in
            guard let self else { return }
            setLocationsSkeletonAnimating(isLoading)
        }
        
        viewModels
            .checkout
            .$shippingTypes
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                self.observers.shippingTypes = data
                self.observers.shippingType = data.first
                self.datasUpdated()
            }.store(in: &bag)
        
        viewModels
            .checkout
            .$paymentTypes
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                self.observers.paymentTypes = data
                
                data?.paymentSystems?.forEach { self.viewModels.checkout.loadBalance(from: $0) }
                
                observers.action.tableReloader.send()
            }.store(in: &bag)

        viewModels
            .checkout
            .$externalProviders
            .dropFirst()
            .sink { [weak self] _ in
                guard let self else { return }
                if self.observers.credit?.externalInstalment != nil {
                    self.datasUpdated()
                } else {
                    self.observers.action.tableReloader.send()
                }
            }.store(in: &bag)
        
        viewModels
            .checkout
            .$paymentsBalance
            .sink { [weak self] isLoaded in
                guard let self = self, isLoaded else { return }
                observers.action.tableReloader.send()
            }.store(in: &bag)
        
        handle(viewModels.checkout.$coupon,
               success: { [weak self] data in
            guard let self else { return }
            showDefaultAlert(title: data?.isActiveTitle(),
                             content: data?.message)
            observers.coupon = data
            datasUpdated()
        }, failure: { [weak self] error in
            guard let self else { return }
            showDefaultAlert(title: error?.isActiveTitle(),
                             content: error?.message)
        })
        
        viewModels
            .checkout
            .$getCost
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                self.observers.getCost = data
                self.bottomNavigationDatas()
                self.observers.action.tableReloader.send()
            }.store(in: &bag)
        
        viewModels
            .checkout
            .$bonus
            .sink { [weak self] data in
                guard let self = self else { return }
                self.observers.bonus = data
                self.table.reloadData()
            }.store(in: &bag)
        
        viewModels
            .checkout
            .$orderFinished
            .sink { [weak self] data in
                guard let self = self,
                      let data = data else { return }
                self.orderFinished(data: data)
            }.store(in: &bag)
        
        viewModels
            .checkout
            .$orderError
            .sink { [weak self] message in
                guard let self, let message else { return }
                showError(text: message)
            }.store(in: &bag)
        
        viewModels
            .checkout
            .$orderLoading
            .dropFirst()
            .sink { [weak self] isLoading in
                guard let self = self else { return }
//                self.bottomOrderButton.settings.requesting = isLoading
            }.store(in: &bag)
        
        handle(viewModels.balance.$balance,
               withError: false,
               success: { [weak self] data in
            guard let self else { return }
            observers.limitBalance = data?.instalmentBalance
        })
        
    }
    
    func setupCartObservers() {
        observers
            .navigation
            .productHelper
            .pushProduct
            .sink { [weak self] data in
                guard let self = self else { return }
                self.coordinator?.pushProductPage(product: data)
            }.store(in: &bag)
        
        observers
            .navigation
            .presentProducts
            .sink { [weak self] in
                guard let self else { return }
                self.coordinator?.presentCartProducts(observers: observers)
            }.store(in: &bag)
        
        observers
            .navigation
            .buyType
            .sink { [weak self] in
                guard let self else { return }
                coordinator?.presentBuyTypeModalPage(observers: observers,
                                                     balanceViewModel: viewModels.balance,
                                                     checkoutViewModel: viewModels.checkout)
            }.store(in: &bag)
        
        observers
            .navigation
            .paymentType
            .sink { [weak self] in
                guard let self else { return }
                coordinator?.presentPaymentsModalPage(observers: observers,
                                                      checkoutViewModel: viewModels.checkout)
            }.store(in: &bag)
        
        observers
            .navigation
            .comment
            .sink { [weak self] in
                guard let self else { return }
                showEnterComment()
            }.store(in: &bag)
        
        observers
            .action
            .comment
            .sink { [weak self] data in
                guard let self = self else { return }
                self.observers.comment = data
            }.store(in: &bag)
        
        observers
            .action
            .productsUpdated
            .sink { [weak self] in
                guard let self else { return }
                
                self.productsUpdated()
                
                self.datasUpdated()
                
                if self.type == .credit,
                   self.initialLoading,
                   CartViewModel.shared.cartCount > 1 {
                    self.initialLoading = false
                    self.presentCreditModalPage()
                }
                
                self.applyInitialCreditOrderIfNeeded(consume: true)
                
            }.store(in: &bag)
        
        observers
            .action
            .addressSelected
            .sink { [weak self] in
                guard let self else { return }
                
                self.observers.reorderLocations()
                
                self.observers.selectedPayment = nil
                self.observers.paymentTypes = nil
                self.checkPaymentType()
                
                self.loadShippingTypes()
                self.loadPaymentTypes()
                self.observers.action.tableReloader.send()
            }.store(in: &bag)
        
        observers
            .action
            .bonus
            .sink { [weak self] in
                guard let self else { return }
                observers.action.tableReloader.send()
                observers.action.loadGetCost.send()
            }.store(in: &bag)
        
        observers
            .action
            .shippingTypeSelected
            .sink { [weak self] in
                guard let self = self else { return }
                self.datasUpdated()
            }.store(in: &bag)
        
        observers
            .action
            .paymentSelected
            .sink { [weak self] in
                guard let self else { return }
                self.datasUpdated()
            }.store(in: &bag)
        
        observers
            .action
            .buyTypeSelected
            .sink { [weak self] type in
                guard let self = self else { return }
                
                self.observers.selectedBuyType = type
                if type == .credit {
                    self.checkPaymentType()
                } else {
                    self.observers.credit = nil
                }
                self.datasUpdated()
                
            }.store(in: &bag)
        
        observers
            .navigation
            .credit
            .sink { [weak self] in
                guard let self else { return }
                self.presentCreditModalPage()
            }.store(in: &bag)
        
        observers
            .navigation
            .receiverData
            .sink { [weak self] in
                guard let self else { return }
                presentReceiverModalPage()
            }.store(in: &bag)
        
        observers
            .navigation
            .shippingData
            .sink { [weak self] in
                guard let self else { return }
                coordinator?.presentShippingModalPage(text: observers.shippingType?.getDeliveredTime())
            }.store(in: &bag)
        
        observers
            .navigation
            .coupon
            .sink { [weak self] in
                guard let self else { return }
                coordinator?.presentCouponModalPage(observers: observers, checkoutViewModel: viewModels.checkout)
            }.store(in: &bag)
        
        observers
            .navigation
            .getCost
            .sink { [weak self] in
                guard let self else { return }
                coordinator?.presentGetCostModalPage(observers: observers)
            }.store(in: &bag)
        
        observers
            .action
            .tableReloader
            .sink { [weak self] in
                guard let self else { return }
                
                self.table.reloadData()
                
            }.store(in: &bag)
        
        observers
            .navigation
            .addAddress
            .sink { [weak self] in
                guard let self else { return }
                self.coordinator?.pushAddLocationMap(observers: observers)
            }.store(in: &bag)
        
        observers
            .navigation
            .editAddress
            .sink { [weak self] data in
                guard let self = self else { return }
                self.coordinator?.pushAddLocationMap(address: data,
                                                     observers: self.observers)
            }.store(in: &bag)
        
        observers
            .action
            .loadGetCost
            .sink { [weak self] in
                guard let self else { return }
                self.getCost()
            }.store(in: &bag)
        
        observers
            .action
            .checkCoupon
            .sink { [weak self] couponString in
                guard let self else { return }
                self.checkCoupon(couponString)
            }.store(in: &bag)
        
        observers
            .action
            .calculateFinished
            .sink { [weak self] data in
                guard let self = self else { return }
                self.observers.credit = data
                self.observers.action.buyTypeSelected.send(.credit)
            }.store(in: &bag)
        
        observers
            .action
            .cancelCoupon
            .sink { [weak self] in
                guard let self else { return }
                cancelCoupon()
            }.store(in: &bag)
        
        observers
            .navigation
            .balanceFill
            .sink { [weak self] in
                guard let self else { return }
                self.coordinator?.pushFillBalance(observers: self.observers)
            }.store(in: &bag)
        
        observers
            .action
            .balanceFilled
            .sink { [weak self] in
                guard let self else { return }
                self.updateBalance()
            }.store(in: &bag)
        
        observers
            .navigation
            .offer
            .sink { [weak self] in
                guard let self else { return }
                self.openOffer()
            }.store(in: &bag)
        
        observers
            .navigation
            .locations
            .sink { [weak self] in
                guard let self else { return }
                coordinator?.presentLocationsModalPage(locationsViewModel: viewModels.locations,
                                                       observers: observers)
            }.store(in: &bag)
        
        observers
            .navigation
            .bonus
            .sink { [weak self] in
                guard let self else { return }
                coordinator?.presentBonusModalPage(observers: observers) {
                    
                }
            }.store(in: &bag)
    }
    
    func setupVerificationObservers() {
        viewModels.verification.$step
            .sink { [weak self] step in
                guard let self else { return }
                input.verification = step.value
            }.store(in: &bag)
    }

    func applyInitialCreditOrderIfNeeded(consume: Bool) {
        guard let initialCreditOrder else { return }
        observers.selectedBuyType = .credit
        observers.credit = initialCreditOrder
        if consume {
            self.initialCreditOrder = nil
        }
        observers.action.tableReloader.send()
        observers.action.loadGetCost.send()
    }
    
    func startVerificationByCurrentStep() {
        if let verificationData = input.verification {
            let currentStep = verificationData.getStep()
            let verificationStep: VerificationStatusStep
            
            switch currentStep {
            case 0, 1:
                verificationStep = .identification
            case 2:
                verificationStep = .phones
            case 3:
                verificationStep = .bankCard
            default:
                verificationStep = .identification
            }
            
            coordinator?.startVerificationByCurrentStep(step: verificationStep)
        } else {
            coordinator?.startVerificationByCurrentStep(step: nil)
        }
    }
}
