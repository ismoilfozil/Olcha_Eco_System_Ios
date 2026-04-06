//
//  NotificationService.swift
//  NotificationExtensionService
//
//  Created by Elbek Khasanov on 27/06/22.
//

import UserNotifications

class NotificationExtensionService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        defer {
            contentHandler(bestAttemptContent ?? request.content)
        }
        
        let data = request.content.userInfo
        
        let icon = data["icon"] as? String
        let picture = data["picture"] as? String
        
        
        let title_ru = data["title_ru"] as? String
        let title_uz = data["title_uz"] as? String
        let title_oz = data["title_oz"] as? String
        
        let body_ru = data["body_ru"] as? String
        let body_uz = data["body_uz"] as? String
        let body_oz = data["body_oz"] as? String
        
        
        
        bestAttemptContent?.body = getLangText(body_ru, body_uz, body_oz)
        bestAttemptContent?.title = getLangText(title_ru, title_uz, title_oz)
        if let url = icon,
           let attachment = parseAttachment(imageUrl: url) {
            bestAttemptContent?.attachments = [attachment]
        } else if let url = picture,
                  let attachment = parseAttachment(imageUrl: url) {
            bestAttemptContent?.attachments = [attachment]
        }
                  
        
    }
    
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    func parseAttachment(imageUrl: String) -> UNNotificationAttachment? {
        if let imageData = try? Data(contentsOf: URL(string: imageUrl)!) {
            return try? UNNotificationAttachment(data: imageData, options: nil)
        }
        
        return nil
    }
    
    private func getLangText(_ ru: String?, _ uz: String?, _ oz: String?) -> String {

        if NotificationDefaults.shared.getLanguage() == "en" {
            return oz ?? " - "
        } else if NotificationDefaults.shared.getLanguage() == "ru" {
            return ru ?? " - "
        } else {
            return uz ?? " - "
        }
    }
    
}
extension UNNotificationAttachment {

    convenience init(data: Data, options: [NSObject: AnyObject]?) throws {
        let fileManager = FileManager.default
        let temporaryFolderName = ProcessInfo.processInfo.globallyUniqueString
        let temporaryFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(temporaryFolderName, isDirectory: true)

        try fileManager.createDirectory(at: temporaryFolderURL, withIntermediateDirectories: true, attributes: nil)
        let imageFileIdentifier = UUID().uuidString + ".jpg"
        let fileURL = temporaryFolderURL.appendingPathComponent(imageFileIdentifier)
        try data.write(to: fileURL)
        try self.init(identifier: imageFileIdentifier, url: fileURL, options: options)
    }
}
