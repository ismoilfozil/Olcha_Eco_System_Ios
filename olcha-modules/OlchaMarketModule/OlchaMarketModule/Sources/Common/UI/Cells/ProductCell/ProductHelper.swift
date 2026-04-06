//
//  ProductHelper.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/11/22.
//

import Foundation
import Combine
class ProductHelper {
    let pushParentProduct = PassthroughSubject<ProductModel?, Never>()
    let pushProduct = PassthroughSubject<ProductModel?, Never>()
}
