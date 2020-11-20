@testable import NavigationStack
import SwiftUI
import XCTest

class NavigationModelStateTests: XCTestCase {
	var model: NavigationModel!

	override func setUp() {
		model = NavigationModel(silenceErrors: true)
	}

	// MARK: - Tests

	func testHasAlternativeViewShowingFalse() throws {
		let result = model.hasAlternativeViewShowing

		XCTAssertFalse(result)
	}

	func testHasAlternativeViewShowing() throws {
		model.showView("Foo") { EmptyView() }

		let result = model.hasAlternativeViewShowing

		XCTAssertTrue(result)
	}

	func testIsAlternativeViewShowingFalse() throws {
		let result = model.isAlternativeViewShowing("Foo")

		XCTAssertFalse(result)
	}

	func testIsAlternativeViewShowing() throws {
		model.showView("Foo") { EmptyView() }

		let result = model.isAlternativeViewShowing("Foo")

		XCTAssertTrue(result)
	}

	func testTopViewShowingBindingFalse() throws {
		let binding = model.topViewShowingBinding()

		XCTAssertNotNil(binding)
		XCTAssertFalse(binding.wrappedValue)

		binding.wrappedValue.toggle()

		XCTAssertFalse(binding.wrappedValue)
	}

	func testTopViewShowingBinding() throws {
		model.showView("Foo") { EmptyView() }

		let binding = model.topViewShowingBinding()

		XCTAssertNotNil(binding)
		XCTAssertTrue(binding.wrappedValue)
		XCTAssertTrue(model.isAlternativeViewShowing("Foo"))

		binding.wrappedValue.toggle()

		XCTAssertFalse(binding.wrappedValue)
		XCTAssertFalse(model.isAlternativeViewShowing("Foo"))
	}

	func testViewShowingBindingFalse() throws {
		model.showView("Foo") { EmptyView() }

		let binding = model.viewShowingBinding("Bar")

		XCTAssertNotNil(binding)
		XCTAssertFalse(binding.wrappedValue)

		binding.wrappedValue.toggle()

		XCTAssertFalse(binding.wrappedValue)
	}

	func testViewShowingBinding() throws {
		model.showView("Foo") { EmptyView() }

		let binding = model.viewShowingBinding("Foo")

		XCTAssertNotNil(binding)
		XCTAssertTrue(binding.wrappedValue)
		XCTAssertTrue(model.isAlternativeViewShowing("Foo"))

		binding.wrappedValue.toggle()

		XCTAssertFalse(binding.wrappedValue)
		XCTAssertFalse(model.isAlternativeViewShowing("Foo"))
	}
}
