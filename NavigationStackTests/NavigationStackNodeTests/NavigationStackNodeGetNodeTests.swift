@testable import NavigationStack
import SwiftUI
import XCTest

class NavigationStackNodeGetNodeTests: XCTestCase {
	var node: NavigationStackNode!

	let nodeName = "Foo"

	override func setUp() {
		node = NavigationStackNode(name: nodeName, alternativeView: { AnyView(EmptyView()) })
	}

	// MARK: - Tests

	// Returns nil when the node is not of the searched name.
	func testNotNamed() throws {
		let result = node.getNode(named: "Bar")

		XCTAssertNil(result)
	}

	// Returns nil when the stack has no node of the searched name.
	func testNoNodeInStack() throws {
		node.nextNode = NavigationStackNode(name: "SomeName", alternativeView: { AnyView(EmptyView()) })

		let result = node.getNode(named: "Bar")

		XCTAssertNil(result)
	}

	// The searched node is the node on which the call was invoced.
	func testThisNode() throws {
		let result = node.getNode(named: nodeName)

		XCTAssertTrue(result === node)
	}

	// The first node with the same name in the list is found.
	func testFistNode() throws {
		let nextNode = NavigationStackNode(name: nodeName, alternativeView: { AnyView(EmptyView()) })
		node.nextNode = nextNode

		let result = node.getNode(named: nodeName)

		XCTAssertTrue(result === node)
	}

	// Finds the node down the stack with the searched name.
	func testNodeInStack() throws {
		let nextNode = NavigationStackNode(name: "Bar", alternativeView: { AnyView(EmptyView()) })
		node.nextNode = nextNode

		let result = node.getNode(named: "Bar")

		XCTAssertTrue(result === nextNode)
	}
}
