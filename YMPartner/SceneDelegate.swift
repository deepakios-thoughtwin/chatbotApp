//
//  SceneDelegate.swift
//  YMPartner
//
//  Created by Kauntey Suryawanshi on 29/03/21.
//

import UIKit
import YMSupport

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    static weak var shared: SceneDelegate?

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        self.window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()

        Self.shared = self

        if let accessToken = defaults.accessToken, let username = defaults.username, let selectedBot = defaults.selectedBotId {
            YMSupport.accessToken = accessToken
            YMSupport.username = username
            YMSupport.botId = selectedBot
            showMainView()
        } else {
            showLogin()
        }
//        showHome()
//        presentBotSelector()
    }

    func presentBotSelector() {
        let botVC = BotListViewController.makeFromStoryboard()
        let nav = UINavigationController(rootViewController: botVC)
        window?.rootViewController = nav
    }

    func showLogin() {
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()!
        window?.rootViewController = vc
    }

    func showMainView() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
        window?.rootViewController = vc
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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

