//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import DarkModeKit

final class UIButtonVC: ViewController {
  let button: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Test", for: .normal)
    button.setTitleColor(UIColor(.dm, light: .red, dark: .green), for: .normal)
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor(.dm, light: .white, dark: .black)

    view.addSubview(button)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    button.sizeToFit()
    button.center = view.center
  }
}
