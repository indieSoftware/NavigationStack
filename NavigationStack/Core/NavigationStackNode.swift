import Combine
import SwiftUI

class NavigationStackNode: ObservableObject {
	let name: String

	@Published var isAlternativeContentShowing = false
	@Published var isAlternativeContentShowingPrecede = false
	@Published var alternativeContent: ContentBuilder
	@Published var contentSwitchAnimation: NavigationAnimation?

	@Published var nextNode: NavigationStackNode? {
		didSet {
			// Propagates any published state changes from sub-nodes to observers of this node.
			nextNodeChangeCanceller = nextNode?.objectWillChange.sink(receiveValue: { [weak self] _ in
				self?.objectWillChange.send()
			})
		}
	}

	private var nextNodeChangeCanceller: AnyCancellable?

	init(name: String, alternativeContent: @escaping ContentBuilder) {
		self.name = name
		self.alternativeContent = alternativeContent
	}

	func getNode(named name: String) -> NavigationStackNode? {
		self.name == name ? self : nextNode?.getNode(named: name)
	}

	func getLeafNode() -> NavigationStackNode? {
		if !isAlternativeContentShowing {
			return nil
		}
		return nextNode?.getLeafNode() ?? self
	}
}
