import Combine
import SwiftUI

/**
 The underlying `NavigationStackView`'s model which can be manipulated to apply the navigation transitions.

 This class is generic to provide the possibility to use a different type as identifier.
 However, normally you want to bound the identifier's type simply to a string.
 For this you can also just use `NavigationModel`.

 An instance of this model has to be injected into the view hierarchy as an environment object:
 `MyRootView().environmentObject(NavigationModel())`
 Even when using multiple navigation stack views in a view hierarchy there has to be always only one instance of `NavigationModel`.
 The model can be used with identifiers to target specific navigation stack views.
 */
public class NavigationStackModel<IdentifierType>: ObservableObject where IdentifierType: Equatable {
	/**
	 Initializes the model.

	 - parameter silenceErrors: When set to true each error will be silently ignored, when false each error will result in an exception thrown.
	 Defaults to false.
	 */
	public init(silenceErrors: Bool = false) {
		self.silenceErrors = silenceErrors
	}

	/// Flag used to determine if errors are thrown or silently ignored.
	public let silenceErrors: Bool

	/// The node list used as stack of navigation steps. Logically each navigation enques a new node and each back-navigation removes one.
	@Published var navigationStackNode: NavigationStackNode<IdentifierType>? {
		didSet {
			// Propagates any published state changes from the node to observers of this node and not only whether the node has been set or deleted.
			navigationStackNodeChangeCanceller = navigationStackNode?.objectWillChange.sink(receiveValue: { [weak self] _ in
				self?.objectWillChange.send()
			})
		}
	}

	private var navigationStackNodeChangeCanceller: AnyCancellable?

	/**
	 Performs the navigation by showing a new view.

	 This is typically used to navigate to a new view.

	 - Warning: It's not possible to navigate to a new view while a navigation for the same stack view is already active,
	 i.e. tying to push View3 on View1 when there is already View2 pushed on View1 will result in an error.

	 - parameter identifier: The navigation stack view's identifier targeting by this navigation.
	 The provided ID will be used to determine which navigation stack view should replace its view with the provided one.
	 - parameter animation: The transition animation to apply.
	 - parameter alternativeView: The new view which should replace the navigation stack view's default view.
	 */
	public func showView<Content: View>(
		_ identifier: IdentifierType,
		animation: NavigationAnimation? = nil,
		@ViewBuilder alternativeView: @escaping () -> Content
	) {
		let viewBuilder: AnyViewBuilder = { AnyView(alternativeView()) }

		let newNode = NavigationStackNode(identifier: identifier, alternativeView: viewBuilder)
		newNode.transitionAnimation = animation
		enqueueNewNode(newNode)

		showAlternativeViewForNode(newNode)
	}

	/**
	 Enqueues a new node which represents a new navigation in the view hierarchy.

	 Replacing an active navigation node with a new navigation node will result in an error.

	 - parameter newNode: The node to add to the stack.
	 */
	private func enqueueNewNode(_ newNode: NavigationStackNode<IdentifierType>) {
		cleanupNodeList()

		if let navigationStackNode = navigationStackNode, navigationStackNode.getNode(newNode.identifer) != nil {
			if silenceErrors { return }
			fatalError("Replacing showing navigation view '\(newNode.identifer)' not allowed")
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
	private func showAlternativeViewForNode(_ node: NavigationStackNode<IdentifierType>) {
		node.isAlternativeViewShowingPrecede = true // Necessary, see Experiment7

		if let transitionAnimation = node.transitionAnimation {
			withAnimation(transitionAnimation.animation) {
				node.isAlternativeViewShowing = true
				node.transitionProgress = .progressToAlternativeView
			}
		} else {
			node.isAlternativeViewShowing = true
			node.transitionProgress = .progressToAlternativeView
		}
	}

	/**
	 Truncates the nextNode queue of the leaf node which is currently active.

	 - Remark: This cannot be called in `resetContent(:animation:)` after `withAnimation` because that will lead to animation glitches.
	 */
	func cleanupNodeList() {
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

	 - parameter identifier: The navigation stack view's identifier targeting by this navigation.
	 The provided ID will be used to determine which navigation stack view should switch back to its default view.
	 - parameter animation: The transition animation to use during this transition. When nil is passed then no animation will be used.
	 */
	public func hideView(_ identifier: IdentifierType, animation: NavigationAnimation? = nil) {
		guard let navigationStackNode = navigationStackNode, let node = navigationStackNode.getNode(identifier) else {
			if silenceErrors { return }
			fatalError("No navigation view with identifier '\(identifier)' available on the stack to reset")
		}

		node.transitionAnimation = animation
		hideAlternativeViewForNode(node)
	}

	/**
	 Navigates back to a specific navigation stack view somewhere in the stack by using its reverse animation.
	 This is typically used to execute a back navigation to a view farther down the stack, e.g. back to the root.

	 - parameter identifier: The navigation stack view's identifier targeting by this navigation.
	 The provided ID will be used to determine which navigation stack view should switch back to its default view.
	 */
	public func hideViewWithReverseAnimation(_ identifier: IdentifierType) {
		guard let navigationStackNode = navigationStackNode, let node = navigationStackNode.getNode(identifier) else {
			if silenceErrors { return }
			fatalError("No navigation view with identifier '\(identifier)' available on the stack to reset")
		}

		hideAlternativeViewForNode(node)
	}

	/**
	 Deactivates the alternative view for a navigation stack view.

	 - parameter node: The stack view's node on which to deactivate the navigation.
	 */
	private func hideAlternativeViewForNode(_ node: NavigationStackNode<IdentifierType>) {
		node.isAlternativeViewShowingPrecede = false // Necessary, see Experiment7

		if let transitionAnimation = node.transitionAnimation {
			withAnimation(transitionAnimation.animation) {
				node.isAlternativeViewShowing = false
				node.transitionProgress = .progressToDefaultView
			}
		} else {
			node.isAlternativeViewShowing = false
			node.transitionProgress = .progressToDefaultView
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
	 Returns whether there is a navigation view with a specific ID on the stack or not,
	 meaning is it possible to navigate to the navigation stack view or not.

	 - parameter identifier: The navigation stack view's identifier to query for its existence in the stack.
	 - returns: True when it's safe to navigate to the ID, otherwise false.

	 - Warning: Using this method to show different views or sub-views without freezing the result in a `let` variable will result in animation glitches!
	 */
	public func isAlternativeViewShowing(_ identifier: IdentifierType) -> Bool {
		guard let node = navigationStackNode?.getNode(identifier) else {
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
	 Creates and returns a binding for a navigation stack view's showing flag.

	 - identifier: The navigation stack view's identifier for which to create a binding.
	 - returns: The binding bound to the view on the navigation stack.
	 */
	public func viewShowingBinding(_ identifier: IdentifierType) -> Binding<Bool> {
		guard let navigationStackNode = navigationStackNode, let node = navigationStackNode.getNode(identifier) else {
			if silenceErrors { return .constant(false) }
			fatalError("No navigation view with identifier '\(identifier)' available on the stack for binding")
		}

		return createBindingForNode(node)
	}

	/**
	 Creates the navigation binding instance for a given node.
	 The binding doesn't retain the node, but is still bound to it, meaning when the node is removed and then adding a new node with the same identifier
	 won't make the binding work with that new node without. In that case a new binding for the new node has to be created.

	 - parameter node: The navigation stack view's node for which to create the binding.
	 - returns: The created binding ready to pass to a SwiftUI view.
	 */
	private func createBindingForNode(_ node: NavigationStackNode<IdentifierType>) -> Binding<Bool> {
		Binding<Bool>(
			get: { [weak node] in
				node?.isAlternativeViewShowing == true
			},
			set: { [weak node] presenting in
				// This is an one-way toggle, meaning it can be set to false, but not back to true.
				if !presenting {
					node?.isAlternativeViewShowingPrecede = false // Keep this in sync with the showing flag.
					node?.isAlternativeViewShowing = false
					node?.transitionProgress = .progressToDefaultView
				}
			}
		)
	}
}

// MARK: - Used by the NavigationStackView

extension NavigationStackModel {
	/**
	 Returns the safe state of whether a navigation switch has been applied.

	 - parameter identifier: The navigation stack view's ID.
	 - returns: True if the alternative view is showing, otherwise false.
	 */
	func isAlternativeViewShowingPrecede(_ identifier: IdentifierType) -> Bool {
		guard let node = navigationStackNode?.getNode(identifier) else {
			return false
		}

		return node.isAlternativeViewShowingPrecede
	}

	/**
	 Returns the alternative view for a given navigation's identifier.

	 - parameter identifier: The navigation stack view's ID.
	 - returns: The content view if any.
	 */
	func alternativeView(_ identifier: IdentifierType) -> AnyViewBuilder? {
		navigationStackNode?.getNode(identifier)?.alternativeView
	}

	/**
	 The transition for the default content view.

	 - parameter identifier: The navigation stack view's ID.
	 - returns: The transition.
	 */
	func defaultViewTransition(_ identifier: IdentifierType) -> AnyTransition {
		navigationStackNode?.getNode(identifier)?.transitionAnimation?.defaultViewTransition ?? .identity
	}

	/**
	 The transition for the alternative view.

	 - parameter identifier: The navigation stack view's ID.
	 - returns: The transition.
	 */
	func alternativeViewTransition(_ identifier: IdentifierType) -> AnyTransition {
		navigationStackNode?.getNode(identifier)?.transitionAnimation?.alternativeViewTransition ?? .identity
	}

	/**
	 The default view's z-index during a transition.

	 - parameter identifier: The navigation stack view's ID.
	 - returns: The z-index to apply.
	 */
	func defaultViewZIndex(_ identifier: IdentifierType) -> Double {
		navigationStackNode?.getNode(identifier)?.transitionAnimation?.defaultViewZIndex ?? .zero
	}

	/**
	 The alternative view's z-index during a transition.

	 - parameter identifier: The navigation stack view's ID.
	 - returns: The z-index to apply.
	 */
	func alternativeViewZIndex(_ identifier: IdentifierType) -> Double {
		navigationStackNode?.getNode(identifier)?.transitionAnimation?.alternativeViewZIndex ?? .zero
	}

	/**
	 The current transition animation progress used to determine when the animation has finished.

	 - parameter identifier: The navigation stack view's ID.
	 - returns: The current animation progress.
	 0 means the default view is visible, 1 means the alternative view is visible and a value inbetween represents the progress.
	 */
	func transitionProgress(_ identifier: IdentifierType) -> Float {
		guard let node = navigationStackNode?.getNode(identifier) else {
			return .progressToDefaultView
		}
		return node.transitionProgress
	}
}

// MARK: - Debugging

extension NavigationStackModel: CustomDebugStringConvertible {
	public var debugDescription: String {
		if let node = navigationStackNode {
			return "[\(String(describing: node))]"
		} else {
			return "[]"
		}
	}
}
