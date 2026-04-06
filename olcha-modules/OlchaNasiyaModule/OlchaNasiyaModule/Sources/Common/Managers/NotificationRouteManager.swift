//
//  NotificationRouteManager.swift
//  OlchaNasiyaModule
//
//  Created by Akhrorkhuja on 08/08/23.
//

import Foundation

///-  Sizga “SUMMA” miqdorida limit berildi. Type - summa
///-  Sizning Limit olish bo’yicha so’rovingiz ko’rib chiqish jarayonida. Type - limit
///-  Sizning limit olish bo’yicha so’rovingiz “SABAB” ga ko’ra rad etildi. Type - limit
///-  Sizda foydalanilmagan “SUMMA” limit mavjud. Type - summa
///-  “Skidkalar bo’yicha habarnomalar”. Type - notification
///- Sizning "Sonli" muddatli to'lovga arizangiz ko'rib chiqishga yuborildi - Type - instalment
///- Sizning "Sonli" muddatli to'lovga arizangiz tasdiqlandi - Type - instalment
///- Sizning "Sonli" muddatli to'lovga arizangiz “SABAB” ga ko’ra rad - Type - instalment
///- Sizning "Sonli" muddatli to'lov shartnomangiz bo'yicha "SUMMA" muddati o'tgan qarzingiz mavjud. To'lash uchun quyidagi havola orqali o'ting havola  (balans to'ldirish sahifasiga otishi mumkin) - Type - instalment
///- Sizning "Sonli" muddatli to'lov shartnomasi bo'yicha "SANA" da navbatdagi to'lov kuningiz. To'lash uchun quyidagi havola orqali o'ting havola  (balans to'ldirish sahifasiga otishi mumkin)  - Type - instalment

public enum NotificationRoute {
    case installment(id: Int)
    case limitCard
    case payInstallment(id: Int)
    case verification
}

public final class NotificationRouteManager {
        
    public static func route(from data: CloudNotification) -> NotificationRoute? {
        switch data.click_action {
        case .limitCard:
            return .limitCard
        case .installment:
            guard let installmentId = data.installment_id?.int else { return .none }
            return .installment(id: installmentId)
        case .payInstallment:
            guard let installmentId = data.installment_id?.int else { return .none }
            return .payInstallment(id: installmentId)
        case .verification:
            return .verification
        }
    }
    
}
