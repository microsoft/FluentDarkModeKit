//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import DarkModeKit
import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        DarkModeManager.setup(updateAppearance: { _ in })
        setUpAppearance()

        window = UIWindow()
        window?.rootViewController = {
            let tabBarController = UITabBarController()
            tabBarController.viewControllers = [
                NavigationController(rootViewController: ViewController()),
                NavigationController(rootViewController: ViewController()),
            ]
            return tabBarController
        }()
        window?.makeKeyAndVisible()

        return true
    }

    private func setUpAppearance() {
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = DynamicColor(lightColor: .white, darkColor: .darkGray)
    }
}
