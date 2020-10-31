import XCTest

class ExperimentTests: XCTestCase {
	private var app: XCUIApplication!

	override func setUpWithError() throws {
		continueAfterFailure = false
		app = XCUIApplication()
	}

	// This experiment includes knowledge from experiment 2 to 5 to get the transition animation working as expected.
	func testExperiment1() throws {
		launchExperiment(1)
	}

	// This experiment tries to use an if-else branch to switch the default and alternative content view, but that doesn't work.
	func testExperiment2() throws {
		launchExperiment(2)
	}

	// This experiment tries to save the transition into a state property, but that doesn't work.
	func testExperiment3() throws {
		launchExperiment(3)
	}

	// This experiment uses the ternary operator instead of an if-else branch to return different views with the different transitions applied,
	// but that doesn't work.
	func testExperiment4() throws {
		launchExperiment(4)
	}

	// This experiment uses the same set up as Experiment4, but instead of using the ternary operator to return back two different views
	// here we use it to just return the different transitions, but that doesn't work either.
	func testExperiment5() throws {
		launchExperiment(5)
	}

	// This experiment is the same as Experiment1, but uses a switch statement instead of if-else branches.
	func testExperiment6() throws {
		launchExperiment(6)
	}

	// This experiment works like Experiment1, but shows a glitch when accessing the showAlternativeContent state inside of a sub-view.
	func testExperiment7() throws {
		launchExperiment(7)
	}

	// This experiment tries like Experiment3 to save the transition into a property rather than in a state.
	// This works when using a pre-update step for switching the content.
	func testExperiment8() throws {
		launchExperiment(8)
	}

	// This experiment builds on top of Experiment8, but solves the ordering of the overlapping content views.
	func testExperiment9() throws {
		launchExperiment(9)
	}

	private func launchExperiment(_ number: Int) {
		app.launchArguments = ["Experiment\(number)"]
		app.launch()

		// Push alternative content
		tapToggleContent()
		// Pop back to default
		tapToggleContent()

		// Switch transition to Scale
		tapPicker(1, segment: 1)

		// Show alternative content with a scale transition
		tapToggleContent()

		// Switch transition back to Move
		tapPicker(1, segment: 0)

		// Transition back to the default content
		tapToggleContent()
	}

	private func tapToggleContent() {
		app.buttons["ToggleContentButton"].tap()
		sleep(1)
	}

	private func tapPicker(_ index: Int, segment: Int) {
		let picker = app.segmentedControls["Picker_\(index)"]
		let button = picker.buttons.element(boundBy: segment)
		button.tap()
		sleep(1)
	}
}
