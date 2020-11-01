import Combine
@testable import NavigationStack
import SwiftUI
import XCTest

class NavigationStackTests: XCTestCase {
	func testExample() throws {
		let node = NavigationStackNode(name: "Foo", alternativeView: { AnyView(EmptyView()) })
		let alternativeContent = { AnyView(EmptyView()) }

		let disposal = node.$alternativeView.sink(receiveValue: { print("ViewModel.alarm updated, new value: \($0)") })
		let disposal2 = node.objectWillChange.sink(receiveValue: { print("ViewModel updated: \($0)") })

		node.alternativeView = alternativeContent
		node.isAlternativeViewShowing = true

		XCTAssertEqual("Foo", node.name)
	}
}
