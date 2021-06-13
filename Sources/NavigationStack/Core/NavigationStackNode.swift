import Combine
import SwiftUI

/**
 A node usable to construct a navigation hierarchy via a linked list.

 This is used by the `NavigationModel` to hold each navigation stack view's navigation state.
 The node holds the navigation state's data and propagates any changes to the model.
 Each node belongs to a navigation stack view, but a node only exists when that view also has a navigation applied.
 */
class NavigationStackNode<IdentifierType>: ObservableObject where IdentifierType: Equatable {
	/**
	 Initializes the node.

	 - parameter identifier: The representing navigation stack view's ID.
	 - parameter alternativeView: The content to show when this node's navigation is active, meaning `isAlternativeViewShowing` is true.
	 */
	init(identifier: IdentifierType, alternativeView: @escaping AnyViewBuilder) {
		identifer = identifier
		self.alternativeView = alternativeView
	}

	/// The navigation stack view's ID which this node represents.
	let identifer: IdentifierType
	/// The content view which should be shown when the navigation is active.
	let alternativeView: AnyViewBuilder

	/// True whether the navigation has been applied and the alternative view is visible, otherwise false.
	@Published var isAlternativeViewShowing = false
	/// The same as `isAlternativeViewShowing`, but as a precede value. See Experiment8.
	@Published var isAlternativeViewShowingPrecede = false
	/// The transition animation to apply.
	@Published var transitionAnimation: NavigationAnimation?

	/// Keeps track of the current transition animation progress.
	/// Animated to determine when an animation has completed.
	@Published var transitionProgress: Float = .progressToDefaultView

	/// The next navigation stack view's node in the hierarchy.
	@Published var nextNode: NavigationStackNode? {
		didSet {
			// Propagates any published state changes from sub-nodes to observers of this node.
			nextNodeChangeCanceller = nextNode?.objectWillChange.sink(receiveValue: { [weak self] _ in
				self?.objectWillChange.send()
			})
		}
	}

	/// Combine's sink bag for `nexNode`.
	private var nextNodeChangeCanceller: AnyCancellable?

	/**
	 Retrieves recursively the node in the hiarachy with a given ID.

	 - parameter identifier: The node's ID which to retrieve.
	 - returns: The first node in the linked list with the given ID.
	 */
	func getNode(_ identifier: IdentifierType) -> NavigationStackNode? {
		identifer == identifier ? self : nextNode?.getNode(identifier)
	}

	/**
	 Returns the last node of the linked list which is actively showing a navigation.

	 - returns: The last active node.
	 */
	func getLeafNode() -> NavigationStackNode? {
		if !isAlternativeViewShowing {
			return nil
		}
		return nextNode?.getLeafNode() ?? self
	}
}

// MARK: - Debugging

extension NavigationStackNode: CustomDebugStringConvertible {
	var debugDescription: String {
		var description = "'\(identifer)'"
		if let nextNode = nextNode {
			description += "|\(nextNode)"
		}
		return description
	}
}
