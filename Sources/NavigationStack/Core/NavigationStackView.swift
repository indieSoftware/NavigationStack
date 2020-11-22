import SwiftUI

/// The navigation view used to switch content when applying a navigation transition.
///
/// This view works similar to SwiftUI's `NavigationView`.
/// Place it as the view's root and provide the default content to show when no navigation transition has been applied.
/// Use the `NavigationModel` to provide a destination view and transition animation to navigate to.
///
/// - Important:
/// An single instance of the `NavigationModel` has to be injected into the view hierarchy as an environment object:
/// `MyRootView().environmentObject(NavigationModel())`
public struct NavigationStackView: View {
	@EnvironmentObject private var model: NavigationModel

	/// This navigation stack view's name which works as an ID in the stack.
	let name: String
	/// The navigation stack view's default content to show when no navigation has been applied.
	private let defaultView: AnyViewBuilder

	/**
	 Initializes the navigation stack view with a given name and its default content.

	 - parameter name: The navigation stack view's name which works as its ID in the stack.
	 This is the reference name to use when applying a navigation via the model and targeting this layer of stack.
	 - parameter defaultView: The content view to show when no navigation has been applied.
	 */
	public init<Content>(_ name: String, @ViewBuilder defaultView: @escaping () -> Content) where Content: View {
		self.name = name
		self.defaultView = { AnyView(defaultView()) }
	}

	public var body: some View {
		ZStack {
			if model.isAlternativeViewShowingPrecede(name) { // `if-else` and the precede-call are necessary, see Experiment8
				ContentViews(name: name, defaultView: defaultView)
			} else {
				ContentViews(name: name, defaultView: defaultView)
			}
		}
	}
}

private struct ContentViews: View {
	@EnvironmentObject private var model: NavigationModel

	/// This navigation stack view's name.
	let name: String
	/// The navigation stack view's default content.
	let defaultView: AnyViewBuilder

	var body: some View {
		ZStack {
			if !model.isAlternativeViewShowing(name) {
				defaultView().transition(model.defaultViewTransition(name)).zIndex(model.defaultViewZIndex(name))
			} // No `else`, see Experiment2
			if model.isAlternativeViewShowing(name), let alternativeView = model.alternativeView(name) {
				alternativeView().transition(model.alternativeViewTransition(name)).zIndex(model.alternativeViewZIndex(name))
			}
		}
	}
}
