@testable import NavigationStack
import SwiftUI
import XCTest

class NavigationStackNodeInitTests: XCTestCase {
	// MARK: - Tests

	// Test the default values are set when initializing a new node.
	func testInit() throws {
		let result = NavigationStackNode(name: "Foo", alternativeView: { AnyView(EmptyView()) })

		XCTAssertEqual("Foo", result.name)
		XCTAssertFalse(result.isAlternativeViewShowing)
		XCTAssertFalse(result.isAlternativeViewShowingPrecede)
		XCTAssertNotNil(result.alternativeView())
		XCTAssertNil(result.transitionAnimation)
		XCTAssertNil(result.nextNode)
	}
}
