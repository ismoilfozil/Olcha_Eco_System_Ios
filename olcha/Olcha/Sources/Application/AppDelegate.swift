//
//  AppDelegate.swift
//  NewOlcha
//
//  Created by Elbek on 1/7/21.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Firebase
import FirebaseMessaging
import FirebaseCrashlytics
import FirebaseAnalytics
import UserNotifications
import YandexMobileMetrica
//import FBSDKCoreKit
import ModuleGenerator
import OlchaAuth
import OlchaMarketModule
import OlchaUtils

@main
public class AppDelegate: UIResponder, UIApplicationDelegate {

    private let gcmMessageIDKey = "gcm.message_id"

    private let metricaApiKey = AppMetricaService.shared.ApiKey

    private let yandexMapKey = "e41febd5-d1f3-47ab-b889-dba5b9daaf79"

    var cloudMessagingData: CloudMessagingData?

    public func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        firebaseConfiguration(application)
        metricaConfiguration()
        otherConfiguration()
        mapConfiguration()
        facebookConfiguration(application, didFinishLaunchingWithOptions: launchOptions)
        print("initial tokens", "access_token", AuthGlobalDefaults.access_token)
        print("initial tokens", "refresh_token", AuthGlobalDefaults.refresh_token)
        print("initial tokens", "client_type", AuthGlobalDefaults.client_type)
        LocalizationBundle.setup()
//        LanguageManager.shared.setLanguage(LanguageManager.shared.currentLanguage)
        ModulesConfiguration.shared.setup()
        return true
    }

    private func firebaseConfiguration(_ application: UIApplication) {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        Analytics.setAnalyticsCollectionEnabled(true)

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        UIApplication.shared.registerForRemoteNotifications()
    }

    private func metricaConfiguration() {
        if let configuration = YMMYandexMetricaConfiguration(apiKey: metricaApiKey) {

            configuration.locationTracking = true
            configuration.crashReporting = true
            configuration.logs = true
            configuration.statisticsSending = true
            configuration.appOpenTrackingEnabled = true

            YMMYandexMetrica.activate(with: configuration)
        }
    }

    private func otherConfiguration() {
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
        IQKeyboardManager.shared.disabledToolbarClasses  = [AllReviewRepliesPage.self]
    }


    private func facebookConfiguration(_ application: UIApplication,
                                       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
//        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
//        FacebookService.shared.mainConfiguration()
    }

    private func mapConfiguration() {
//        YMKMapKit.setApiKey(yandexMapKey)
//        YMKMapKit.sharedInstance()
    }

    // MARK: UISceneSession Lifecycle


    public func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("APNs device token registered")
        refreshFCMToken()
    }

    public func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }

    public func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    public func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}

//    public func application(_ application: UIApplication,
//                            didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
//                            -> Void) {
//
//        completionHandler(UIBackgroundFetchResult.newData)
//    }

    public func applicationWillTerminate(_ application: UIApplication) {

    }

    private func subscribeToPushTopics() {
        [
            Texts.notificationTopics.ecoSystem,
            Texts.notificationTopics.ecoSystemTest
        ].forEach { topic in
            Messaging.messaging().subscribe(toTopic: topic) { error in
                if let error {
                    print("FCM topic subscription failed (\(topic)): \(error)")
                } else {
                    print("FCM topic subscribed: \(topic)")
                }
            }
        }
    }

    private func refreshFCMToken() {
        Messaging.messaging().token { [weak self] token, error in
            if let error {
                print("FCM token fetch failed: \(error)")
                return
            }

            guard let token else {
                print("FCM token fetch returned nil")
                return
            }

            print("Firebase registration token: \(token)")
            UIPasteboard.general.string = token
            OlchaGlobalDefaults.fcm_token = token
            AuthGlobalDefaults.notification.fcm_token = token
            self?.subscribeToPushTopics()
        }
    }

}



//@available(iOS 10, *)
extension AppDelegate: @preconcurrency UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        let userInfo = notification.request.content.userInfo
        let action = NotificationAction(rawValue: Funcs.jsonMapper(jsonParams: userInfo).click_action ?? "")

        if action == .ramadanPraying, !(OlchaGlobalDefaults.user.ramazanPrayNotifications ?? true) {
            print("1")
        } else {
            print("2")
            Messaging.messaging().appDidReceiveMessage(userInfo)

            completionHandler((OlchaGlobalDefaults.notification ?? true) ? [.alert, .sound, .badge] : [.alert, .badge])


        }

    }


    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        let userInfo = response.notification.request.content.userInfo

        Messaging.messaging().appDidReceiveMessage(userInfo)

        if let action = Funcs.clickActionMapper(jsonParams: userInfo)?.getAction() {
            ClickActionCoordinator.clickActionRouter(action: action)
        } else if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            scene.getAppCoordinator()?.notificationRouter(notification: Funcs.jsonMapper(jsonParams: userInfo))
        }

        completionHandler()
    }

}

extension AppDelegate: @preconcurrency MessagingDelegate {
    public func messaging(_ messaging: Messaging,
                   didReceiveRegistrationToken fcmToken: String?) {
              print("Firebase registration token: \(String(describing: fcmToken))")

        if let fcmToken = fcmToken {
            OlchaGlobalDefaults.fcm_token = fcmToken
            AuthGlobalDefaults.notification.fcm_token = fcmToken
        }

        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )

    }

}
