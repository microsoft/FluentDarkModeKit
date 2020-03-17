//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentDarkModeKit

final class UIPageControlVC: ViewController {
  let pageControl: UIPageControl = {
    let pageControl = UIPageControl()
    pageControl.currentPageIndicatorTintColor = UIColor(.dm, light: .red, dark: .green)
    pageControl.pageIndicatorTintColor = UIColor(.dm, light: .green, dark: .red)
    pageControl.numberOfPages = 3
    return pageControl
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor(.dm, light: .white, dark: .black)
    view.addSubview(pageControl)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    pageControl.sizeToFit()
    pageControl.center = view.center
  }
}
