//
//  ManufacturersData.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 24/08/22.
//
import OlchaCore
import Foundation
struct ManufacturersData: Codable {
    var manufacturers: [Manufacturer]?
    var paginator: Paginator?
}
