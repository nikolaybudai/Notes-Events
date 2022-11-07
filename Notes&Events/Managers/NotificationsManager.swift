//
//  NotificationsManager.swift
//  Notes&Events
//
//  Created by Nikolay Budai on 7.11.22.
//

import Foundation
import UserNotifications
import UIKit

final class NotificationsManager {
    
    static let shared = NotificationsManager()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { permissionGranted, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func isStatusAuthorized() -> Bool {
        var isAuthorized: Bool = true
        notificationCenter.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) ||
                  (settings.authorizationStatus == .provisional) else {
                isAuthorized = false
                return
            }
        }
        return isAuthorized
    }
    
    func createConfirmingAlertController(date: Date?) -> UIAlertController {
    
        let alertController = UIAlertController(title: "Notification Scheduled!", message: "We will remind you about this event!", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        
        return alertController
    }
    
    func createNotificationDisabledAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: "Notifications disabled!", message: "To recieve notifications you must enable notifications in settings", preferredStyle: .alert)
        
        let goToSettingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString)
            else { return }
            
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL)
            }
        }
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        alertController.addAction(goToSettingsAction)
        alertController.addAction(okAction)
        
        return alertController
    }
    
    func scheduleNotification(title: String?, body: String?, date: Date?) {
                        
        let content = UNMutableNotificationContent()
        content.title = title ?? ""
        content.body = body ?? ""
        
        guard let date = date else { return }

        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        self.notificationCenter.add(request) { error in
            if error != nil {
                print("Error with notification request: " + error.debugDescription)
                return
            }
        }

    }
    
}
