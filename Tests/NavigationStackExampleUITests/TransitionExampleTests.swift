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

	// MARK: - Tests

	// Plays all transition animations of the TransitionExample view in sequence.
	func testTransitionAnimations() throws {
		playTransition("Move")
		playTransition("Scale")
		playTransition("Offset")
		playTransition("Opacity")
		playTransition("Slide")
		playTransition("Identity")

		playTransition("Static")

		playTransition("Blur")
		playTransition("Brightness")
		playTransition("Contrast")
		playTransition("HueRotation")
		playTransition("Saturation")

		playTransition("TiltAndFly")
		playTransition("CircleShape")
		playTransition("RectangleShape")
		playTransition("StripesHorizontalDown")
		playTransition("StripesHorizontalUp")
		playTransition("StripesVerticalRight")
		playTransition("StripesVerticalLeft")
	}

	func testSwiftUiTransitions() throws {
		playTransition("Move")
		playTransition("Scale")
		playTransition("Offset")
		playTransition("Opacity")
		playTransition("Slide")
	}

	func testAnimationTransitions() throws {
		playTransition("Blur")
		playTransition("Brightness")
		playTransition("Contrast")
		playTransition("HueRotation")
		playTransition("Saturation")
	}

	func testCustomTransitions() throws {
		playTransition("TiltAndFly")
		playTransition("CircleShape")
		playTransition("RectangleShape")
		playTransition("StripesHorizontalDown")
		playTransition("StripesHorizontalUp")
		playTransition("StripesVerticalRight")
		playTransition("StripesVerticalLeft")
	}
}
