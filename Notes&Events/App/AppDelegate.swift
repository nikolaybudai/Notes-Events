//
//  AppDelegate.swift
//  Notes&Events
//
//  Created by Nikolay Budai on 22.10.22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CoreDataManager.shared.load()
        return true
    }

}

