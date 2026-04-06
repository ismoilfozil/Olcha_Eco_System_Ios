//
//  InstallmentGraphModel.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 17/05/23.
//

import UIKit


public class InstallmentGraphMonthModel: Codable {
    public enum Status: String {
        
        case in_progress = "in_progress"
        case paid = "paid"
        case fail = "fail"
        case success = "success"
        case none
        
        
        #warning("icons")
        public var icon: UIImage? {
            switch self {
            case .in_progress:
                return .graph_progress
            case .paid:
                return .graph_success
            case .success:
                return .graph_success
            case .fail:
                return .graph_progress
            case .none:
                return nil
            }
        }
        
        var accentColor: UIColor? {
            switch self {
            case .in_progress:
                return .olchaBlue
            case .paid:
                return .olchaGreen
            case .success:
                return .olchaGreen
            case .fail:
                return .olchaAccentColor
            case .none:
                return .olchaDarkGray
            }
        }
    }
    
    public var payment_day: String?
    public var status: String?
    public var status_name: String?
    public var payments: String?
    public var actual_payment_date: String?
    
    public var paymentItems: [InstallmentPaymentDetailModel]?
    
    public var isExpanded: Bool = false
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.payment_day = try container.decodeIfPresent(String.self, forKey: .payment_day)
        } catch {}
        
        do {
            self.status = try container.decodeIfPresent(String.self, forKey: .status)
        } catch {}
        
        do {
            self.status_name = try container.decodeIfPresent(String.self, forKey: .status_name)
        } catch {}

        do {
            self.payments = try container.decodeIfPresent(String.self, forKey: .payments)
        } catch {}
        
        do {
            self.actual_payment_date = try container.decodeIfPresent(String.self, forKey: .actual_payment_date)
        } catch {}
        
        do {
            self.paymentItems = try container.decodeIfPresent([InstallmentPaymentDetailModel].self, forKey: .paymentItems)
        } catch {}
        
        do {
            self.isExpanded = try container.decode(Bool.self, forKey: .isExpanded)
        } catch {}
    }
    
    public init(payment_day: String? = nil,
                status: String? = nil,
                status_name: String? = nil,
                payments: String? = nil,
                isExpanded: Bool = false) {
        self.payment_day = payment_day
        self.status = status
        self.payments = payments
        self.isExpanded = isExpanded
    }
    
    public func getPaymentItems() -> [InstallmentPaymentDetailModel] {
        
        if let paymentItems, !paymentItems.isEmpty  {
            return paymentItems
        } else {
            let paymentsList = payments?.replacingOccurrences(of: " ", with: "")
                                        .components(separatedBy: ",")
                                        .filter { $0 != "" }
                                        .compactMap { $0.double } ?? []
            
            let datesList = actual_payment_date?.replacingOccurrences(of: " ", with: "")
                                                .components(separatedBy: ",")
                                                .filter { $0 != "" }
                                                .compactMap { $0 } ?? []
            
            guard paymentsList.count == datesList.count else {
                return []
            }
            
            let paymentItems: [InstallmentPaymentDetailModel] = zip(paymentsList, datesList).compactMap { (payment, date) in
                return InstallmentPaymentDetailModel(date: date, amount: payment)
            }
            
            self.paymentItems = paymentItems
            return paymentItems
        }
    }
    
    public func getStatus() -> InstallmentGraphMonthModel.Status {
        if let status {
            return InstallmentGraphMonthModel.Status(rawValue: status) ?? .none
        }
        return .none
    }
    
    public func getPaymentDay() -> String {
        payment_day?.formated_date ?? " - "
    }
    
    public static func mock() -> InstallmentGraphMonthModel {
        .init(payment_day: "12.12.2023",
              status: ["in_progress", "fail", "paid"].randomElement(),
              payments: "")
    }
}
public struct InstallmentGraphDetailModel: Codable {
    public var title: String?
    public var key: String?
    
    public static func mock(title: String = "Сумма рассрочки", key: String = "3 000 000 сум") -> Self {
        .init(title: title, key: key)
    }
}

public struct InstallmentPaymentDetailModel: Codable {
    public var date: String?
    public var amount: Double?
    
    public static func mock(date: String? = "16 май 2023",
                            amount: Double? = 214_000
    ) -> Self {
        return InstallmentPaymentDetailModel(date: date, amount: amount)
    }
}
