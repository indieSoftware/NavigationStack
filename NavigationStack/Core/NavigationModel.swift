import Combine
import SwiftUI

public class NavigationModel: ObservableObject {
	let throwExceptionOnError: Bool

	@Published private var contentNode: NavigationStackNode? {
		didSet {
			// Propagates any published state changes from the node to observers of this node and not only whether the node has been set or deleted.
			contentNodeChangeCanceller = contentNode?.objectWillChange.sink(receiveValue: { [weak self] _ in
				self?.objectWillChange.send()
			})
		}
	}

	private var contentNodeChangeCanceller: AnyCancellable?

	public init(throwExceptionOnError: Bool = true) {
		self.throwExceptionOnError = throwExceptionOnError
	}

	public func showContent<Content: View>(_ name: String, animation: NavigationAnimation? = nil, @ViewBuilder alternativeContent: @escaping () -> Content) {
		let contentBuilder: ContentBuilder = { AnyView(alternativeContent()) }

		let newNode = NavigationStackNode(name: name, alternativeContent: contentBuilder)
		newNode.contentSwitchAnimation = animation
		enqueueNewNode(newNode)

		showAlternativeContentForNode(newNode)
	}

	private func enqueueNewNode(_ newNode: NavigationStackNode) {
		cleanupNodeList()

		if let contentNode = contentNode, contentNode.getNode(named: newNode.name) != nil {
			if !throwExceptionOnError { return }
			fatalError("Replacing switched content '\(newNode.name)' not allowed")
		} else if let contentNode = contentNode, let node = contentNode.getLeafNode() {
			node.nextNode = newNode
		} else {
			contentNode = newNode
		}
	}

	private func showAlternativeContentForNode(_ node: NavigationStackNode) {
		node.isAlternativeContentShowingPrecede = true // Necessary, see Experiment7

		if let contentSwitchAnimation = node.contentSwitchAnimation {
			withAnimation(contentSwitchAnimation.animation) {
				node.isAlternativeContentShowing = true
			}
		} else {
			node.isAlternativeContentShowing = true
		}
	}

	/**
	 Truncates the nextNode queue of the leaf node which is currently active.

	 - Remark: This cannot be called in `resetContent(:,animation:)` after `withAnimation` because that will lead to animation glitches.
	 */
	private func cleanupNodeList() {
		guard let contentNode = contentNode else { return }

		if !contentNode.isAlternativeContentShowing {
			self.contentNode = nil
		} else if let node = contentNode.getLeafNode() {
			node.nextNode = nil
		}
	}

	public func resetTopContentWithReverseAnimation() {
		guard let contentNode = contentNode, let node = contentNode.getLeafNode() else {
			if !throwExceptionOnError { return }
			fatalError("No top content available to reset")
		}

		hideAlternativeContentForNode(node)
	}

	public func resetTopContent(animation: NavigationAnimation? = nil) {
		guard let contentNode = contentNode, let node = contentNode.getLeafNode() else {
			if !throwExceptionOnError { return }
			fatalError("No top content available to reset")
		}

		node.contentSwitchAnimation = animation
		hideAlternativeContentForNode(node)
	}

	public func resetContent(_ name: String, animation: NavigationAnimation? = nil) {
		guard let contentNode = contentNode, let node = contentNode.getNode(named: name) else {
			if !throwExceptionOnError { return }
			fatalError("No content with name '\(name)' available to reset")
		}

		node.contentSwitchAnimation = animation
		hideAlternativeContentForNode(node)
	}

	public func resetContentWithReverseAnimation(_ name: String) {
		guard let contentNode = contentNode, let node = contentNode.getNode(named: name) else {
			if !throwExceptionOnError { return }
			fatalError("No content with name '\(name)' available to reset")
		}

		hideAlternativeContentForNode(node)
	}

	private func hideAlternativeContentForNode(_ node: NavigationStackNode) {
		node.isAlternativeContentShowingPrecede = false // Necessary, see Experiment7

		if let contentSwitchAnimation = node.contentSwitchAnimation {
			withAnimation(contentSwitchAnimation.animation) {
				node.isAlternativeContentShowing = false
			}
		} else {
			node.isAlternativeContentShowing = false
		}
	}

	/**
	 - Warning: Using this method to show different views or sub-views without freezing the result will result in animation glitches!
	 */
	public var hasAlternativeContentShowing: Bool {
		contentNode?.getLeafNode() != nil
	}

	/**
	 - Warning: Using this method to show different views or sub-views without freezing the result will result in animation glitches!
	 */
	public func isAlternativeContentShowing(_ name: String) -> Bool {
		guard let node = contentNode?.getNode(named: name) else {
			return false
		}

		return node.isAlternativeContentShowing
	}

	public func contentShowingBinding() -> Binding<Bool> {
		guard let contentNode = contentNode, let node = contentNode.getLeafNode() else {
			if !throwExceptionOnError { return .constant(false) }
			fatalError("No top content available for binding")
		}

		return createBindingOfNode(node)
	}

	public func contentShowingBinding(_ name: String) -> Binding<Bool> {
		guard let contentNode = contentNode, let node = contentNode.getNode(named: name) else {
			if !throwExceptionOnError { return .constant(false) }
			fatalError("No content with name '\(name)' available for binding")
		}

		return createBindingOfNode(node)
	}

	private func createBindingOfNode(_ node: NavigationStackNode) -> Binding<Bool> {
		Binding<Bool>(
			get: {
				node.isAlternativeContentShowing
			},
			set: { presenting in
				// This is a one-way toggle, meaning it can be set to false, but not back.
				if !presenting {
					node.isAlternativeContentShowingPrecede = false // Keep this in sync with the showing flag.
					node.isAlternativeContentShowing = false
				}
			}
		)
	}
}

// MARK: - Used by ContentSwitcher

extension NavigationModel {
	func isAlternativeContentShowingPrecede(_ name: String) -> Bool {
		guard let node = contentNode?.getNode(named: name) else {
			return false
		}

		return node.isAlternativeContentShowingPrecede
	}

	func alternativeContent(_ name: String) -> ContentBuilder? {
		contentNode?.getNode(named: name)?.alternativeContent
	}

	func defaultContentTransition(_ name: String) -> AnyTransition {
		contentNode?.getNode(named: name)?.contentSwitchAnimation?.defaultContentTransition ?? .identity
	}

	func alternativeContentTransition(_ name: String) -> AnyTransition {
		contentNode?.getNode(named: name)?.contentSwitchAnimation?.alternativeContentTransition ?? .identity
	}

	func defaultContentZIndex(_ name: String) -> Double {
		contentNode?.getNode(named: name)?.contentSwitchAnimation?.defaultContentZIndex ?? .zero
	}

	func alternativeContentZIndex(_ name: String) -> Double {
		contentNode?.getNode(named: name)?.contentSwitchAnimation?.alternativeContentZIndex ?? .zero
	}
}
