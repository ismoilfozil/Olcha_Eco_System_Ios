//
//  ServiceModel.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 28/03/23.
//

import Foundation
public struct ServiceModel: Codable {
    var id: Int?
    var min_amount: Double?
    var max_amount: Double?
    var title_ru: String?
    var title_uz: String?
    var agent_commission: Double?
    var active: Int?
    var services_field: [ServiceFieldModel]?
    
    public func getTitle() -> String {
        .lang(title_ru, title_uz, title_uz)
    }
    
    public func isDisabled() -> Bool {
        (services_field?.isEmpty ?? true)
    }
    
    public func getValue(id: Int?,
                         parentID: Int?,
                         selectedID: String?,
                         parentSelectedValue: String?
    ) -> [ServiceFieldValue] {
        if let parentID {
            if let parentSelectedValue {
                return services_field?.first { $0.parent_field == parentID }?.service_field_value?[parentSelectedValue] ?? []
            } else {
                return []
            }
        } else {
            guard let id else { return [] }
            let values: [ServiceFieldValue] = services_field?.first { $0.id == id }?.service_field_value?.compactMap { $0.value.first } ?? []
            return values
        }
    }
}

public struct ServiceFieldModel: Codable {
    var id: Int?
    var title_ru: String?
    var title_uz: String?
    var type: String?
    var name: String?
    var service_field_value: [String: [ServiceFieldValue]]?
    var field_control: String?
    var parent_field: Int?
    var type_example: String?
    
    public func getType() -> ServiceFieldType {
        guard let type = type,
              let serviceType = ServiceFieldType(rawValue: type)
        else { return .none }
        return serviceType
    }
    
    public func getTitle() -> String {
        return .lang(title_ru, title_uz, title_uz)
    }
    
    public func getPlaceholder() -> String {
        return type_example ?? ""
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.title_ru = try container.decodeIfPresent(String.self, forKey: .title_ru)
        self.title_uz = try container.decodeIfPresent(String.self, forKey: .title_uz)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        
        do {
            self.service_field_value = try container.decode([String: [ServiceFieldValue]].self, forKey: .service_field_value)
        } catch {
        }
        do {
            self.parent_field = try container.decodeIfPresent(Int.self, forKey: .parent_field)
        } catch {}
        
        do {
            self.field_control = try container.decodeIfPresent(String.self, forKey: .field_control)
        } catch {
            self.field_control = nil
        }
        do {
            type_example = try container.decode(String.self, forKey: .type_example)
        } catch {}
    }
    
}

public struct ServiceFieldValue: Codable {
    var id: Int?
    var title_uz: String?
    var title_ru: String?
}

public enum ServiceFieldType: String {
    case phone = "PHONE"
    case money = "MONEY"
    case number = "NUMBER"
    case purchased = "PURCHASED"
    case preamount = "PREAMOUNT"
    case regexbox = "REGEXBOX"
    case combobox = "COMBOBOX"
    case none
}
