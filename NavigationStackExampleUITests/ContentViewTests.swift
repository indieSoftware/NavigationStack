import XCTest

class ContentViewTests: XCTestCase {
	private var app: XCUIApplication!

	override func setUpWithError() throws {
		continueAfterFailure = false
		app = XCUIApplication()
		app.launch()
	}

	private func pressButton(_ name: String) {
		app.buttons[name].tap()
		sleep(1)
	}

	private func assureViewIsShowing(_ name: String, invert expectedInvertedResult: Bool = false, file: StaticString = #filePath, line: UInt = #line) {
		XCTAssertNotEqual(app.staticTexts[name].exists, expectedInvertedResult, file: file, line: line)
	}

	// MARK: - Tests

	func testBackOnRoot() throws {
		assureViewIsShowing("NotPossibleLabel")
		assureViewIsShowing("ContentView1")
		pressButton("Back")
		assureViewIsShowing("ContentView1")
	}

	func testShowViewTransition() throws {
		pressButton("PushView2")
		assureViewIsShowing("ContentView2")
		pressButton("PopToView1")
		assureViewIsShowing("ContentView1")
	}

	func testCombinedTransition() throws {
		pressButton("ScaleUpToView2")
		assureViewIsShowing("ContentView2")
		pressButton("ScaleDownToView1")
		assureViewIsShowing("ContentView1")
	}

	func testCustomTransition() throws {
		pressButton("SingleIrisToView2")
		assureViewIsShowing("ContentView2")
		pressButton("DoubleIrisToView1")
		assureViewIsShowing("ContentView1")
	}

	func testPushAndPopShortcut() throws {
		pressButton("PushView3")
		assureViewIsShowing("ContentView3")
		assureViewIsShowing("PopToView2Animated", invert: true)
		pressButton("PopToView2NoAnimation")
		assureViewIsShowing("ContentView3")
		pressButton("Back")
		assureViewIsShowing("ContentView1")
	}

	func testPresentVerticalNoAnimationBack() throws {
		pressButton("PresentView4InFront")
		assureViewIsShowing("ContentView4")
		pressButton("DismissView4NoAnimation")
		assureViewIsShowing("ContentView1")
	}

	func testPresentVerticalInFront() throws {
		pressButton("PresentView4InFront")
		assureViewIsShowing("ContentView4")
		pressButton("DismissView4Animated")
		assureViewIsShowing("ContentView1")
	}

	func testPresentVerticalBehind() throws {
		pressButton("PresentView4Behind")
		assureViewIsShowing("ContentView4")
		pressButton("DismissView4Animated")
		assureViewIsShowing("ContentView1")
	}

	func testPresentVerticalFade() throws {
		pressButton("PresentView4Fading")
		assureViewIsShowing("ContentView4")
		pressButton("DismissView4Animated")
		assureViewIsShowing("ContentView1")
	}

	func testView4OnView2WithBack() throws {
		pressButton("PushView2")
		assureViewIsShowing("ContentView2")
		pressButton("PresentView4")
		assureViewIsShowing("ContentView4")
		pressButton("DismissView4Animated")
		assureViewIsShowing("ContentView2")
		pressButton("Back")
		assureViewIsShowing("ContentView1")
	}

	func testView4OnView3WithBack() throws {
		pressButton("PushView2")
		assureViewIsShowing("ContentView2")
		pressButton("PushView3")
		assureViewIsShowing("ContentView3")
		pressButton("PresentView4")
		assureViewIsShowing("ContentView4")
		pressButton("DismissView4Animated")
		assureViewIsShowing("ContentView3")
		pressButton("Back")
		assureViewIsShowing("ContentView2")
		pressButton("Back")
		assureViewIsShowing("ContentView1")
	}

	func testBackToRoot() throws {
		pressButton("PushView2")
		assureViewIsShowing("ContentView2")
		pressButton("PushView3")
		assureViewIsShowing("ContentView3")
		pressButton("PopToRoot")
		assureViewIsShowing("ContentView1")
	}

	func testMultipleBack() throws {
		pressButton("PushView2")
		assureViewIsShowing("ContentView2")
		pressButton("PushView3")
		assureViewIsShowing("ContentView3")
		pressButton("Back")
		assureViewIsShowing("ContentView2")
		pressButton("Back")
		assureViewIsShowing("ContentView1")
	}
}
