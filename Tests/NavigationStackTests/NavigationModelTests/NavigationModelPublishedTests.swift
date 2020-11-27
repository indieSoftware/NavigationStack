import Combine
@testable import NavigationStack
import SwiftUI
import XCTest

class NavigationModelPublishedTests: XCTestCase {
	var model: NavigationModel!
	var modelDisposal: AnyCancellable!

	override func setUp() {
		model = NavigationModel(silenceErrors: true)
	}

	private func setupModelPublishExpectation(inverted: Bool = false) {
		let modelExpectation = expectation(description: "model")
		modelExpectation.assertForOverFulfill = false
		modelExpectation.isInverted = inverted
		modelDisposal = model.objectWillChange.sink(
			receiveValue: {
				modelExpectation.fulfill()
			}
		)
	}

	// MARK: - Tests

	// Test calling the method invokes an update-notification to observers.
	func testShowViewPublished() throws {
		setupModelPublishExpectation()

		model.showView("Foo") { EmptyView() }

		waitForExpectations(timeout: 1)
	}

	// Test navigating to a view a second time after first going back triggers an observer.
	func testShowNestedViewAgainAfterHidePublished() throws {
		let viewName1 = "Foo"
		let viewName2 = "Bar"
		model.showView(viewName1) { EmptyView() }
		model.showView(viewName2) { EmptyView() }
		model.hideView(viewName2)
		setupModelPublishExpectation()

		model.showView(viewName2) { EmptyView() }

		waitForExpectations(timeout: 1)
	}

	// Test navigating to the same screen doesn't work.
	func testShowViewTwiceFails() throws {
		let viewName1 = "Foo"
		model.showView(viewName1) { EmptyView() }
		setupModelPublishExpectation()

		model.showView(viewName1) { EmptyView() }

		waitForExpectations(timeout: 1)
	}

	// Test navigating two screens and going back and then navigating again two screens still works.
	func testShowRootViewAgainAfterNestedHidePublished() throws {
		let viewName1 = "Foo"
		let viewName2 = "Bar"
		model.showView(viewName1) { EmptyView() }
		model.showView(viewName2) { EmptyView() }
		model.hideView(viewName1)
		model.showView(viewName1) { EmptyView() }
		setupModelPublishExpectation()

		model.showView(viewName2) { EmptyView() }

		waitForExpectations(timeout: 1)
	}

	// Test calling the method invokes an update-notification to observers.
	func testHideTopViewWithReverseAnimationPublished() throws {
		model.showView("Foo") { EmptyView() }
		setupModelPublishExpectation()

		model.hideTopViewWithReverseAnimation()

		waitForExpectations(timeout: 1)
	}

	// Test calling the method invokes not an update-notification to observers when the preconditions are not met.
	func testHideTopViewWithReverseAnimationNotPublished() throws {
		setupModelPublishExpectation(inverted: true)

		model.hideTopViewWithReverseAnimation()

		waitForExpectations(timeout: 1)
	}

	// Test calling the method invokes an update-notification to observers.
	func testHideTopViewPublished() throws {
		model.showView("Foo") { EmptyView() }
		setupModelPublishExpectation()

		model.hideTopView(animation: NavigationAnimation())

		waitForExpectations(timeout: 1)
	}

	// Test calling the method invokes not an update-notification to observers when the preconditions are not met.
	func testHideTopViewNotPublished() throws {
		setupModelPublishExpectation(inverted: true)

		model.hideTopView(animation: NavigationAnimation())

		waitForExpectations(timeout: 1)
	}

	// Test calling the method invokes an update-notification to observers.
	func testHideViewPublished() throws {
		model.showView("Foo") { EmptyView() }
		setupModelPublishExpectation()

		model.hideView("Foo", animation: NavigationAnimation())

		waitForExpectations(timeout: 1)
	}

	// Test calling the method invokes not an update-notification to observers when the preconditions are not met.
	func testHideViewNotPublished() throws {
		model.showView("Foo") { EmptyView() }
		setupModelPublishExpectation(inverted: true)

		model.hideView("Bar", animation: NavigationAnimation())

		waitForExpectations(timeout: 1)
	}

	// Test calling the method invokes an update-notification to observers.
	func testHideViewWithReverseAnimationPublished() throws {
		model.showView("Foo") { EmptyView() }
		setupModelPublishExpectation()

		model.hideViewWithReverseAnimation("Foo")

		waitForExpectations(timeout: 1)
	}

	// Test calling the method invokes not an update-notification to observers when the preconditions are not met.
	func testHideViewWithReverseAnimationNotPublished() throws {
		model.showView("Foo") { EmptyView() }
		setupModelPublishExpectation(inverted: true)

		model.hideViewWithReverseAnimation("Bar")

		waitForExpectations(timeout: 1)
	}
}
