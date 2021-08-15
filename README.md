![iOS Version](https://img.shields.io/badge/iOS-13.0+-brightgreen) ![macOS Version](https://img.shields.io/badge/macOS-10.15%2B-brightgreen) [![Build Status](https://travis-ci.com/indieSoftware/NavigationStack.svg?branch=master)](https://travis-ci.com/indieSoftware/NavigationStack)
[![Code Coverage](https://codecov.io/gh/indieSoftware/NavigationStack/branch/master/graph/badge.svg)](https://codecov.io/gh/indieSoftware/NavigationStack)
[![Documentation Coverage](https://indiesoftware.github.io/NavigationStack/badge.svg)](https://indiesoftware.github.io/NavigationStack)
[![License](https://img.shields.io/github/license/indieSoftware/NavigationStack)](https://github.com/indieSoftware/NavigationStack/blob/master/LICENSE)
[![GitHub Tag](https://img.shields.io/github/v/tag/indieSoftware/NavigationStack?label=version)](https://github.com/indieSoftware/NavigationStack)
[![CocoaPods](https://img.shields.io/cocoapods/v/NavStack.svg)](https://cocoapods.org/pods/NavStack)
[![carthage compatible](https://img.shields.io/badge/carthage-compatible-success.svg)](https://github.com/Carthage/Carthage)
[![SPM compatible](https://img.shields.io/badge/SPM-compatible-success.svg)](https://github.com/apple/swift-package-manager)

[GitHub Page](https://github.com/indieSoftware/NavigationStack)

[Documentation](https://indiesoftware.github.io/NavigationStack)

# NavigationStack for SwiftUI

NavigationStack is a custom SwiftUI solution for navigating between views. It's a more flexible alternative to SwiftUI's own navigation.

## Advantages 

Advantages of this lib compared to SwiftUI's `NavigationView` / `NavigationLink` and the `.sheet`-Modifier:

- Use different transition animations (not only a horizontal push/pop or a vertical present/dismiss)
- Use one of the various transition animations included
- Or create your own custom transition animations
- Navigate even without any transition animation at all if you want
- Define the back transition animation right before transitioning back, not in advance when transitioning forward
- Navigate back multiple screens at once, not only to the previous one
- Use a full-screen present transition also on iOS 13 and macOS 10.15
- Get notified when the transition animation has finished

### Transition Examples

Use SwiftUI's default transitions:

![SwiftUI transitions](https://github.com/indieSoftware/NavigationStack/blob/master/img/swiftuiTransitions.gif?raw=true)

Or use some default view animations for transitioning:

![animation transitions](https://github.com/indieSoftware/NavigationStack/blob/master/img/animationTransitions.gif?raw=true)

Or write your own custom transitions:

![custom transitions](https://github.com/indieSoftware/NavigationStack/blob/master/img/customTransitions.gif?raw=true)

All of these are included in this lib!

## Installation

### CocoaPods

To include via [CocoaPods](https://cocoapods.org) add to the `Podfile`:

```
pod 'NavStack'
```

### Carthage

To include via [Carthage](https://github.com/Carthage/Carthage) add to the `Cartfile`:

```
github "indieSoftware/NavigationStack"
```

### SPM

To include via [SwiftPackageManager](https://swift.org/package-manager) add the repository:

```
https://github.com/indieSoftware/NavigationStack.git
```

## Usage

1. Import the lib to your view's source file.
2. Include the `NavigationModel` to your view as an environment object.
3. Use the `NavigationStackView` as a root stack view of your view and give it a unique name to reference it.
4. Use the `NavigationModel` object to perform any transitions, i.e. a push or pop. Provide the `NavigationStackView`'s identifier to define which `NavigationStackView` in the hierachy should switch its content.

	```
	import NavigationStack // 1

	struct MyRootView: View {
		@EnvironmentObject var navigationModel: NavigationModel // 2

		var body: some View {
			NavigationStackView("MyRootView") { // 3
				Button(action: {
					navigationModel.pushContent("MyRootView") { // 4
						MyDetailView()
					}
				}, label: {
					Text("Push MyDetailView")
				})
			}
		}
	}
	```

5. Because of the reference to the `NavigationModel` instance you need of couse to attach one as an environement object to the view hierachy, e.g. in the `SceneDelegate`:

	```
	func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
		if let windowScene = scene as? UIWindowScene {
			let window = UIWindow(windowScene: windowScene)
			let myRootView = MyRootView()
				.environmentObject(NavigationModel()) // 5
			window.rootViewController = UIHostingController(rootView: myRootView)
			self.window = window
			window.makeKeyAndVisible()
		}
	}
	```

That's all what's needed!

## Additional Information

### The `NavigationStackView`'s Identifier

Every view which should provide a possibility to transition to a different view needs to contain a `NavigationStackView` with a unique identifier.

When a view where you navigated to now wants to navigate back to a specific view, just tell the `NavigationModel` to which one to navigate back:

```
import NavigationStack

struct MyDetailView: View {
	@EnvironmentObject var navigationModel: NavigationModel

	var body: some View {
		Button(action: {
			navigationModel.popContent("MyRootView")
		}, label: {
			Text("Pop to root")
		})
	}
}
```

With the `NavigationStackView`'s reference identifier you can also navigate back multiple screens at once, just provide the ID of one screen further down the hierarchy.

To avoid hard-coded strings for the `NavigationStackView` IDs, just define a static constant in each view which then can be referenced instead.

```
struct ContentView1: View {
	static let id = String(describing: Self.self)
	@EnvironmentObject var navigationModel: NavigationModel

	var body: some View {
		NavigationStackView(ContentView1.id) {
			Button(action: {
				navigationModel.pushContent(ContentView1.id) {
					ContentView2()
				}
			}, label: {
				Text("Push ContentView2")
			})
		}
	}
}	
```

### Convenience Navigation Methods

You can also use one of the other model methods which might suit your current situation better, e.g. `hideTopViewWithReverseAnimation()` to just transition back to the previous screen with the reverse-animation provided when transitioning to the screen. 

There are some convenience methods to express specific transitions more appropriate, e.g. `pushContent`, `popContent`, `presentContent` and `dismissContent`. Just look at the documentation for the [NavigationModel](https://indiesoftware.github.io/NavigationStack/Classes/NavigationStackModel.html).

### Transition Animations

The convenience navigation methods all rely on the `showView(_ identifier:, animation:, alternativeView:)` and `hideView(_ identifier:, animation:)` methods which take an animation as argument. The convenience methods use pre-defined navigation animations (e.g. `NavigationAnimation`'s `push`, `pop`, `present` and `dismiss`). However, you can also create your own transition animations by providing different parameters for the animation curve and the transition types. Then you can use the show and hide methods to create transitions with your own animations:


```
let myAnimation = NavigationAnimation(
	animation: .easeOut,
	defaultViewTransition: .static,
	alternativeViewTransition: .brightness()
)
navigationModel.hideView("MyRootView", animation: myAnimation)
```

With "defaultView" the source view is meant, which is the one from which to navigate while "alternativeView" means the destination view, the one where to navigate to. By providing different transitions for both views it's possible to define one transition animation for the leaving view and a different one for the appearing view.

**Important:**
For views which shouldn't animate during a transition, e.g. staying statically visible while the other view does its animation, you have to provide a `.static` transition rather than SwiftUI's `.identity`.

A list of all provided transitions by the lib can be found in the lib's documentation for [AnyTransition Extensions](https://indiesoftware.github.io/NavigationStack/Extensions/AnyTransition.html).

### Custom Transitions

To create own transition animations simply create a custom `ViewModifier` and optionally extend `AnyTransition` for creating a convenience method:

```
public struct BrightnessModifier: ViewModifier {
	public let amount: Double
	public func body(content: Content) -> some View {
		content.brightness(amount)
	}
}

public extension AnyTransition {
	static func brightness(_ amount: Double = 1) -> AnyTransition {
		.modifier(active: BrightnessModifier(amount: amount), identity: BrightnessModifier(amount: 0))
	}
}
```

**Important**
Please keep in mind that SwiftUI will only animate transitions if a value changes, e.g. when providing a brightness transition with a brighness value of 0 you won't see any animation and the transition for that view gets skipped. That's because the identity has also a brightness value of 0 and thus both states, the identity and the active state, are equal.

For further information, please look at the lib's API documentation: [https://indiesoftware.github.io/NavigationStack](https://indiesoftware.github.io/NavigationStack)

### OnDidAppear

To get informed when a transition animation for a view has completed use the `onDidAppear` modifier. However, this only works when there is really an animation executed with the transition and when showing and hiding views via the `NavigationModel`, not via SwiftUI's `NavigationView/Link`.

```
struct ContentView1: View {
	static let id = String(describing: Self.self)
	@EnvironmentObject var navigationModel: NavigationModel

	var body: some View {
		NavigationStackView(ContentView1.id) {
			Button(action: {
				navigationModel.pushContent(ContentView1.id) {
					ContentView2()
						.onDidAppear {
							print("ContentView2 did appear")
						}
				}
			}, label: {
				Text("Push ContentView2")
			})
			.onDidAppear {
				print("ContentView1 did appear")
			}
		}
	}
}
```

**Don't use `onAppear` because that won't work anymore as expected.** See the chapter "known limitations" at the bottom for more information.

To get generally informed when an animation has finished use the `onAnimationCompleted` modifier. This works independently from the `NavigationModel` and the lib's transitions, but you have to execute `withAnimation` by yourself and thus is not usable with the `NavigationModel`'s transitions.

See [View Extensions](https://indiesoftware.github.io/NavigationStack/Extensions/View.html) for more information.

### Example Code

The project includes an example target (`NavigationStackExample`) which shows how to use the library. Just clone the repo, open the workspace and switch to the same named scheme. The example app shows how to push multiple views, how to pop back even directly to the root, how to simulate a modal presentation and shows the different transition animations available out-of-the-box. The example views are well commented and provided in the `Sources/NavigationStackExample/ExampleViews` group.

You can also run the example's UI tests to run sepcific or all transitions automatically.

The example project includes some experiments where each describes a problem or the attempt to solve a problem. They are kind of a documentation how to solve some strange behaviors of SwiftUI. They are not important for users of the library, but maybe for those who want to understand and improve it. So, feel free to skip these. However, to run the experiments simply pass the experiment's name in the scheme as launch agrument, i.e. "Experiment1" to run `Experiment1.swift`.

## Known limitations

### Manual full-screen

`NavigationStackView` is just another stack view. What you put into this stack view is up to you, however, you should make the content fill out the whole screen. Otherwise you might risk to trigger sub-view transitions, but even if not so it might look kind of awkward when the screen's transition is not full-screen.

### No sub-view transitions

Technically you are not forced to add the `NavigationStackView` to the root level of your view's body. Even when added to the root of your custom view you might also add this custom view as a sub-view to a bigger view. This is actually unproblematic as long as the views are full-screen.

However, when the views to navigate to are not full-screen the user might transition from one screen which already has transitioned to a different view. And that might lead to problems, because the lib uses a linear stack to keep the navigation transitions. When trying to branch off from the middle of the stack then this won't work as expected.

There is a `SubviewExample` in the examples and a `SubviewExampleTests` to show this problem.

### No real modal

SwiftUI's `sheet` modifier actually triggers a real modal transition. This lib doesn't do this, instead the `NavigationStackView` relies on a single-page architecture, meaning there is always only a single view visible, but its content will be replaced when transitioning. I'm not sure if this is really a limitation but it's something to keep in mind.

### OnAppear doesn't work

For all views managed by the `NavigationStackView` the SwiftUI's view modifier `onAppear` doesn't work anymore as expected. `onAppear` now will be triggered multiple times and even when the view is not appearing, but disappearing. This is because of how `NavigationStackView` internally exchanges the subviews. Therefore, don't use `onAppear` anymore, however, this modifier shouldn't be necessary anymore because you can call the code in `onAppear` directly when you also call `show` on the `NavigationModel`.

## Trouble shooting

### ObservableObject not injected

**Fatal error: No ObservableObject of type NavigationModel found. A View.environmentObject(_:) for NavigationModel may be missing as an ancestor of this view.**

Add a navigation model to the view hierarchy, e.g.  `MyRootView().environmentObject(NavigationModel())`.

### View replacement not supported

**Replacing showing navigation view 'XXX' not allowed**

This error is thrown when trying to replace a current detail view with another detail view without first navigating back. Let's say you have an overview A and you are navigating to a detail view B and from detail view B you now try to replace view B with view C by telling view A to navigate to view C while it still shows view B. That doesn't work and leads to that exception. 

Normally you want to navigate from view B to view C therefore you should tell view B rather than view A to show view C. That would then lead to a view hierarchy A-B-C. 

If you really want to end with a view hierarchy like A-C then you have first to tell view A to dismiss view B before telling it to show view C.

## Changelog

See [Changelog.md](Changelog.md) 
