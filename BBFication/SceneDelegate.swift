//
//  SceneDelegate.swift
//  BBFication
//
//  Created by Tim Storey on 14/12/2019.
//  Copyright © 2019 Tim Storey. All rights reserved.
//

import UIKit
import SwiftUI

/// the data manager is not made available to the stack
/// this is because I havent figured out a noce way to do it using SwiftUI
/// we might use the @EnvironmentObject perhaps, requires some more playing.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

                PersistenceHelper.createProductionContainer{ container in

                    let persistenceManager = PersistenceManager(store: container)
                    let sessionManager = URLSession(configuration: URLSessionConfiguration.default)
                    let characterManager = AnyMapper(CharacterMapper(storeManager: persistenceManager))
                    let dataManager = DataManager(storeManager: persistenceManager, urlSession: sessionManager, parser: characterManager)
                    dataManager.fetch()
                    let viewModel = CharacterViewModel(container)
                    let vc = MainContentView()
                    
                    // Use a UIHostingController as window root view controller.
                    if let windowScene = scene as? UIWindowScene {
                        let window = UIWindow(windowScene: windowScene)
                        window.rootViewController = UIHostingController(rootView: vc
                            .environment(\.managedObjectContext, container)
                            .environmentObject(viewModel))
                        self.window = window
                        window.makeKeyAndVisible()
                    }
                                    
                }

        // Create the SwiftUI view that provides the window contents.        let contentView = ContentView()

        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

