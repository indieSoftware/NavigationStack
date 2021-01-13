@testable import NavigationStack
import SwiftUI
import XCTest

class NavigationStackNodeGetLeafNodeTests: XCTestCase {
	var node: NavigationStackNode<String>!

	let nodeName = "Foo"

	override func setUp() {
		node = NavigationStackNode(identifier: nodeName, alternativeView: { AnyView(EmptyView()) })
	}

	// MARK: - Tests

	// Returns nil when the node is not active.
	func testNotActive() throws {
		let result = node.getLeafNode()

		XCTAssertNil(result)
	}

	// Returns nil when the stack has no active node.
	func testNoActiveNodeInStack() throws {
		node.nextNode = NavigationStackNode(identifier: "Bar", alternativeView: { AnyView(EmptyView()) })

		let result = node.getLeafNode()

		XCTAssertNil(result)
	}

	// Returns nil when the first node in the stack is not active, but one down might be.
	func testNoActiveRootNodeInStack() throws {
		let nextNode = NavigationStackNode(identifier: "Bar", alternativeView: { AnyView(EmptyView()) })
		nextNode.isAlternativeViewShowing = true
		node.nextNode = nextNode

		let result = node.getLeafNode()

		XCTAssertNil(result)
	}

	// Returns the root node if this is the only one active in the stack.
	func testActiveRootNode() throws {
		let nextNode = NavigationStackNode(identifier: "Bar", alternativeView: { AnyView(EmptyView()) })
		node.nextNode = nextNode
		node.isAlternativeViewShowing = true

		let result = node.getLeafNode()

		XCTAssertTrue(result === node)
	}

	// Returns the last node of the stack if all nodes are active.
	func testActiveLeafNode() throws {
		let nextNode = NavigationStackNode(identifier: "Bar", alternativeView: { AnyView(EmptyView()) })
		nextNode.isAlternativeViewShowing = true
		node.nextNode = nextNode
		node.isAlternativeViewShowing = true

		let result = node.getLeafNode()

		XCTAssertTrue(result === nextNode)
	}
}
