import XCTest

extension XCTestCase {
	// Source: https://www.swiftbysundell.com/articles/reducing-flakiness-in-swift-tests/
	func wait(forElement element: XCUIElement, timeout: TimeInterval) {
		let predicate = NSPredicate(format: "exists == 1")

		// This will make the test runner continously evalulate the
		// predicate, and wait until it matches.
		expectation(for: predicate, evaluatedWith: element)
		waitForExpectations(timeout: timeout)
	}
}
