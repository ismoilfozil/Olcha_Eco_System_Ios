
import Foundation


public struct PaymentTypeModel : Codable {
    var data: PaymentTypeData?
    var status: String?
    var message: String?
}
public struct PaymentTypeData : Codable {
    public var payments: [Payments]?
    public var paymentSystems: [Payments]?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.payments = try container.decodeIfPresent([Payments].self, forKey: .payments)
        } catch {}
        do {
            self.paymentSystems = try container.decodeIfPresent([Payments].self, forKey: .paymentSystems)
        } catch {}
    }
    
    public init() {
        
    }
}

public class Payments : Codable, Equatable {
    public static func == (lhs: Payments, rhs: Payments) -> Bool {
        lhs.alias == rhs.alias
    }
    
    public init(alias: String?, staticImage: String?, name: String?) {
        self.alias = alias
        self.staticImage = staticImage
        self.name = name
    }
    
    public init() {
        
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        } catch {}
        do {
            self.alias = try container.decodeIfPresent(String.self, forKey: .alias)
        } catch {}
        do {
            self.balance_alias = try container.decodeIfPresent(String.self, forKey: .balance_alias)
        } catch {}
        do {
            self.name_ru = try container.decodeIfPresent(String.self, forKey: .name_ru)
        } catch {}
        do {
            self.name_uz = try container.decodeIfPresent(String.self, forKey: .name_uz)
        } catch {}
        do {
            self.name_oz = try container.decodeIfPresent(String.self, forKey: .name_oz)
        } catch {}
        do {
            self.description_ru = try container.decodeIfPresent(String.self, forKey: .description_ru)
        } catch {}
        do {
            self.description_uz = try container.decodeIfPresent(String.self, forKey: .description_uz)
        } catch {}
        do {
            self.description_oz = try container.decodeIfPresent(String.self, forKey: .description_oz)
        } catch {}
        do {
            self.logo = try container.decodeIfPresent(String.self, forKey: .logo)
        } catch {}
        do {
            self.staticImage = try container.decodeIfPresent(String.self, forKey: .staticImage)
        } catch {}
        do {
            self.additional_cost_type = try container.decodeIfPresent(String.self, forKey: .additional_cost_type)
        } catch {}
        do {
            self.additional_cost = try container.decodeIfPresent(Double.self, forKey: .additional_cost)
        } catch {}
        do {
            self.name = try container.decodeIfPresent(String.self, forKey: .name)
        } catch {}
        do {
            self.balance = try container.decodeIfPresent(Balance.self, forKey: .balance)
        } catch {}
        do {
            self.description = try container.decodeIfPresent(String.self, forKey: .description)
        } catch {}
        do {
            self.min_amount = try container.decodeIfPresent(Int.self, forKey: .min_amount)
        } catch {}
        do {
            self.max_amount = try container.decodeIfPresent(Int.self, forKey: .max_amount)
        } catch {}
    }
    
    public var id: Int?
    public var alias: String?
    public var balance_alias: String?
    public var name_ru: String?
    public var name_uz: String?
    public var name_oz: String?
    public var description_ru: String?
    public var description_uz: String?
    public var description_oz: String?
    public var logo: String?
    public var staticImage: String?
    public var additional_cost_type: String?
    public var additional_cost: Double?
    public var name: String?
    public var balance: Balance?
    public var min_amount: Int?
    public var max_amount: Int?
    public var description: String?
    
    public func getName() -> String {
        if let name = name {
            return name
        } else {
            return .lang(name_ru,
                         name_uz,
                         name_oz)
        }
    }
    
    public func getDescription() -> String {
        if let description = description {
            return description
        } else {
            return .lang(description_ru,
                         description_uz,
                         description_oz)
        }
    }
    
    public func getSubtitle() -> String {
        if let balance_alias, balance_alias != "" {
            return balance?.getAmount().originalPriceDouble ?? "0".originalPriceDouble
        } else {
            return getDescription()
        }
    }
    
    public func withAlias() -> Bool {
        (balance_alias ?? "") != ""
    }
    
    public static func getAnorbankPayment() -> Payments {
        Payments(alias: Texts.anorbank_alias,
                 staticImage: Texts.anorbank,
                 name: Texts.anorbank)
    }
    
    public static func getCashPayment() -> Payments {
        Payments(alias: Texts.cash_alias,
                 staticImage: "",
                 name: Texts.cash)
    }
    
    public static func getFargoPayment() -> Payments {
        Payments(alias: Texts.fargo_alias,
                 staticImage: "",
                 name: "Fargo")
    }
    
}

public struct PaymentSystems : Codable {
    var id: Int?
    var name: String?
    var min_amount: Int?
    var max_amount: Int?
    var logo: String?
    var alias: String?
}
