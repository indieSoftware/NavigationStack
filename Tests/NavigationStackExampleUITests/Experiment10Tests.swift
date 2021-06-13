import XCTest

// Ensures Issue1 is fixed
class Experiment10Tests: XCTestCase {
	private var app: XCUIApplication!

	override func setUpWithError() throws {
		continueAfterFailure = false
		app = XCUIApplication()
	}

	// MARK: - Tests

	// This starts Experiment10 and checks if the second screen becomes shown.
	func testStartExperiment10() throws {
		for _ in 0 ... 10 {
			app.launchArguments = ["Experiment10"]
			app.launch()
			XCTAssertTrue(app.staticTexts["Screen 1"].exists)
			XCTAssertTrue(app.staticTexts["Screen 2"].waitForExistence(timeout: 3))
			app.terminate()
		}
	}
}
