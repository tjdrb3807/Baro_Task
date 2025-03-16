//
//  SceneDelegate.swift
//  Baro_Task
//
//  Created by 전성규 on 3/14/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let loginViewControler = LoginViewController(viewModel: LoginViewModel())
        let navigationController = UINavigationController(rootViewController: loginViewControler)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

