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
        let vc = TabBarViewController()
        let window = UIWindow(windowScene: windowsScene)
        window.rootViewController = vc
        self.window = window
        
        window.makeKeyAndVisible()
    }
}
