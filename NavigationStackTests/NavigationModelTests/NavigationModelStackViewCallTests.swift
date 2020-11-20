@testable import NavigationStack
import SwiftUI
import XCTest

class NavigationModelStackViewCallTests: XCTestCase {
	var model: NavigationModel!

	override func setUp() {
		model = NavigationModel(silenceErrors: true)
	}

	// MARK: - Tests

	func testIsAlternativeViewShowingPrecedeFalse() throws {
		let result = model.isAlternativeViewShowingPrecede("Foo")

		XCTAssertFalse(result)
	}

	func testIsAlternativeViewShowingPrecede() throws {
		model.showView("Foo") { EmptyView() }

		let result = model.isAlternativeViewShowingPrecede("Foo")

		XCTAssertTrue(result)
	}

	func testAlternativeViewFalse() throws {
		let result = model.alternativeView("Foo")

		XCTAssertNil(result)
	}

	func testAlternativeView() throws {
		model.showView("Foo") { EmptyView() }

		let result = model.alternativeView("Foo")

		XCTAssertNotNil(result)
	}

	func testDefaultViewTransitionFalse() throws {
		let result = model.defaultViewTransition("Foo")

		XCTAssertNotNil(result)
	}

	func testDefaultViewTransition() throws {
		model.showView("Foo") { EmptyView() }

		let result = model.defaultViewTransition("Foo")

		XCTAssertNotNil(result)
	}

	func testAlternativeViewTransitionFalse() throws {
		let result = model.alternativeViewTransition("Foo")

		XCTAssertNotNil(result)
	}

	func testAlternativeViewTransition() throws {
		model.showView("Foo") { EmptyView() }

		let result = model.alternativeViewTransition("Foo")

		XCTAssertNotNil(result)
	}

	func testDefaultViewZIndexFalse() throws {
		let result = model.defaultViewZIndex("Foo")

		XCTAssertEqual(.zero, result)
	}

	func testDefaultViewZIndex() throws {
		model.showView(
			"Foo",
			animation: NavigationAnimation(
				animation: .default,
				defaultViewTransition: .slide,
				alternativeViewTransition: .opacity,
				defaultViewZIndex: 22,
				alternativeViewZIndex: 55
			)
		) { EmptyView() }

		let result = model.defaultViewZIndex("Foo")

		XCTAssertEqual(22, result)
	}

	func testAlternativeViewZIndexFalse() throws {
		let result = model.alternativeViewZIndex("Foo")

		XCTAssertEqual(.zero, result)
	}

	func testAlternativeViewZIndex() throws {
		model.showView(
			"Foo",
			animation: NavigationAnimation(
				animation: .default,
				defaultViewTransition: .slide,
				alternativeViewTransition: .opacity,
				defaultViewZIndex: 22,
				alternativeViewZIndex: 55
			)
		) { EmptyView() }

		let result = model.alternativeViewZIndex("Foo")

		XCTAssertEqual(55, result)
	}
}
