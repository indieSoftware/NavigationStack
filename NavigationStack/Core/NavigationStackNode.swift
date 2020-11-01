import Combine
import SwiftUI

class NavigationStackNode: ObservableObject {
	let name: String

	@Published var isAlternativeViewShowing = false
	@Published var isAlternativeViewShowingPrecede = false
	@Published var alternativeView: AnyViewBuilder
	@Published var transitionAnimation: NavigationAnimation?

	@Published var nextNode: NavigationStackNode? {
		didSet {
			// Propagates any published state changes from sub-nodes to observers of this node.
			nextNodeChangeCanceller = nextNode?.objectWillChange.sink(receiveValue: { [weak self] _ in
				self?.objectWillChange.send()
			})
		}
	}

	private var nextNodeChangeCanceller: AnyCancellable?

	init(name: String, alternativeView: @escaping AnyViewBuilder) {
		self.name = name
		self.alternativeView = alternativeView
	}

	func getNode(named name: String) -> NavigationStackNode? {
		self.name == name ? self : nextNode?.getNode(named: name)
	}

	func getLeafNode() -> NavigationStackNode? {
		if !isAlternativeViewShowing {
			return nil
		}
		return nextNode?.getLeafNode() ?? self
	}
}
