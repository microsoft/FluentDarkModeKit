//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

extension UITabBar {
  override open func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    super.dmTraitCollectionDidChange(previousTraitCollection)

    if #available(iOS 13.0, *) {
      return
    }

    items?.forEach { $0.dmTraitCollectionDidChange(previousTraitCollection) }
    items?.forEach { $0._updateDynamicImages() }
  }
}

extension UITabBarItem: DMTraitEnvironment {

  private struct Constants {
    static var UIImageKey = "UIImageKey"
    static var dynamicSelectedImageKey = "dynamicSelectedImageKey"
  }

  var dm_dynamicImage: UIImage? {
    get { return objc_getAssociatedObject(self, &Constants.UIImageKey) as? UIImage }
    set { objc_setAssociatedObject(self, &Constants.UIImageKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
  }

  var dm_dynamicSelectedImage: UIImage? {
    get { return objc_getAssociatedObject(self, &Constants.dynamicSelectedImageKey) as? UIImage }
    set { objc_setAssociatedObject(self, &Constants.dynamicSelectedImageKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
  }

  static let swizzleSetImageOnce: Void = {
    let selector = #selector(setter: image)
    guard let method = class_getInstanceMethod(UITabBarItem.self, selector) else {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UITabBarItem.self, selector: selector))
      return
    }

    let imp = method_getImplementation(method)
    class_replaceMethod(UITabBarItem.self, selector, imp_implementationWithBlock({ (self: UITabBarItem, image: UIImage?) -> Void in
      if object_getClass(image) == DMDynamicImageProxy.self {
        self.dm_dynamicImage = image
      }
      else {
        self.dm_dynamicImage = nil
      }
      let oldIMP = unsafeBitCast(imp, to: (@convention(c) (UITabBarItem, Selector, UIImage?) -> Void).self)
      oldIMP(self, selector, image)
    } as @convention(block) (UITabBarItem, UIImage?) -> Void), method_getTypeEncoding(method))
  }()

  static let swizzleSetSelectedImageOnce: Void = {
    let selector = #selector(setter: selectedImage)
    guard let method = class_getInstanceMethod(UITabBarItem.self, selector) else {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UITabBarItem.self, selector: selector))
      return
    }

    let imp = method_getImplementation(method)
    class_replaceMethod(UITabBarItem.self, selector, imp_implementationWithBlock({ (self: UITabBarItem, image: UIImage?) -> Void in
      if object_getClass(image) == DMDynamicImageProxy.self {
        self.dm_dynamicSelectedImage = image
      }
      else {
        self.dm_dynamicSelectedImage = nil
      }
      let oldIMP = unsafeBitCast(imp, to: (@convention(c) (UITabBarItem, Selector, UIImage?) -> Void).self)
      oldIMP(self, selector, image)
    } as @convention(block) (UITabBarItem, UIImage?) -> Void), method_getTypeEncoding(method))
  }()

  open func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    // For subclasses to override
  }

  fileprivate func _updateDynamicImages() {
    if let dynamicImage = dm_dynamicImage {
      image = dynamicImage
    }

    if let dynamicImage = dm_dynamicSelectedImage {
      selectedImage = dynamicImage
    }
  }

}
