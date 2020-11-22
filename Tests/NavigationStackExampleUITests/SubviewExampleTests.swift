import XCTest

class SubviewExampleTests: XCTestCase {
	private var app: XCUIApplication!

	override func setUpWithError() throws {
		continueAfterFailure = false
		app = XCUIApplication()
		app.launch()

		app.buttons["SubviewExamplesButton"].tap()
		sleep(1)
	}

	private func pressButton(_ name: String) {
		app.buttons[name].tap()
		sleep(1)
	}

	// MARK: - Tests

	// This shows the sub-view navigation how it works when used in the correct order.
	func testSubviewWorking() throws {
		pressButton("Subview1Button")
		pressButton("Subview2Button")
		pressButton("ResetButton")
		pressButton("BackButton")
	}

	// This shows the same sub-view navigation, but used in a different order and results in different end state.
	func testSubviewProblem() throws {
		pressButton("Subview2Button")
		pressButton("Subview1Button")
		pressButton("ResetButton")
		pressButton("BackButton")
	}
}
