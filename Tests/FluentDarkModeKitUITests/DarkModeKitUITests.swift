//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

final class DarkModeKitUITests: XCTestCase {
  override func setUp() {
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false

    // UI tests must launch the application that they test.
    // Doing this in setup will make sure it happens for each test method.
    XCUIApplication().launch()
  }

  func testUIView() {
    _test("UIView")
  }

  func testUIActivityIndicatorView() {
    _test("UIActivityIndicatorView")
  }

  func testUIButton() {
    _test("UIButton")
  }

  func testUIPageControl() {
    _test("UIPageControl")
  }

  func _test(_ className: String) {
    let app = XCUIApplication()
    let refreshButton = app.navigationBars["FluentDarkModeKitExample.MainView"].buttons["Refresh"]
    refreshButton.tap()

    let uiviewStaticText = app.tables.staticTexts[className]
    uiviewStaticText.tap()

    let screenshot1 = app.screenshot()

    app.navigationBars["FluentDarkModeKitExample.\(className)VC"].buttons["Back"].tap()
    refreshButton.tap()
    uiviewStaticText.tap()

    let tabBarsQuery = app.tabBars
    tabBarsQuery.children(matching: .button).element(boundBy: 1).tap()
    app.navigationBars["FluentDarkModeKitExample.View"].buttons["Refresh"].tap()
    tabBarsQuery.children(matching: .button).element(boundBy: 0).tap()

    let screenshot2 = app.screenshot()

    XCTAssertTrue(compare(screenshot1.image, screenshot2.image, precision: 1))
  }
}

private func compare(_ old: UIImage, _ new: UIImage, precision: Float) -> Bool {
  guard let oldCgImage = old.cgImage else { return false }
  guard let newCgImage = new.cgImage else { return false }
  guard oldCgImage.width != 0 else { return false }
  guard newCgImage.width != 0 else { return false }
  guard oldCgImage.width == newCgImage.width else { return false }
  guard oldCgImage.height != 0 else { return false }
  guard newCgImage.height != 0 else { return false }
  guard oldCgImage.height == newCgImage.height else { return false }
  // Values between images may differ due to padding to multiple of 64 bytes per row,
  // because of that a freshly taken view snapshot may differ from one stored as PNG.
  // At this point we're sure that size of both images is the same, so we can go with minimal `bytesPerRow` value
  // and use it to create contexts.
  let minBytesPerRow = min(oldCgImage.bytesPerRow, newCgImage.bytesPerRow)
  let byteCount = minBytesPerRow * oldCgImage.height

  var oldBytes = [UInt8](repeating: 0, count: byteCount)
  guard let oldContext = context(for: oldCgImage, bytesPerRow: minBytesPerRow, data: &oldBytes) else { return false }
  guard let oldData = oldContext.data else { return false }
  if let newContext = context(for: newCgImage, bytesPerRow: minBytesPerRow), let newData = newContext.data {
    if memcmp(oldData, newData, byteCount) == 0 { return true }
  }
  let newer = UIImage(data: new.pngData()!)!
  guard let newerCgImage = newer.cgImage else { return false }
  var newerBytes = [UInt8](repeating: 0, count: byteCount)
  guard let newerContext = context(for: newerCgImage, bytesPerRow: minBytesPerRow, data: &newerBytes) else { return false }
  guard let newerData = newerContext.data else { return false }
  if memcmp(oldData, newerData, byteCount) == 0 { return true }
  if precision >= 1 { return false }
  var differentPixelCount = 0
  let threshold = 1 - precision
  for byte in 0..<byteCount {
    if oldBytes[byte] != newerBytes[byte] { differentPixelCount += 1 }
    if Float(differentPixelCount) / Float(byteCount) > threshold { return false}
  }
  return true
}

private func context(for cgImage: CGImage, bytesPerRow: Int, data: UnsafeMutableRawPointer? = nil) -> CGContext? {
  guard
    let space = cgImage.colorSpace,
    let context = CGContext(
      data: data,
      width: cgImage.width,
      height: cgImage.height,
      bitsPerComponent: cgImage.bitsPerComponent,
      bytesPerRow: bytesPerRow,
      space: space,
      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    )
    else { return nil }

  context.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
  return context
}
