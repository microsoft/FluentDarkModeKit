//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import DarkModeCore
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
        return true
    }

    private func setUpAppearance() {
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = DynamicColor(lightColor: .white, darkColor: .darkGray)
    }
}
