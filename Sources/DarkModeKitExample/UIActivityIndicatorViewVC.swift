//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import DarkModeKit

final class UIActivityIndicatorViewVC: ViewController {
  let activityIndicatorView: UIActivityIndicatorView = {
    let activityIndicatorView = UIActivityIndicatorView()
    activityIndicatorView.color = UIColor(.dm, light: .red, dark: .green)
    activityIndicatorView.hidesWhenStopped = false
    return activityIndicatorView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor(.dm, light: .white, dark: .black)

    view.addSubview(activityIndicatorView)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    activityIndicatorView.sizeToFit()
    activityIndicatorView.center = view.center
  }
}
