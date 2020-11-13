import XCTest

class TransitionExampleTests: XCTestCase {
	private var app: XCUIApplication!

	override func setUpWithError() throws {
		continueAfterFailure = false
		app = XCUIApplication()
		app.launch()

		app.buttons["TransitionExamplesButton"].tap()
		sleep(1)
	}

	private func playTransition(_ name: String) {
		app.buttons[name + "Button"].tap()
		sleep(1)
		app.buttons["BackButton"].tap()
		sleep(1)
	}

	// Plays all transition animations of the TransitionExample view in sequence.
	func testTransitionAnimations() throws {
		playTransition("Move")
		playTransition("Scale")
		playTransition("Offset")
		playTransition("Opacity")
		playTransition("Slide")
		playTransition("Identity")

		playTransition("Static")
		playTransition("Iris")
		playTransition("Blur")
		playTransition("Brightness")
		playTransition("Contrast")
		playTransition("Saturation")
		playTransition("HueRotation")
	}
}
