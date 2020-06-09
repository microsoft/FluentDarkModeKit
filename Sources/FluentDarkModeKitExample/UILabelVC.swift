//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentDarkModeKit

final class UILabelVC: ViewController {
  let label: UILabel = {
    let label = UILabel()
    label.text = "Test"
    label.textColor = UIColor(.dm, light: .red, dark: .green)
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor(.dm, light: .white, dark: .black)

    view.addSubview(label)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    label.sizeToFit()
    label.center = view.center
  }
}
