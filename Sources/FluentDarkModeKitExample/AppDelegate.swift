//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentDarkModeKit
import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {

    DarkModeManager.setup(with: application)

    window = UIWindow()
    window?.rootViewController = {
      let tabBarController = UITabBarController()
      tabBarController.viewControllers = [
        NavigationController(rootViewController: MainViewController()),
        NavigationController(rootViewController: ViewController()),
      ]
      return tabBarController
    }()
    window?.makeKeyAndVisible()

    return true
  }
}
