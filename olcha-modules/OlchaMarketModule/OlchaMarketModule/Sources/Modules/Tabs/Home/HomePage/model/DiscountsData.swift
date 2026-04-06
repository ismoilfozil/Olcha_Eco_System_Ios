//
//  DiscountsData.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 05/07/22.
//
import OlchaCore
import Foundation
struct DiscountsData : Codable {
    var discounts: [Discount]?
    var paginator: Paginator?
}
