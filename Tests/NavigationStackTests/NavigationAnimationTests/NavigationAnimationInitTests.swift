@testable import NavigationStack
import SwiftUI
import XCTest

class NavigationAnimationInitTests: XCTestCase {
	// MARK: - Tests

	// Test the default values are set when initializing a new node.
	func testDefaultValues() throws {
		let result = NavigationAnimation()

		XCTAssertEqual(.default, result.animation)
		XCTAssertNotNil(result.defaultViewTransition)
		XCTAssertNotNil(result.alternativeViewTransition)
		XCTAssertEqual(NavigationAnimation.zIndexOfBehind, result.defaultViewZIndex)
		XCTAssertEqual(NavigationAnimation.zIndexOfInFront, result.alternativeViewZIndex)
	}

	// Test custom values provided are set.
	func testCustomValues() throws {
		let animation = Animation.easeIn
		let result = NavigationAnimation(
			animation: animation,
			defaultViewTransition: .slide,
			alternativeViewTransition: .scale,
			defaultViewZIndex: 43,
			alternativeViewZIndex: 12
		)

		XCTAssertEqual(animation, result.animation)
		XCTAssertNotNil(result.defaultViewTransition)
		XCTAssertNotNil(result.alternativeViewTransition)
		XCTAssertEqual(43, result.defaultViewZIndex)
		XCTAssertEqual(12, result.alternativeViewZIndex)
	}
}
