//
//  AppDelegate.swift
//  YMapsIntergation
//
//  Created by Amir on 15.03.2025.
//

import UIKit
import YandexMapsMobile
import CoreData

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "StoredEntities")
        container.loadPersistentStores { description, error in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        YMKMapKit.setApiKey("522fb9ba-acc3-4c2a-ad64-371448cace44")
        YMKMapKit.setLocale("ru_RU")
        YMKMapKit.sharedInstance()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationController = UINavigationController()
        let rootViewController = TabBarController()
        navigationController.viewControllers = [rootViewController]
        
        self.window!.rootViewController = navigationController
        self.window!.makeKeyAndVisible()
        
        return true
    }
}

