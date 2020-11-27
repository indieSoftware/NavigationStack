@testable import NavigationStack
import SwiftUI
import XCTest

class NavigationModelStub: NavigationModel {
	var showViewStub: (_ name: String, _ animation: NavigationAnimation?) -> Void = { _, _ in XCTFail() }

	override func showView<Content>(_ name: String, animation: NavigationAnimation? = nil, alternativeView _: @escaping () -> Content) where Content: View {
		showViewStub(name, animation)
	}

	var hideViewStub: (_ name: String, _ animation: NavigationAnimation?) -> Void = { _, _ in XCTFail() }

	override func hideView(_ name: String, animation: NavigationAnimation? = nil) {
		hideViewStub(name, animation)
	}
}
