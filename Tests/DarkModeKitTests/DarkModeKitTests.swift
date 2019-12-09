//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest
@testable import DarkModeKit

final class DarkModeKitTests: XCTestCase {
    func testSetBackgroundColorSwizzling() {
        UIWindow.appearance().backgroundColor = .white
        DarkModeManager.setup()
        _ = UIWindow()
    }

    func testColorInitializer() {
        let color = UIColor(.dm, light: .white, dark: .black)

        DMTraitCollection.current = DMTraitCollection(userInterfaceStyle: .light)
        XCTAssertEqual(color.rgba, UIColor.white.rgba)

        DMTraitCollection.current = DMTraitCollection(userInterfaceStyle: .dark)
        XCTAssertEqual(color.rgba, UIColor.black.rgba)
    }
}

extension UIColor {
    struct RGBA: Equatable {
        var red: CGFloat
        var green: CGFloat
        var blue: CGFloat
        var alpha: CGFloat
    }

    var rgba: RGBA {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return RGBA(red: red, green: green, blue: blue, alpha: alpha)
    }
}
