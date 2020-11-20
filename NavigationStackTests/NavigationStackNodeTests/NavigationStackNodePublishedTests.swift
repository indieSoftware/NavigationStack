import Combine
@testable import NavigationStack
import SwiftUI
import XCTest

class NavigationStackNodePublishedTests: XCTestCase {
	var node: NavigationStackNode!
	var nodeDisposal: AnyCancellable!

	override func setUp() {
		node = NavigationStackNode(name: "Foo", alternativeView: { AnyView(EmptyView()) })
	}

	private func setupNodePublishExpectation() {
		let nodeExpectation = expectation(description: "node")
		nodeDisposal = node.objectWillChange.sink(
			receiveValue: {
				nodeExpectation.fulfill()
			}
		)
	}

	// MARK: - Tests

	// Test that changing the node's property will result in an update-notification to observers.
	func testIsAlternativeViewShowingPublished() throws {
		setupNodePublishExpectation()

		node.isAlternativeViewShowing = true

		waitForExpectations(timeout: 1)
		XCTAssertTrue(node.isAlternativeViewShowing)
	}

	// Test that changing the node's property will result in an update-notification to observers.
	func testIsAlternativeViewShowingPrecedePublished() throws {
		setupNodePublishExpectation()

		node.isAlternativeViewShowingPrecede = true

		waitForExpectations(timeout: 1)
		XCTAssertTrue(node.isAlternativeViewShowingPrecede)
	}

	// Test that changing the node's property will result in an update-notification to observers.
	func testTransitionAnimationPublished() throws {
		setupNodePublishExpectation()

		node.transitionAnimation = NavigationAnimation()

		waitForExpectations(timeout: 1)
		XCTAssertNotNil(node.transitionAnimation)
	}

	// Test that assigning a nextNode will result in an update-notification to observers.
	func testNextNodeAssignPublished() throws {
		setupNodePublishExpectation()

		node.nextNode = NavigationStackNode(name: "Bar", alternativeView: { AnyView(EmptyView()) })

		waitForExpectations(timeout: 1)
		XCTAssertNotNil(node.nextNode)
	}

	// Test that changing a nextNode's property will result in an update-notification to observers of the node itself.
	func testNextNodeChangedPropertyPublished() throws {
		let nextNode = NavigationStackNode(name: "Bar", alternativeView: { AnyView(EmptyView()) })
		node.nextNode = nextNode
		XCTAssertFalse(nextNode.isAlternativeViewShowing)

		setupNodePublishExpectation()

		nextNode.isAlternativeViewShowing = true

		waitForExpectations(timeout: 1)
		XCTAssertEqual(true, node.nextNode?.isAlternativeViewShowing)
	}
}
