import UIKit
import OlchaUtils

public struct UserDevice: Codable, Sendable {
    public var is_enabled: Bool = true
    public var device_model: String
    public var device_id: String?
    public var device_lang: String? = Locale.current.languageCode
    public var application: String = "ios"
    public var token: String
    public var user_lang: String
    public var app_version: String

    @MainActor
    public init(
        is_enabled: Bool = true,
        device_model: String = "\(UIDevice.modelName);" + "ios: \(UIDevice.current.systemVersion)",
        device_id: String? = UIDevice.current.identifierForVendor?.uuidString,
        device_lang: String? = Locale.current.languageCode,
        application: String = "ios",
        token: String,
        user_lang: String,
        app_version: String
    ) {
        self.is_enabled = is_enabled
        self.device_model = device_model
        self.device_id = device_id
        self.device_lang = device_lang
        self.application = application
        self.token = token
        self.user_lang = user_lang
        self.app_version = app_version
    }
}
