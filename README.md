# DarkModeKit

![](https://github.com/microsoft/DarkModeKit/workflows/CI/badge.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

DarkModeKit was designed and developed before Apple‘s official dark mode release. It provides a mechanism to support dark mode for apps on iOS 11+ (including iOS 13).

## Features

- [x] Dark Mode support for iOS 11+
- [x] Dynamic theme change within the app without restart
- [x] Simple API design with minimal changes to your existing code

## Installation

### Requirements

- iOS 11.0+
- Xcode 11.0+
- Swift 5+

### Carthage

To integrate DarkModeKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```sh
github "microsoft/DarkModeKit"
```

### Swift Package Manager

Click "Files -> Swift Package Manager -> Add Package Dependency..." in Xcode's menu and search "https://github.com/microsoft/DarkModeKit"

### CocoaPods

To integrate DarkModeKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```sh
pod "DarkModeKit"
```

## Get Started

### How to Use DarkModeKit

To use DarkModeKit, provide a pair of colors or images instead of a single value. Simply replace existing colors/images with a pair of light and dark colors/images.

#### Colors

Swift
```swift
extension UIColor {
    init(_: DMNamespace, light: UIColor, dark: UIColor)
}

let color = UIColor(.dm, light: .white, dark: .black)
```

Objective-C
```objc
@interface UIColor (DarkModeKit)
- (UIColor *)dm_colorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;
@end

UIColor *color = [UIColor dm_colorWithLightColor:UIColor.whiteColor darkColor:UIColor.blackColor];
```

#### Images

Swift
```swift
extension UIImage {
    init(_: DMNamespace, light: UIImage, dark: UIImage)
}

let lightImage = UIImage(named: "Light")!
let darkImage = UIImage(named: "Dark")!
let image = UIImage(.dm, light: lightImage, dark: darkImage)
```

Objective-C
```objc
@interface UIImage (DarkModeKit)
- (UIImage *)dm_imageWithLightImage:(UIImage *)lightImage darkImage:(UIImage *)darkImage;
@end
```

### Others

For more complex scenarios, DarkModeKit is similar to what Apple does in iOS 13 (some slight differences). It maintains a global `DMTraitCollection` which can be accessed through `DMTraitCollection.current` during custom layout. 

For more information on cases you should handle during layout, please refer to [Apple's documentation](https://developer.apple.com/documentation/xcode/supporting_dark_mode_in_your_interface#2993898).

DarkModeKit will notify views or view controllers in the current window when the theme changes by calling the following delegate method. 

Swift
```swift
protocol DMTraitEnvironment: NSObjectProtocol {
    func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?)
}
```

Objective-C
```objc
@protocol DMTraitEnvironment <NSObject>

- (void)dmTraitCollectionDidChange:(nullable DMTraitCollection *)previousTraitCollection;

@end
```

## Contributing

This project welcomes contributions and suggestions. Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## License

Copyright (c) Microsoft Corporation. All rights reserved.

Licensed under the [MIT](LICENSE) license.
