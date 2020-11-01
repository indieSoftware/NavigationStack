import SwiftUI

public extension NavigationModel {
	func pushContent<Content: View>(_ name: String, @ViewBuilder alternativeView: @escaping () -> Content) {
		showView(name, animation: .push, alternativeView: alternativeView)
	}

	func popContent(_ name: String) {
		hideView(name, animation: .pop)
	}

	func presentContent<Content: View>(_ name: String, @ViewBuilder alternativeView: @escaping () -> Content) {
		showView(name, animation: .present, alternativeView: alternativeView)
	}

	func dismissContent(_ name: String) {
		hideView(name, animation: .dismiss)
	}

	func fadeInContent<Content: View>(_ name: String, @ViewBuilder alternativeView: @escaping () -> Content) {
		showView(name, animation: .fade, alternativeView: alternativeView)
	}

	func fadeOutContent(_ name: String) {
		hideView(name, animation: .fade)
	}
}
