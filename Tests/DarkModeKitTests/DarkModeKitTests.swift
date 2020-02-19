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

  func testImageInitializer() {
    let lightImage = UIImage()
    let darkImage = UIImage()
    _ = UIImage(.dm, light: lightImage, dark: darkImage)
  }

  func testColorPropertySetters() {
    let color = UIColor(.dm, light: .white, dark: .black)

    let view = UIView()
    view.backgroundColor = color
    view.tintColor = color
    XCTAssertFalse(view.backgroundColor === color)
    XCTAssertTrue(view.tintColor === color)

    // UIView subclasses
    do {
      let activityIndictorView  = UIActivityIndicatorView()
      activityIndictorView.color = color
      XCTAssertTrue(activityIndictorView.color === color)

      // UIControl subclasses
      do {
        let button = UIButton()
        button.setTitleColor(color, for: .normal)
        button.setTitleShadowColor(color, for: .normal)
        XCTAssertTrue(button.titleColor(for: .normal) === color)
        XCTAssertTrue(button.titleShadowColor(for: .normal) === color)

        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = color
        pageControl.currentPageIndicatorTintColor = color
        XCTAssertTrue(pageControl.pageIndicatorTintColor === color)
        XCTAssertTrue(pageControl.currentPageIndicatorTintColor === color)

        if #available(iOS 13, *) {
          let segmentedControl = UISegmentedControl()
          segmentedControl.selectedSegmentTintColor = color
          XCTAssertTrue(segmentedControl.selectedSegmentTintColor === color)
        }

        let slider = UISlider()
        slider.minimumTrackTintColor = color
        slider.maximumTrackTintColor = color
        slider.thumbTintColor = color
        XCTAssertTrue(slider.minimumTrackTintColor === color)
        XCTAssertTrue(slider.maximumTrackTintColor === color)
        XCTAssertTrue(slider.thumbTintColor === color)

        let `switch` = UISwitch()
        `switch`.onTintColor = color
        `switch`.thumbTintColor = color
        XCTAssertTrue(`switch`.onTintColor === color)
        XCTAssertTrue(`switch`.thumbTintColor === color)

        let textField = UITextField()
        textField.textColor = color
        XCTAssertTrue(textField.textColor === color)

        if #available(iOS 13, *) {
          let searchTextField = UISearchTextField()
          searchTextField.tokenBackgroundColor = color
          XCTAssertTrue(searchTextField.tokenBackgroundColor === color)
        }
      }

      let label = UILabel()
      label.textColor = color
      label.shadowColor = color
      label.highlightedTextColor = color
      XCTAssertTrue(label.textColor === color)
      XCTAssertFalse(label.shadowColor === color)
      XCTAssertTrue(label.highlightedTextColor === color)

      let navigationBar = UINavigationBar()
      navigationBar.barTintColor = color
      XCTAssertTrue(navigationBar.barTintColor === color)

      let progressView = UIProgressView()
      progressView.progressTintColor = color
      progressView.trackTintColor = color
      XCTAssertTrue(progressView.progressTintColor === color)
      XCTAssertTrue(progressView.trackTintColor === color)

      // UIScrollView subclasses
      do {
        let tableView = UITableView()
        tableView.sectionIndexColor = color
        tableView.sectionIndexBackgroundColor = color
        tableView.sectionIndexTrackingBackgroundColor = color
        tableView.separatorColor = color
        XCTAssertTrue(tableView.sectionIndexColor === color)
        XCTAssertTrue(tableView.sectionIndexBackgroundColor === color)
        XCTAssertTrue(tableView.sectionIndexTrackingBackgroundColor === color)
        XCTAssertTrue(tableView.separatorColor === color)

        let textView = UITextView()
        textView.textColor = color
        XCTAssertTrue(textView.textColor === color)
      }

      let searchBar = UISearchBar()
      searchBar.barTintColor = color
      XCTAssertFalse(searchBar.barTintColor === color)

      let tabBar = UITabBar()
      tabBar.barTintColor = color
      tabBar.unselectedItemTintColor = color
      XCTAssertTrue(tabBar.barTintColor === color)
      XCTAssertTrue(tabBar.unselectedItemTintColor === color)

      let toolbar = UIToolbar()
      toolbar.barTintColor = color
      XCTAssertTrue(toolbar.barTintColor === color)
    }
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
