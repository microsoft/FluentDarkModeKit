//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentDarkModeKit

private extension UIColor {
  var demoImage: UIImage {
    let size = CGSize(width: 50, height: 50)
    return UIGraphicsImageRenderer(size: size).image { context in
      setFill()
      context.fill(CGRect(origin: .zero, size: size))
    }
  }
}

final class UIImageViewVC: ViewController {
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(.dm, light: UIColor.red.demoImage, dark: UIColor.green.demoImage)
    return imageView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor(.dm, light: .white, dark: .black)

    view.addSubview(imageView)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    imageView.sizeToFit()
    imageView.center = view.center
  }
}
