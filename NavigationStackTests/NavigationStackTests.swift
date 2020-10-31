import Combine
@testable import NavigationStack
import SwiftUI
import XCTest

class NavigationStackTests: XCTestCase {
	func testExample() throws {
		let contentNode = NavigationStackNode(name: "Foo", alternativeContent: { AnyView(EmptyView()) })
		let alternativeContent = { AnyView(EmptyView()) }

		let disposal = contentNode.$alternativeContent.sink(receiveValue: { print("ViewModel.alarm updated, new value: \($0)") })
		let disposal2 = contentNode.objectWillChange.sink(receiveValue: { print("ViewModel updated: \($0)") })

		contentNode.alternativeContent = alternativeContent
		contentNode.isAlternativeContentShowing = true

		XCTAssertEqual("Foo", contentNode.name)
	}
}
