@testable import NavigationStack
import SwiftUI
import XCTest

class NavigationStackNodeGetNodeTests: XCTestCase {
	var node: NavigationStackNode<String>!

	let nodeName = "Foo"

	override func setUp() {
		node = NavigationStackNode(identifier: nodeName, alternativeView: { AnyView(EmptyView()) })
	}

	// MARK: - Tests

	// Returns nil when the node is not of the searched name.
	func testNotNamed() throws {
		let result = node.getNode("Bar")

		XCTAssertNil(result)
	}

	// Returns nil when the stack has no node of the searched name.
	func testNoNodeInStack() throws {
		node.nextNode = NavigationStackNode(identifier: "SomeName", alternativeView: { AnyView(EmptyView()) })

		let result = node.getNode("Bar")

		XCTAssertNil(result)
	}

	// The searched node is the node on which the call was invoced.
	func testThisNode() throws {
		let result = node.getNode(nodeName)

		XCTAssertTrue(result === node)
	}

	// The first node with the same name in the list is found.
	func testFistNode() throws {
		let nextNode = NavigationStackNode(identifier: nodeName, alternativeView: { AnyView(EmptyView()) })
		node.nextNode = nextNode

		let result = node.getNode(nodeName)

		XCTAssertTrue(result === node)
	}

	// Finds the node down the stack with the searched name.
	func testNodeInStack() throws {
		let nextNode = NavigationStackNode(identifier: "Bar", alternativeView: { AnyView(EmptyView()) })
		node.nextNode = nextNode

		let result = node.getNode("Bar")

		XCTAssertTrue(result === nextNode)
	}
}
