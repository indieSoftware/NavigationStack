@testable import NavigationStack
import SwiftUI
import XCTest

class NavigationStackViewInitTests: XCTestCase {
	// MARK: - Tests

	// Test that the provided name is set.
	func testName() throws {
		let name = "Foo"
		let result = NavigationStackView(name) { EmptyView() }

		XCTAssertEqual(name, result.name)
	}
}
