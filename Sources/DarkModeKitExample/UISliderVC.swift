//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import DarkModeKit

final class UISliderVC: ViewController {
  let slider: UISlider = {
    let slider = UISlider()
    slider.minimumTrackTintColor = UIColor(.dm, light: .red, dark: .green)
    slider.maximumTrackTintColor = UIColor(.dm, light: .green, dark: .red)
    slider.thumbTintColor = UIColor(.dm, light: .blue, dark: .cyan)
    slider.value = 0.5
    return slider
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor(.dm, light: .white, dark: .black)
    view.addSubview(slider)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    slider.sizeToFit()
    slider.center = view.center
  }
}
