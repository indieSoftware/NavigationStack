import Combine
import SwiftUI

/**
 The underlying `NavigationStackView`s model which can be manipulated to apply the navigation transitions.

 An instance of this model has to be injected into the view hierarchy as an environment object:
 `MyRootView().environmentObject(NavigationModel())`
 Even when using multiple navigation stack views in a view hierarchy there has to be always only one instance of `NavigationModel`.
 The model can be used with names/IDs to target specific navigation stack views.
 */
public class NavigationModel: ObservableObject {
	/// Flag used to determine if errors are thrown or silently ignored.
	public let silenceErrors: Bool

	/// The node list used as stack of navigation steps. Logically each navigation enques a new node and each back-navigation removes one.
	@Published private var navigationStackNode: NavigationStackNode? {
		didSet {
			// Propagates any published state changes from the node to observers of this node and not only whether the node has been set or deleted.
			navigationStackNodeChangeCanceller = navigationStackNode?.objectWillChange.sink(receiveValue: { [weak self] _ in
				self?.objectWillChange.send()
			})
		}
	}

	private var navigationStackNodeChangeCanceller: AnyCancellable?

	/**
	 Initializes the model.

	 - parameter silenceErrors: When set to true each error will be silently ignored, when false each error will result in an exception thrown.
	 Defaults to false.
	 */
	public init(silenceErrors: Bool = false) {
		self.silenceErrors = silenceErrors
	}

	/**
	 Performs the navigation by showing a new view.

	 This is typically used to navigate to a new view.

	 - Warning: It's not possible to navigate to a new view while a navigation for the same stack view is already active,
	 i.e. tying to push View3 on View1 when there is already View2 pushed on View1 will result in an error.

	 - parameter name: The navigation stack view's name targeting by this navigation.
	 The provided name will be used to determine which navigation stack view should replace its view with the provided one.
	 - parameter animation: The transition animation to apply.
	 - parameter alternativeView: The new view which should replace the navigation stack view's default view.
	 */
	public func showView<Content: View>(_ name: String, animation: NavigationAnimation? = nil, @ViewBuilder alternativeView: @escaping () -> Content) {
		let viewBuilder: AnyViewBuilder = { AnyView(alternativeView()) }

		let newNode = NavigationStackNode(name: name, alternativeView: viewBuilder)
		newNode.transitionAnimation = animation
		enqueueNewNode(newNode)

		showAlternativeViewForNode(newNode)
	}

	/**
	 Enqueues a new node which represents a new navigation in the view hierarchy.

	 Replacing an active navigation node with a new navigation node will result in an error.

	 - parameter newNode: The node to add to the stack.
	 */
	private func enqueueNewNode(_ newNode: NavigationStackNode) {
		cleanupNodeList()

		if let navigationStackNode = navigationStackNode, navigationStackNode.getNode(named: newNode.name) != nil {
			if silenceErrors { return }
			fatalError("Replacing showing navigation view '\(newNode.name)' not allowed")
		} else if let navigationStackNode = navigationStackNode, let leafNode = navigationStackNode.getLeafNode() {
			leafNode.nextNode = newNode
		} else {
			navigationStackNode = newNode
		}
	}

	/**
	 Activates the alternative view for a navigation stack view.

	 - parameter node: The stack view's node on which to activate the navigation.
	 */
	private func showAlternativeViewForNode(_ node: NavigationStackNode) {
		node.isAlternativeViewShowingPrecede = true // Necessary, see Experiment7

		if let transitionAnimation = node.transitionAnimation {
			withAnimation(transitionAnimation.animation) {
				node.isAlternativeViewShowing = true
			}
		} else {
			node.isAlternativeViewShowing = true
		}
	}

	/**
	 Truncates the nextNode queue of the leaf node which is currently active.

	 - Remark: This cannot be called in `resetContent(:animation:)` after `withAnimation` because that will lead to animation glitches.
	 */
	private func cleanupNodeList() {
		guard let navigationStackNode = navigationStackNode else { return }

		if !navigationStackNode.isAlternativeViewShowing {
			self.navigationStackNode = nil
		} else if let leafNode = navigationStackNode.getLeafNode() {
			leafNode.nextNode = nil
		}
	}

	/**
	 Navigates back to the previews view by using its reverse animation.
	 This is typically used to execute a back navigation.
	 */
	public func hideTopViewWithReverseAnimation() {
		guard let navigationStackNode = navigationStackNode, let leafNode = navigationStackNode.getLeafNode() else {
			if silenceErrors { return }
			fatalError("No top navigation view available on the stack to reset")
		}

		hideAlternativeViewForNode(leafNode)
	}

	/**
	 Navigates back to the previous view by using a provided a specific transition animation.
	 This is typically used to navigate back, but with a specific animation which might not be known in advance.

	 - parameter animation: The transition animation to use for this navigation. When nil is passed then no animation will be used.
	 */
	public func hideTopView(animation: NavigationAnimation? = nil) {
		guard let navigationStackNode = navigationStackNode, let leafNode = navigationStackNode.getLeafNode() else {
			if silenceErrors { return }
			fatalError("No top navigation view available on the stack to reset")
		}

		leafNode.transitionAnimation = animation
		hideAlternativeViewForNode(leafNode)
	}

	/**
	 Navigates back to a specific navigation stack view somewhere in the stack.
	 This is typically used to navigate back multiple views.

	 - parameter name: The navigation stack view's name targeting by this navigation.
	 The provided name will be used to determine which navigation stack view should switch back to its default view.
	 - parameter animation: The transition animation to use during this transition. When nil is passed then no animation will be used.
	 */
	public func hideView(_ name: String, animation: NavigationAnimation? = nil) {
		guard let navigationStackNode = navigationStackNode, let node = navigationStackNode.getNode(named: name) else {
			if silenceErrors { return }
			fatalError("No navigation view with name '\(name)' available on the stack to reset")
		}

		node.transitionAnimation = animation
		hideAlternativeViewForNode(node)
	}

	/**
	 Navigates back to a specific navigation stack view somewhere in the stack by using its reverse animation.
	 This is typically used to execute a back navigation to a view farther down the stack, e.g. back to the root.

	 - parameter name: The navigation stack view's name targeting by this navigation.
	 The provided name will be used to determine which navigation stack view should switch back to its default view.
	 */
	public func hideViewWithReverseAnimation(_ name: String) {
		guard let navigationStackNode = navigationStackNode, let node = navigationStackNode.getNode(named: name) else {
			if silenceErrors { return }
			fatalError("No navigation view with name '\(name)' available on the stack to reset")
		}

		hideAlternativeViewForNode(node)
	}

	/**
	 Deactivates the alternative view for a navigation stack view.

	 - parameter node: The stack view's node on which to deactivate the navigation.
	 */
	private func hideAlternativeViewForNode(_ node: NavigationStackNode) {
		node.isAlternativeViewShowingPrecede = false // Necessary, see Experiment7

		if let transitionAnimation = node.transitionAnimation {
			withAnimation(transitionAnimation.animation) {
				node.isAlternativeViewShowing = false
			}
		} else {
			node.isAlternativeViewShowing = false
		}
	}

	/**
	 Returns whether there is a navigation view on the stack or not, meaning is it possible to navigate back or not.

	 True when it's safe to navigate back, otherwise false.

	 - Warning: Using this method to show different views or sub-views without freezing the result in a `let` variable will result in animation glitches!
	 */
	public var hasAlternativeViewShowing: Bool {
		navigationStackNode?.getLeafNode() != nil
	}

	/**
	 Returns whether there is a navigation view with a specific name on the stack or not,
	 meaning is it possible to navigate to the named navigation stack view or not.

	 True when it's safe to navigate to the name, otherwise false.

	 - Warning: Using this method to show different views or sub-views without freezing the result in a `let` variable will result in animation glitches!
	 */
	public func isAlternativeViewShowing(_ name: String) -> Bool {
		guard let node = navigationStackNode?.getNode(named: name) else {
			return false
		}

		return node.isAlternativeViewShowing
	}

	/**
	 Creates and returns a binding for the top navigation stack view's showing flag.

	 This binding can be used to pass it to the new view shown by the navigation so the new view can dismiss itself by toggling the binding's value.

	 - returns: The binding bound to the top view on the navigation stack.
	 */
	public func topViewShowingBinding() -> Binding<Bool> {
		guard let navigationStackNode = navigationStackNode, let leafNode = navigationStackNode.getLeafNode() else {
			if silenceErrors { return .constant(false) }
			fatalError("No top navigation view available on the stack for binding")
		}

		return createBindingForNode(leafNode)
	}

	/**
	 Creates and returns a binding for a named navigation stack view's showing flag.

	 - returns: The binding bound to the named view on the navigation stack.
	 */
	public func viewShowingBinding(_ name: String) -> Binding<Bool> {
		guard let navigationStackNode = navigationStackNode, let node = navigationStackNode.getNode(named: name) else {
			if silenceErrors { return .constant(false) }
			fatalError("No navigation view with name '\(name)' available on the stack for binding")
		}

		return createBindingForNode(node)
	}

	/**
	 Creates the navigation binding instance for a given node.

	 - parameter node: The navigation stack view's node for which to create the binding.
	 - returns: The created binding ready to pass to a SwiftUI view.
	 */
	private func createBindingForNode(_ node: NavigationStackNode) -> Binding<Bool> {
		Binding<Bool>(
			get: {
				node.isAlternativeViewShowing
			},
			set: { presenting in
				// This is an one-way toggle, meaning it can be set to false, but not back to true.
				if !presenting {
					node.isAlternativeViewShowingPrecede = false // Keep this in sync with the showing flag.
					node.isAlternativeViewShowing = false
				}
			}
		)
	}
}

// MARK: - Used by the NavigationStackView

extension NavigationModel {
	/**
	 Returns the safe state of whether a navigation switch has been applied.

	 - parameter name: The navigation stack view's ID.
	 - returns: True if the alternative view is showing, otherwise false.
	 */
	func isAlternativeViewShowingPrecede(_ name: String) -> Bool {
		guard let node = navigationStackNode?.getNode(named: name) else {
			return false
		}

		return node.isAlternativeViewShowingPrecede
	}

	/**
	 Returns the alternative view for a given navigation's name / ID.

	 - parameter name: The navigation stack view's ID.
	 - returns: The content view if any.
	 */
	func alternativeView(_ name: String) -> AnyViewBuilder? {
		navigationStackNode?.getNode(named: name)?.alternativeView
	}

	/**
	 The transition for the default content view.

	 - parameter name: The navigation stack view's ID.
	 - returns: The transition.
	 */
	func defaultViewTransition(_ name: String) -> AnyTransition {
		navigationStackNode?.getNode(named: name)?.transitionAnimation?.defaultViewTransition ?? .identity
	}

	/**
	 The transition for the alternative view.

	 - parameter name: The navigation stack view's ID.
	 - returns: The transition.
	 */
	func alternativeViewTransition(_ name: String) -> AnyTransition {
		navigationStackNode?.getNode(named: name)?.transitionAnimation?.alternativeViewTransition ?? .identity
	}

	/**
	 The default view's z-index during a transition.

	 - parameter name: The navigation stack view's ID.
	 - returns: The z-index to apply.
	 */
	func defaultViewZIndex(_ name: String) -> Double {
		navigationStackNode?.getNode(named: name)?.transitionAnimation?.defaultViewZIndex ?? .zero
	}

	/**
	 The alternative view's z-index during a transition.

	 - parameter name: The navigation stack view's ID.
	 - returns: The z-index to apply.
	 */
	func alternativeViewZIndex(_ name: String) -> Double {
		navigationStackNode?.getNode(named: name)?.transitionAnimation?.alternativeViewZIndex ?? .zero
	}
}
