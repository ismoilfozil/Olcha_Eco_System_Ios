//
//  FirebaseLog.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/01/23.
//
//import FirebaseAnalytics
import Foundation
import Alamofire
import SwiftyJSON
import OlchaAuth
import OlchaCore
class FirebaseLogger {
    
    static let analyticsEnabled = true
    
    static func requestLog(_ request: URLRequest?,
                           _ response: AFDataResponse<Data?>?
    ) {
        
        mainLog(title: request?.url?.path ?? "",
                messages: ["Field":
                    """
                    Response::::\(JSON(response?.data ?? Data()) ?? "")
                    Body::::\(JSON(request?.httpBody ?? Data()) ?? "");
                    Access::::\(AuthGlobalDefaults.access_token);
                    Refresh::::\(AuthGlobalDefaults.refresh_token);
                    Version::::\(MarketTexts.app_version);
                    """
                ])
    }
    
    
    static func decodelog(url: String?,
                          data: Data?,
                          message: String?
    ) {
        mainLog(title: "\(url ?? "") Decode_Error",
                messages:[
                    "Field":
                """
                Message::::\(message ?? "");
                Response::::\(JSON(data ?? Data()))
                Access::::\(AuthGlobalDefaults.access_token);
                Refresh::::\(AuthGlobalDefaults.refresh_token);
                Version::::\(MarketTexts.app_version);
                """
                ])
        
    }
    
    static func otherlog(
        message: String?,
        api: BaseAPI
    ) {
        mainLog(title: api.path ?? "",
                messages:
                    [
                        "Field":
                """
                Message::::\(message ?? "");
                Body::::\(JSON(api.body ?? Data()) ?? "");
                Access::::\(AuthGlobalDefaults.access_token);
                Refresh::::\(AuthGlobalDefaults.refresh_token);
                Version::::\(MarketTexts.app_version);
                """
                    ])
        
    }
    
    static func mainLog(title: String,
                        messages: [String: Any?]
    ) {
        guard FirebaseLogger.analyticsEnabled else { return }
//        Analytics.logEvent(title, parameters: messages)
        
        MetricEvents.shared.customEvent(
            title: title + ":::" + Date().date_string + ":::" + String.random(length: 7),
            messages: messages)
    }
}
