//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

extension UIImageView {

  private struct Constants {
    static var dynamicImageKey = "dynamicImageKey"
  }

  var dm_dynamicImage: UIImage? {
    get { return objc_getAssociatedObject(self, &Constants.dynamicImageKey) as? UIImage }
    set { objc_setAssociatedObject(self, &Constants.dynamicImageKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
  }

  static let swizzleSetImageOnce: Void = {
    let selector = #selector(setter: image)
    if !dm_swizzleSelector(selector, with: { container -> Any in
      return { (self: UIImageView, image: UIImage?) -> Void in
        if object_getClass(image) == DMDynamicImageProxy.self {
          self.dm_dynamicImage = image
        }
        else {
          self.dm_dynamicImage = nil
        }
        let oldIMP = unsafeBitCast(container.imp, to: (@convention(c) (UIImageView, Selector, UIImage?) -> Void).self)
        oldIMP(self, selector, image)
      } as @convention(block) (UIImageView, UIImage?) -> Void
    }) {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UIImageView.self, selector: selector))
    }
  }()

  static let swizzleInitImageOnce: Void = {
    let selector = #selector(UIImageView.init(image:))
    if !dm_swizzleSelector(selector, with: { container -> Any in
      return { (self: UIImageView, image: UIImage?) -> UIImageView in
        if object_getClass(image) == DMDynamicImageProxy.self {
          self.dm_dynamicImage = image
        }
        let oldIMP = unsafeBitCast(container.imp, to: (@convention(c) (UIImageView, Selector, UIImage?) -> UIImageView).self)
        return oldIMP(self, selector, image)
      } as @convention(block) (UIImageView, UIImage?) -> UIImageView
    }) {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UIImageView.self, selector: selector))
    }
  }()

  override func dm_updateDynamicImages() {
    super.dm_updateDynamicImages()

    if let dynamicImage = dm_dynamicImage {
      image = dynamicImage
    }
  }
}
