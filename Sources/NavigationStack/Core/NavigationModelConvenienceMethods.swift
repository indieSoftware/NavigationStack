import SwiftUI

public extension NavigationModel {
	/**
	 A convenience method to navigate to a new view with a push transition animation.

	 - parameter name: The navigation stack view's name on which to push.
	 - parameter alternativeView: The content view to push.
	 */
	func pushContent<Content: View>(_ name: String, @ViewBuilder alternativeView: @escaping () -> Content) {
		showView(name, animation: .push, alternativeView: alternativeView)
	}

	/**
	 A convenience method to navigate back to a previous view with a pop transition animation.

	 - parameter name: The navigation stack view's name on which to pop back.
	 */
	func popContent(_ name: String) {
		hideView(name, animation: .pop)
	}

	/**
	 A convenience method to navigate to a new view with a present transition animation.

	 - parameter name: The navigation stack view's name on which to present.
	 - parameter alternativeView: The content view to present.
	 */
	func presentContent<Content: View>(_ name: String, @ViewBuilder alternativeView: @escaping () -> Content) {
		showView(name, animation: .present, alternativeView: alternativeView)
	}

	/**
	 A convenience method to navigate back to a previous view with a dismiss transition animation.

	 - parameter name: The navigation stack view's name on which to dismiss.
	 */
	func dismissContent(_ name: String) {
		hideView(name, animation: .dismiss)
	}

	/**
	 A convenience method to navigate to a new view with a fade-in transition animation.

	 - parameter name: The navigation stack view's name on which to fade-in.
	 - parameter alternativeView: The content view to fade-in.
	 */
	func fadeInContent<Content: View>(_ name: String, @ViewBuilder alternativeView: @escaping () -> Content) {
		showView(name, animation: .fade, alternativeView: alternativeView)
	}

	/**
	 A convenience method to navigate back to a previous view with a fade-out transition animation.

	 - parameter name: The navigation stack view's name on which to fade-out.
	 */
	func fadeOutContent(_ name: String) {
		hideView(name, animation: .fade)
	}
}
