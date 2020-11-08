![iOS Version](https://img.shields.io/badge/iOS-13.0+-brightgreen)
[![Build Status](https://travis-ci.com/indieSoftware/NavigationStack.svg?branch=master)](https://travis-ci.com/indieSoftware/NavigationStack)
[![Code Coverage](https://codecov.io/gh/indieSoftware/NavigationStack/branch/master/graph/badge.svg)](https://codecov.io/gh/indieSoftware/NavigationStack)
[![Documentation Coverage](docs/badge.svg)](https://indiesoftware.github.io/NavigationStack)
[![License](https://img.shields.io/github/license/indieSoftware/NavigationStack)](https://github.com/indieSoftware/NavigationStack/blob/master/LICENSE)
[![GitHub Tag](https://img.shields.io/github/v/tag/indieSoftware/NavigationStack?label=version)](https://github.com/indieSoftware/NavigationStack)
[![CocoaPods](https://img.shields.io/cocoapods/v/SwiftUINavigationStack.svg)](https://cocoapods.org/pods/SwiftUINavigationStack)

# NavigationStack for SwiftUI

**Work in progress!**

NavigationStack is a custom SwiftUI solution for navigating between views. It's a more flexible alternative to SwiftUI's own navigation.

## Advantages 
Compared to SwiftUI's `NavigationView` / `NavigationLink` and the `.sheet`-Modifier:

- Use different transition animations (not only a horizontal push/pop or a vertical present/dismiss)
- Use a full-screen present transition also on iOS 13
- Navigate even without any transition animation at all if you want
- Use your own custom transition animations
- Or use one of the various included
- Navigate back multiple screens at once, not only to the previous
- Define the back transition animation right before transitioning back, not when transitioning forward

## Usage

## Documentation

**[https://indiesoftware.github.io/NavigationStack](https://indiesoftware.github.io/NavigationStack)**
