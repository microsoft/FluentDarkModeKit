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
    if DMTraitCollection.current.userInterfaceStyle == .dark {
      DMTraitCollection.setCurrent(DMTraitCollection(userInterfaceStyle: .light), animated: true)
    }
    else {
      DMTraitCollection.setCurrent(DMTraitCollection(userInterfaceStyle: .dark), animated: true)
    }
  }
}
