//
//  AppDelegate.swift
//  BBFication
//
//  Created by Tim Storey on 14/12/2019.
//  Copyright © 2019 Tim Storey. All rights reserved.
//

import UIKit

import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        PersistenceHelper.createProductionContainer{ container in
            //let storyboard = (self.window?.rootViewController?.storyboard)!
//            guard let vc = storyboard.instantiateViewController(withIdentifier: "LocationsViewController") as? LocationsViewController else {
//                fatalError("Could not instantiate locations view controller")
//            }
//            let persistenceManager = PersistenceManager(store: container)
//            let sessionManager = URLSession(configuration: URLSessionConfiguration.default)
//            let locationManager = AnyMapper(LocationMapper(storeManager: persistenceManager))
//            let localleManager = AnyMapper(LocalleMapper(storeManager: persistenceManager))
//            self.dataManager = DataManager(storeManager: persistenceManager, urlSession: sessionManager, locationParser: locationManager, localleParser: localleManager)
//            vc.dataManager = self.dataManager
//            let nv = UINavigationController(rootViewController: vc)
//            self.window?.rootViewController = nv
//        }
        
        return true
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



}

