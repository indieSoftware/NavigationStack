import SwiftUI

public extension NavigationModel {
	func pushContent<Content: View>(_ name: String, @ViewBuilder alternativeContent: @escaping () -> Content) {
		showContent(name, animation: .push, alternativeContent: alternativeContent)
	}

	func popContent(_ name: String) {
		resetContent(name, animation: .pop)
	}

	func presentContent<Content: View>(_ name: String, @ViewBuilder alternativeContent: @escaping () -> Content) {
		showContent(name, animation: .present, alternativeContent: alternativeContent)
	}

	func dismissContent(_ name: String) {
		resetContent(name, animation: .dismiss)
	}

	func fadeInContent<Content: View>(_ name: String, @ViewBuilder alternativeContent: @escaping () -> Content) {
		showContent(name, animation: .fade, alternativeContent: alternativeContent)
	}

	func fadeOutContent(_ name: String) {
		resetContent(name, animation: .fade)
	}
}
