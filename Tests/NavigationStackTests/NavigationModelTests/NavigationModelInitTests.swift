@testable import NavigationStack
import SwiftUI
import XCTest

class NavigationModelInitTests: XCTestCase {
	// MARK: - Tests

	// Test the default values are set when initializing a new model.
	func testDefaultValues() throws {
		let result = NavigationModel()

		XCTAssertFalse(result.silenceErrors)
	}

	// Test the provided values are set when initializing a new model.
	func testCustomValues() throws {
		let result = NavigationModel(silenceErrors: true)

		XCTAssertTrue(result.silenceErrors)
	}
}
