@testable import NavigationStack
import SwiftUI
import XCTest

class NavigationStackNodeInitTests: XCTestCase {
	// MARK: - Tests

	// Test the default values are set when initializing a new node.
	func testInit() throws {
		let result = NavigationStackNode(identifier: "Foo", alternativeView: { AnyView(EmptyView()) })

		XCTAssertEqual("Foo", result.identifer)
		XCTAssertFalse(result.isAlternativeViewShowing)
		XCTAssertFalse(result.isAlternativeViewShowingPrecede)
		XCTAssertNotNil(result.alternativeView())
		XCTAssertNil(result.transitionAnimation)
		XCTAssertNil(result.nextNode)
	}
}
