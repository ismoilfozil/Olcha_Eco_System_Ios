//
//  BannerModel.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 25/07/23.
//

import Foundation
import OlchaUtils
public struct BannerData: Codable {
    public var banners: [BannerModel]?
}

public struct BannerModel: Codable {
    public var image_url: String?
    public var deeplink: String?
    public var click_action: String?
    public var click_action_id: String?
    public var id: Int?
    
    
    public func getAction() -> ClickAction? {
        let action = click_action ?? ""
        let id = click_action_id?.int
        
        if let action = NasiyaClickAction.fromRawValue(action, actionId: id) {
            return action
        } else if let action = InvestClickAction.fromRawValue(action, actionId: id) {
            return action
        } else if let action = MarketClickAction.fromRawValue(action, actionId: id) {
            return action
        } else if let action = PayClickAction.fromRawValue(action, actionId: id) {
            return action
        } else if let action = WebviewClickAction.fromRawValue(action, actionId: nil, alias: deeplink) {
            return action
        }
        
        return nil
    }
}
