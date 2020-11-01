import Combine
import SwiftUI

public class NavigationModel: ObservableObject {
	let silenceErrors: Bool

	@Published private var navigationStackNode: NavigationStackNode? {
		didSet {
			// Propagates any published state changes from the node to observers of this node and not only whether the node has been set or deleted.
			navigationStackNodeChangeCanceller = navigationStackNode?.objectWillChange.sink(receiveValue: { [weak self] _ in
				self?.objectWillChange.send()
			})
		}
	}

	private var navigationStackNodeChangeCanceller: AnyCancellable?

	public init(silenceErrors: Bool = false) {
		self.silenceErrors = silenceErrors
	}

	public func showView<Content: View>(_ name: String, animation: NavigationAnimation? = nil, @ViewBuilder alternativeView: @escaping () -> Content) {
		let viewBuilder: AnyViewBuilder = { AnyView(alternativeView()) }

		let newNode = NavigationStackNode(name: name, alternativeView: viewBuilder)
		newNode.transitionAnimation = animation
		enqueueNewNode(newNode)

		showAlternativeViewForNode(newNode)
	}

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

	public func hideTopViewWithReverseAnimation() {
		guard let navigationStackNode = navigationStackNode, let leafNode = navigationStackNode.getLeafNode() else {
			if silenceErrors { return }
			fatalError("No top navigation view available on the stack to reset")
		}

		hideAlternativeViewForNode(leafNode)
	}

	public func hideTopView(animation: NavigationAnimation? = nil) {
		guard let navigationStackNode = navigationStackNode, let leafNode = navigationStackNode.getLeafNode() else {
			if silenceErrors { return }
			fatalError("No top navigation view available on the stack to reset")
		}

		leafNode.transitionAnimation = animation
		hideAlternativeViewForNode(leafNode)
	}

	public func hideView(_ name: String, animation: NavigationAnimation? = nil) {
		guard let navigationStackNode = navigationStackNode, let node = navigationStackNode.getNode(named: name) else {
			if silenceErrors { return }
			fatalError("No navigation view with name '\(name)' available on the stack to reset")
		}

		node.transitionAnimation = animation
		hideAlternativeViewForNode(node)
	}

	public func hideViewWithReverseAnimation(_ name: String) {
		guard let navigationStackNode = navigationStackNode, let node = navigationStackNode.getNode(named: name) else {
			if silenceErrors { return }
			fatalError("No navigation view with name '\(name)' available on the stack to reset")
		}

		hideAlternativeViewForNode(node)
	}

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
	 - Warning: Using this method to show different views or sub-views without freezing the result will result in animation glitches!
	 */
	public var hasAlternativeViewShowing: Bool {
		navigationStackNode?.getLeafNode() != nil
	}

	/**
	 - Warning: Using this method to show different views or sub-views without freezing the result will result in animation glitches!
	 */
	public func isAlternativeViewShowing(_ name: String) -> Bool {
		guard let node = navigationStackNode?.getNode(named: name) else {
			return false
		}

		return node.isAlternativeViewShowing
	}

	public func topViewShowingBinding() -> Binding<Bool> {
		guard let navigationStackNode = navigationStackNode, let leafNode = navigationStackNode.getLeafNode() else {
			if silenceErrors { return .constant(false) }
			fatalError("No top navigation view available on the stack for binding")
		}

		return createBindingForNode(leafNode)
	}

	public func viewShowingBinding(_ name: String) -> Binding<Bool> {
		guard let navigationStackNode = navigationStackNode, let node = navigationStackNode.getNode(named: name) else {
			if silenceErrors { return .constant(false) }
			fatalError("No navigation view with name '\(name)' available on the stack for binding")
		}

		return createBindingForNode(node)
	}

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

// MARK: - Used by ContentSwitcher

extension NavigationModel {
	func isAlternativeViewShowingPrecede(_ name: String) -> Bool {
		guard let node = navigationStackNode?.getNode(named: name) else {
			return false
		}

		return node.isAlternativeViewShowingPrecede
	}

	func alternativeView(_ name: String) -> AnyViewBuilder? {
		navigationStackNode?.getNode(named: name)?.alternativeView
	}

	func defaultViewTransition(_ name: String) -> AnyTransition {
		navigationStackNode?.getNode(named: name)?.transitionAnimation?.defaultViewTransition ?? .identity
	}

	func alternativeViewTransition(_ name: String) -> AnyTransition {
		navigationStackNode?.getNode(named: name)?.transitionAnimation?.alternativeViewTransition ?? .identity
	}

	func defaultViewZIndex(_ name: String) -> Double {
		navigationStackNode?.getNode(named: name)?.transitionAnimation?.defaultViewZIndex ?? .zero
	}

	func alternativeViewZIndex(_ name: String) -> Double {
		navigationStackNode?.getNode(named: name)?.transitionAnimation?.alternativeViewZIndex ?? .zero
	}
}
