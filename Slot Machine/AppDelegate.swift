//
//  AppDelegate.swift
//  Slot Machine
//
//  Created by Alex Pirog on 08.05.2021.
//

import UIKit
import UserNotifications
import FBSDKCoreKit
import YandexMobileMetrica

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        let configuration = YMMYandexMetricaConfiguration.init(apiKey: "ea4fabc9-0b26-4933-bd63-4b3480a50a51")
        configuration?.logs = true
        YMMYandexMetrica.activate(with: configuration!)
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            [unowned self] granted, error in
            if granted {
                scheduleNotification()
            }
        }
        center.delegate = self
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Notifications
        
    func scheduleNotification() {
        let currency: Currency = Bool.random() ? .stars : .gems
        let amount = [50, 50, 50, 100, 100, 300].randomElement()!
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Special Offer"
        content.body = "Don't miss our exclusive today's deal and get \(amount) \(currency.rawValue) for free! Harry up!"
        content.categoryIdentifier = "offer"
        content.userInfo = [
            "currency": currency.rawValue,
            "amount": amount,
            "scheduledDate": Date(),
            "availability": TimeInterval.hour
        ]
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: .minute, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userData = response.notification.request.content.userInfo
        if let raw = userData["currency"] as? String,
           let currency = Currency(rawValue: raw),
           let amount = userData["amount"] as? Int,
           let scheduledDate = userData["scheduledDate"] as? Date,
           let availability = userData["availability"] as? TimeInterval {
            if scheduledDate.distance(to: Date()) < availability {
                Storage.shared.userBank[currency]! += amount
                print(" >> Got \(amount)\(raw) for free!")
            } else {
                print(" >> Missed \(amount)\(raw) offer...")
            }
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(" >> Notification arrived when in game!")
        completionHandler([.alert, .badge, .sound])
    }
    
}
