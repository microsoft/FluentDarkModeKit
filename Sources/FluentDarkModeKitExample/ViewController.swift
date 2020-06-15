//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentDarkModeKit
import UIKit

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .refresh,
      target: self,
      action: #selector(refresh)
    )
  }

  @objc private func refresh() {
    // Loop throught the available styles
    DMTraitCollection.setCurrent(DMTraitCollection(userInterfaceStyle: DMTraitCollection.lastManuallySet.userInterfaceStyle.next), animated: true)
    showUserSetInterfaceStyle()
  }

  private func showUserSetInterfaceStyle() {
    let alert = UIAlertController(title: DMTraitCollection.lastManuallySet.userInterfaceStyle.description, message: nil, preferredStyle: .alert)
    if alert.popoverPresentationController != nil {
      alert.popoverPresentationController?.sourceRect = .zero
      alert.popoverPresentationController?.sourceView = view
    }
    present(alert, animated: true, completion: nil)
    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] _ in
      self?.dismiss(animated: true, completion: nil)
    }
  }
}

private extension DMUserInterfaceStyle {
  var description: String {
    switch self {
    case .dark:
      return "dark"
    case .light:
      return "light"
    default:
      return "unspecified"
    }
  }

  var next: DMUserInterfaceStyle {
    switch self {
    case .light:
      return .dark
    case .dark:
      return .unspecified
    default:
      return .light
    }
  }
}
