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
}
