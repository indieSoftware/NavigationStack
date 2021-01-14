@testable import NavigationStack
import SwiftUI
import XCTest

class NavigationStackViewInitTests: XCTestCase {
	// MARK: - Tests

	// Test that the provided ID is set.
	func testId() throws {
		let identifier = "Foo"
		let result = NavigationStackView(identifier) { EmptyView() }

		XCTAssertEqual(identifier, result.identifier)
	}
}
