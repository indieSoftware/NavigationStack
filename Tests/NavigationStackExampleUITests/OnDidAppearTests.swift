import XCTest

class OnDidAppearTests: XCTestCase {
	private var app: XCUIApplication!

	override func setUpWithError() throws {
		continueAfterFailure = false
		app = XCUIApplication()
		app.launch()

		app.buttons["OnDidAppearExamplesButton"].tap()
		XCTAssertTrue(app.staticTexts["OnDidAppearExample"].waitForExistence(timeout: 3))
	}

	// MARK: - Tests

	// Pushes View2 and goes back to view1 and checks that the view2 state is presented accordingly.
	func testAllStatesWereShownDuringTransition() throws {
		XCTAssertTrue(app.staticTexts["View2 state: none"].waitForExistence(timeout: 1))
		app.buttons["PushView2"].tap()
		XCTAssertTrue(app.staticTexts["View2 state: appearing"].waitForExistence(timeout: 1))
		XCTAssertTrue(app.staticTexts["View2 state: present"].waitForExistence(timeout: 5))
		app.buttons["PopView2"].tap()
		XCTAssertTrue(app.staticTexts["View2 state: disappearing"].waitForExistence(timeout: 1))
		XCTAssertTrue(app.staticTexts["View2 state: none"].waitForExistence(timeout: 5))
	}
}
