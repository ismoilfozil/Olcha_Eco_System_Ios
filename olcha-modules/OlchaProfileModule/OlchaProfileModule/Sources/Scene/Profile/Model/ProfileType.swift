//
//  ProfileType.swift
//  OlchaProfileModule
//
//  Created by Elbek Khasanov on 20/09/23.
//

import Foundation

public enum ProfileType {
    case orders
    case favourites
    case reviews
    case compare
    case faq
    case bank_cards
    case verification
    case notifications
    case locations
    case pincode
    case settings
    case about_app
    case help
}

public struct ProfileSection {
    var title: String?
    var items: [ProfileType]?
}
