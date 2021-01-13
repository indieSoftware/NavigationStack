@testable import NavigationStack
import SwiftUI
import XCTest

class NavigationModelStub: NavigationModel {
	var showViewStub: (_ identifier: String, _ animation: NavigationAnimation?) -> Void = { _, _ in XCTFail() }

	override func showView<Content>(_ identifier: String, animation: NavigationAnimation? = nil, alternativeView _: @escaping () -> Content)
		where Content: View
	{
		showViewStub(identifier, animation)
	}

	var hideViewStub: (_ identifier: String, _ animation: NavigationAnimation?) -> Void = { _, _ in XCTFail() }

	override func hideView(_ identifier: String, animation: NavigationAnimation? = nil) {
		hideViewStub(identifier, animation)
	}
}
