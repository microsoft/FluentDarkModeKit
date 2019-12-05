# DarkModeKit

![](https://github.com/microsoft/DarkModeKit/workflows/CI/badge.svg)

DarkModeKit was designed and developed before Apple‘s dark mode official release, so it provides your apps the ability to support dark mode for iOS 11+ (including iOS 13).

## Features

- [x] Dark Mode support for iOS 11+
- [x] Dynamic theme change within the app without restart
- [x] Simple API design. Limited changes to your existing code.

## Installation

### Requirements

- iOS 11.0+
- Xcode 11.0+
- Swift 5+

### Swift Package Manager

Click "Files -> Swift Package Manager -> Add Package Dependency..." in Xcode's menu and search "https://github.com/microsoft/DarkModeKit"

### Carthage

To integrate DarkModeKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```
github "microsoft/DarkModeKit" ~> 0.1.0
```

## Get Started

### How to Use DarkModeKit

The basic idea for adopting DarkModeKit is to provide a pair of colors or images instead of a single value. Simply replace existing colors/images with a pair of light and dark colors/images.

#### Colors

Swift
```swift
UIColor(.dm, light: UIColor, dark: UIColor)
```

Objective-C
```objc
[UIColor dm_colorWithLightColor:darkColor:]
```

#### Images

Swift
```swift
UIImage(.dm, light: UIImage, dark: UIImage)
```

Objective-C
```objc
[UIImage dm_imageWithLightImage:darkImage:]
```

### Others

For more complex scenarios, DarkModeKit will notify views or view controllers when current theme changes. The views and view controllers have to be in window hierarchy and conform to `DMTraitEnvironment` protocol.

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
