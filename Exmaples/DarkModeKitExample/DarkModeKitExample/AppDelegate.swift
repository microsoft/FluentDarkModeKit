//
//  AppDelegate.swift
//  DarkModeKitExample
//
//  Created by Bei Li on 2019/10/31.
//  Copyright © 2019 Microsoft Corporation. All rights reserved.
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
        return true
    }
}
