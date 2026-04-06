//
//  InstallmentsData.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 11/05/23.
//

import OlchaCore
import UIKit
import OlchaUtils
public class InstallmentsData: Codable {
    
    public var paginator: Paginator?
    public var orders: [InstallmentModel]?
    public var statuses: [String: String]?
    public var allStatuses: [InstallmentStatus] = []
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            paginator = try container.decodeIfPresent(Paginator.self, forKey: .paginator)
        } catch {}
        
        do {
            orders = try container.decodeIfPresent([InstallmentModel].self, forKey: .orders)
        } catch {}
        
        do {
            statuses = try container.decodeIfPresent([String: String].self, forKey: .statuses)
        } catch {}
        
        generateStatuses()
    }
    
    public init(paginator: Paginator? = nil, orders: [InstallmentModel]? = nil, statuses: [String : String]? = nil, allStatuses: [InstallmentStatus] = []) {
        self.paginator = paginator
        self.orders = orders
        self.statuses = statuses
        self.allStatuses = allStatuses
    }
    
    
    public static func mock(page: Int = 1, lastPage: Int = 3) -> InstallmentsData {
        
        var paginator = Paginator()
        paginator.current_page = page
        paginator.last_page = lastPage
        return InstallmentsData(
            paginator: paginator,
            orders: [
            .mock(id: 1),
            .mock(id: 2),
            .mock(id: 3),
            .mock(id: 4),
            .mock(id: 5),
            .mock(id: 6),
            .mock(id: 7),
            .mock(id: 8),
            .mock(id: 9),
            .mock(id: 10),
            .mock(id: 11),
            .mock(id: 12),
            ])
    }
    
    public func generateStatuses() {
        allStatuses = [.all]
        guard let statuses = statuses else { return }
        allStatuses.append(contentsOf: statuses
            .map { InstallmentStatus(key: $0.key, title: $0.value) }
            .sorted(by: { ($0.key ?? "") < ($1.key ?? "") } )
        )
    }
}

public struct ParentInstallmentData: Codable {
    public var data: InstallmentData?
}

public struct InstallmentData: Codable {
    public var orders: InstallmentModel?
    public static func mock(id: Int? = nil) -> InstallmentData {
        InstallmentData(orders: .mock(id: id))
    }
}

public class InstallmentModel: Codable {
    
    public var id: Int?
    public var status: String?
    public var status_name: String?
    public var status_color: String?
    public var created_at: String?
    public var next_payment: String?
    public var name: String?
    public var total_cost: Int?
    public var first_fee: Int?
    public var full_address: String?
    public var phone: String?
    public var store: String?
    public var total_payment_all: Double?
    public var total_price_all: Double?
//    public var paid_amount: Int?
    public var total_my_payments_all: Double?
    public var graphs: [InstallmentGraphMonthModel]?
    public var details: [InstallmentGraphDetailModel]?
    public var currency: String?
    public var billing_reflection_alias: Reflection?
    public var installment_month: Int?
    public var current_payment: Double?
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        } catch {}
        do {
            self.status = try container.decodeIfPresent(String.self, forKey: .status)
        } catch {}
        do {
            self.status_name = try container.decodeIfPresent(String.self, forKey: .status_name)
        } catch {}
        do {
            self.status_color = try container.decodeIfPresent(String.self, forKey: .status_color)
        } catch {}
        do {
            self.created_at = try container.decodeIfPresent(String.self, forKey: .created_at)
        } catch {}
//        do {
//            self.paid_amount = try container.decodeIfPresent(Int.self, forKey: .paid_amount)
//        } catch {}
        do {
            self.name = try container.decodeIfPresent(String.self, forKey: .name)
        } catch {}
        do {
            self.total_cost = try container.decodeIfPresent(Int.self, forKey: .total_cost)
        } catch {}
        do {
            self.first_fee = try container.decodeIfPresent(Int.self, forKey: .first_fee)
        } catch {}
        do {
            self.full_address = try container.decodeIfPresent(String.self, forKey: .full_address)
        } catch {}
        do {
            self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        } catch {}
        do {
            self.store = try container.decodeIfPresent(String.self, forKey: .store)
        } catch {}
        do {
            self.graphs = try container.decodeIfPresent([InstallmentGraphMonthModel].self, forKey: .graphs)
        } catch {}
        do {
            self.details = try container.decodeIfPresent([InstallmentGraphDetailModel].self, forKey: .details)
        } catch {}
        do {
            total_payment_all = try container.decodeIfPresent(Double.self, forKey: .total_payment_all)
        } catch {}
        do {
            total_price_all = try container.decodeIfPresent(Double.self, forKey: .total_price_all)
        } catch {}
        do {
            total_my_payments_all = try container.decodeIfPresent(Double.self, forKey: .total_my_payments_all)
        } catch {}
        do {
            currency = try container.decodeIfPresent(String.self, forKey: .currency)
        } catch {}
        do {
            billing_reflection_alias = try container.decodeIfPresent(Reflection.self, forKey: .billing_reflection_alias)
        } catch {}
        do {
            installment_month = try container.decodeIfPresent(Int.self, forKey: .installment_month)
        } catch {}
        do {
            next_payment = try container.decodeIfPresent(String.self, forKey: .next_payment)
        } catch {}
        do {
            current_payment = try container.decodeIfPresent(Double.self, forKey: .current_payment)
        } catch {
            let newValue = try container.decodeIfPresent(String.self, forKey: .current_payment)
            current_payment = newValue?.double ?? 0
        }
    }
    
    public init(id: Int? = nil,
                status: String? = nil,
                status_name: String? = nil,
                status_color: String? = nil,
                created_at: String? = nil,
                name: String? = nil,
                total_cost: Int? = nil,
                first_fee: Int? = nil,
                full_address: String? = nil,
                phone: String? = nil,
                store: String? = nil,
                graphs: [InstallmentGraphMonthModel]? = nil,
                details: [InstallmentGraphDetailModel]? = nil,
                currency: String? = nil,
                billing_reflection_alias: Reflection? = nil,
                installment_month: Int? = nil
    ) {
        self.id = id
        self.status = status
        self.status_name = status_name
        self.status_color = status_color
        self.created_at = created_at
        self.name = name
        self.total_cost = total_cost
        self.first_fee = first_fee
        self.full_address = full_address
        self.phone = phone
        self.store = store
        self.graphs = graphs
        self.details = details
        self.currency = currency
        self.billing_reflection_alias = billing_reflection_alias
        self.installment_month = installment_month
    }
    
    public func getStatus() -> InstallmentModel.Status {
        if let status {
            return InstallmentModel.Status(rawValue: status) ?? .none
        }
        return .none
    }
    
    public func getStatusColor() -> UIColor {
        guard let status_color else { return .lightGray }
        return .hex(status_color)
    }
    
    public func getDetails() -> [InstallmentGraphDetailModel] {
        let monthCount = max(0, (graphs?.count ?? 0) - 1)
        return [
            .init(title: "total_installment_amount".localized(.olchaNasiyaModule),
                  key: getTotalPayment().string.originalPrice),
            .init(title: "period".localized(.olchaNasiyaModule),
                  key:  monthCount.string),
            .init(title: "given_date".localized(.olchaNasiyaModule),
                  key: created_at ?? " - ")
        ]
    }
    
    public func getPaid() -> Int {
        (total_payment_all ?? 0).int
    }
    
    public func getTotalPayment() -> Int {
        (total_price_all ?? 0).int
    }
    
    public func getRemainder() -> Int {
        (total_my_payments_all ?? 0).int
    }
    
    public func getReflection() -> String {
        billing_reflection_alias ?? ""
    }
    
    public func getCurrentPayment() -> Int? {
        current_payment?.int
    }
}

extension InstallmentModel {
    public enum Status: String, CaseIterable {
        case all
        case active = "in_work"
        case finished = "fail"
        case none
        
        var title: String {
            switch self {
            case .all:
                return "all".localized(.olchaNasiyaModule)
            case .active:
                return "in_work".localized(.olchaNasiyaModule)
            case .finished:
                return "finished".localized(.olchaNasiyaModule)
            default:
                return ""
            }
        }
    }
    
    public static func mock(id: Int? = 1) -> InstallmentModel {
        InstallmentModel(id: id,
                         status: ["finished"].randomElement(),
                         created_at: "04 март. 2023",
                         name: "olcha",
                         total_cost: 1_000_000,
                         first_fee: 1_000_000,
                         full_address: "Darxontepa 1, 4-uy",
                         phone: "99897 002 71 88",
                         graphs: [
                            .mock(),
                            .mock(),
                            .mock(),
                            .mock(),
                            .mock(),
                            .mock(),
                            .mock()
                         ],
                         details: [
                            .mock(title: "Сумма рассрочки", key: "3 000 000 сум"),
                            .mock(title: "Срок", key: "6 месяцев"),
                            .mock(title: "Когда выдана", key: "16 ноября 2022")
                         ])
    }
}



public class InstallmentStatus: Codable, Equatable {
    public static func == (lhs: InstallmentStatus, rhs: InstallmentStatus) -> Bool {
        lhs.key == rhs.key
    }
    
    public var key: String?
    public var title: String?
    
    public static var all: InstallmentStatus {
        InstallmentStatus(key: "all", title: "all".localized())
    }
    
    public static var inWork: InstallmentStatus {
        InstallmentStatus(key: "in_work", title: "in_work".localized())
    }
    
    public init(key: String? = nil, title: String? = nil) {
        self.key = key
        self.title = title
    }
}

/*
 
 build_app(workspace: "OlchaNasiya.xcworkspace",
       scheme: "OlchaNasiya",
       clean: false,
           silent: true,
           xcargs: "-allowProvisioningUpdates")
 
*/
