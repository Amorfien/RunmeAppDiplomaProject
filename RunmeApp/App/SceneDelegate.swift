//
//  SceneDelegate.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let navigationController = UINavigationController()
        let appCoordinator = AppCoordinator(navigationController: navigationController)

        self.window = UIWindow(windowScene: windowScene)
        self.appCoordinator = appCoordinator
        appCoordinator.start()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }


}

