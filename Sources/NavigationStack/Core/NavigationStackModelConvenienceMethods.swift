import SwiftUI

public extension NavigationStackModel {
	/**
	 A convenience method to navigate to a new view with a push transition animation.

	 - parameter identifier: The navigation stack view's ID on which to push.
	 - parameter alternativeView: The content view to push.
	 */
	func pushContent<Content: View>(_ identifier: IdentifierType, @ViewBuilder alternativeView: @escaping () -> Content) {
		showView(identifier, animation: .push, alternativeView: alternativeView)
	}

	/**
	 A convenience method to navigate back to a previous view with a pop transition animation.

	 - parameter identifier: The navigation stack view's ID on which to pop back.
	 */
	func popContent(_ identifier: IdentifierType) {
		hideView(identifier, animation: .pop)
	}

	/**
	 A convenience method to navigate to a new view with a present transition animation.

	 - parameter identifier: The navigation stack view's ID on which to present.
	 - parameter alternativeView: The content view to present.
	 */
	func presentContent<Content: View>(_ identifier: IdentifierType, @ViewBuilder alternativeView: @escaping () -> Content) {
		showView(identifier, animation: .present, alternativeView: alternativeView)
	}

	/**
	 A convenience method to navigate back to a previous view with a dismiss transition animation.

	 - parameter identifier: The navigation stack view's ID on which to dismiss.
	 */
	func dismissContent(_ identifier: IdentifierType) {
		hideView(identifier, animation: .dismiss)
	}

	/**
	 A convenience method to navigate to a new view with a fade-in transition animation.

	 - parameter identifier: The navigation stack view's ID on which to fade-in.
	 - parameter alternativeView: The content view to fade-in.
	 */
	func fadeInContent<Content: View>(_ identifier: IdentifierType, @ViewBuilder alternativeView: @escaping () -> Content) {
		showView(identifier, animation: .fade, alternativeView: alternativeView)
	}

	/**
	 A convenience method to navigate back to a previous view with a fade-out transition animation.

	 - parameter identifier: The navigation stack view's ID on which to fade-out.
	 */
	func fadeOutContent(_ identifier: IdentifierType) {
		hideView(identifier, animation: .fade)
	}
}
