//
//  NotificationsModel.swift
//  NewOlcha
//
//  Created by Muhammadjon on 7/23/21.
//
import OlchaCore
import Foundation
struct NotificationsModel : Codable {
    var status: String?
    var message: String?
    var data: NotificationsData?
}

struct NotificationsData : Codable {
    var paginator: Paginator?
    var notifications: [NotificationEntity]?
    
    func mockData() -> [NotificationEntity] {
        []
    }
}

class NotificationEntity : Codable {
    var id: Int?
    var user_id: Int?
    
    var read: Bool?
    
    var title: String?
    var title_uz: String?
    var title_ru: String?
    var title_oz: String?
    
    var text: String?
    var text_ru: String?
    var text_uz: String?
    var text_oz: String?
    
    var icon: String?
    
    init(id: Int?, title: String?, title_uz: String?, title_ru: String?, title_oz: String?, text: String?, text_ru: String?, text_uz: String?, text_oz: String?, icon: String?) {
        self.id = id
        self.title_oz = title_oz
        self.title_uz = title_uz
        self.title_ru = title_ru
        self.title = title
        
        self.text = text
        self.text_oz = text_oz
        self.text_ru = text_ru
        self.text_uz = text_uz
        self.icon = icon
    }
    
    func getText() -> String {
        if let text = text {
            return text
        } else {
            return .lang(text_ru, text_uz, text_oz)
        }
    }
    
    func getTitle() -> String {
        if let title = title {
            return title
        } else {
            return .lang(title_ru, title_uz, title_oz)
        }
    }
}
