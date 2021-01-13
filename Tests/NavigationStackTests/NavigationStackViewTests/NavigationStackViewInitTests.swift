@testable import NavigationStack
import SwiftUI
import XCTest

class NavigationStackViewInitTests: XCTestCase {
	// MARK: - Tests

	// Test that the provided name is set.
	func testName() throws {
		let identifier = "Foo"
		let result = NavigationStackView(identifier) { EmptyView() }

		XCTAssertEqual(identifier, result.identifier)
	}
}
