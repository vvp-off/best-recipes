//
//  SceneDelegate.swift
//  Best Recipes
//
//  Created by VP on 11.08.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowsScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowsScene)
        
        let alreadyShown = UserDefaults.standard.bool(forKey: AppKeys.didShowOnboarding)
        let rootVC: UIViewController = {
            if alreadyShown {
                return TabBarViewController()
            } else {
                return UINavigationController(rootViewController: StartViewController())
            }
        }()
        
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        
        self.window = window
    }
}
