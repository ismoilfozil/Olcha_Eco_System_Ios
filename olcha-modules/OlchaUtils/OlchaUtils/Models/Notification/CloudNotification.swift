import Foundation

public struct RemoteNotification: Codable {
    public let click_action: ClickActionModel
}

public struct ClickActionModel: Codable {
    public let click_action: String?
    public let click_action_id: String?
    public let click_action_alias: String?
}

public extension ClickActionModel {
    func getAction() -> ClickAction? {
        let action = click_action ?? ""
        let id = click_action_id?.int
        let alias = click_action_alias == nil ? click_action_id : click_action_alias
        
        if let action = NasiyaClickAction.fromRawValue(action, actionId: id) {
            return action
        } else if let action = InvestClickAction.fromRawValue(action, actionId: id) {
            return action
        } else if let action = MarketClickAction.fromRawValue(action, actionId: id, alias: alias) {
            return action
        } else if let action = PayClickAction.fromRawValue(action, actionId: id) {
            return action
        } else if let action = WebviewClickAction.fromRawValue(action, actionId: nil, alias: alias) {
            return action
        }
        
        return nil
    }
}
