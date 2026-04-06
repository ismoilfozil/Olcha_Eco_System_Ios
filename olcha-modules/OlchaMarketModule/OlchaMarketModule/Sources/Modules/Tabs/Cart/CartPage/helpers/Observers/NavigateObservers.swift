//
//  NavigateObservers.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 08/02/24.
//

import UIKit
import OlchaUI
import Combine
public final class CartNavigateObservers {
    let editAddress = PassthroughSubject<UserAddress, Never>()
    let shippingData = PassthroughSubject<Void, Never>()
    let getCost = PassthroughSubject<Void, Never>()
    let buyType = PassthroughSubject<Void, Never>()
    let paymentType = PassthroughSubject<Void, Never>()
    let coupon = PassthroughSubject<Void, Never>()
    let credit = PassthroughSubject<Void, Never>()
    let receiverData = PassthroughSubject<Void, Never>()
    let addAddress = PassthroughSubject<Void, Never>()
    let balanceFill = PassthroughSubject<Void, Never>()
    let verificationFinished = PassthroughSubject<Void, Never>()
    let offer = PassthroughSubject<Void, Never>()
    let locations = PassthroughSubject<Void, Never>()
    let productHelper = ProductHelper()
    let bonus = PassthroughSubject<Void, Never>()
    let comment = PassthroughSubject<Void, Never>()
    let presentProducts = PassthroughSubject<Void, Never>()
}

public final class CartActionObservers {
    let buyTypeSelected = PassthroughSubject<BuyType, Never>()
    let calculateFinished = PassthroughSubject<CreditOrder, Never>()
    let addressSelected = PassthroughSubject<Void, Never>()
    let paymentSelected = PassthroughSubject<Void, Never>()
    let shippingTypeSelected = PassthroughSubject<Void, Never>()
    let checkCoupon = PassthroughSubject<String, Never>()
    let cancelCoupon = PassthroughSubject<Void, Never>()
    let userDataUpdated = PassthroughSubject<Void, Never>()
    let balanceFilled = PassthroughSubject<Void, Never>()
    let tableReloader = PassthroughSubject<Void, Never>()
    let productsUpdated = PassthroughSubject<Void, Never>()
    let loadGetCost = PassthroughSubject<Void, Never>()
    let comment = PassthroughSubject<String, Never>()
    let bonus = PassthroughSubject<Void, Never>()
}

public final class CartSkeletonObservers {
    let products = Skeleton(count: 5)
    let locations = Skeleton(count: 1)
    let buyTypes = Skeleton(count: 2)
    var shippingTypes = Skeleton(count: 1)
}
