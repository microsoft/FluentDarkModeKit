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

    DarkModeManager.register(with: application, useUIImageAsset: true)

    if #available(iOS 13.0, *) {
      return true
    }

    window = AppDelegate.createNewWindow()
    window?.makeKeyAndVisible()

    return true
  }

  static func createNewWindow(with window: UIWindow) -> UIWindow {
    guard #available(iOS 13.0, *), let scene = window.windowScene else {
      return createNewWindow()
    }
    return createNewWindow(with: scene)
  }

  static func createNewWindow() -> UIWindow {
    let window = UIWindow()
    window.rootViewController = spawnNewViewController()
    return window
  }

  @available(iOS 13.0, *)
  static func createNewWindow(with windowScene: UIWindowScene) -> UIWindow {
    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = spawnNewViewController()
    return window
  }

  private static func spawnNewViewController() -> UIViewController {
    let tabBarController = UITabBarController()
    tabBarController.viewControllers = [
      NavigationController(rootViewController: MainViewController()),
      NavigationController(rootViewController: ViewController()),
    ]
    return tabBarController
  }

  // MARK: UISceneSession Lifecycle
  @available(iOS 13.0, *)
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
      return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
}
