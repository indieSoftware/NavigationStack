import SwiftUI

public extension View {
	/**
	 Calls the action when the given view has fully transitioned in.
	 The action will be performed after the transition animation has finished, but will only be performed when the transition is animated.

	 - parameter action: The action to perform after the animation has finished.
	 - returns: The modified view with the applied modifier.
	 */
	func onDidAppear(_ action: @escaping NavigationViewLifecycleAction) -> some View {
		preference(key: OnDidAppearPreferenceKey.self, value: NavigationViewLifecycleActionWrapper(action: action))
	}
}

/// A preference key for passing an action for `onDidAppear` upwards the view hierarchy.
struct OnDidAppearPreferenceKey: PreferenceKey {
	static var defaultValue = NavigationViewLifecycleActionWrapper {}

	static func reduce(value: inout NavigationViewLifecycleActionWrapper, nextValue: () -> NavigationViewLifecycleActionWrapper) {
		value = nextValue()
	}
}
