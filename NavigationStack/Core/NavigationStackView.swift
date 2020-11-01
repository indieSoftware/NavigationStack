import SwiftUI

public struct NavigationStackView: View {
	@EnvironmentObject private var model: NavigationModel

	let name: String
	private let defaultView: AnyViewBuilder

	public init<Content>(_ name: String, @ViewBuilder defaultView: @escaping () -> Content) where Content: View {
		self.name = name
		self.defaultView = { AnyView(defaultView()) }
	}

	public var body: some View {
		ZStack {
			if model.isAlternativeViewShowingPrecede(name) { // `if-else` is necessary, see Experiment8
				ContentViews(name: name, defaultView: defaultView)
			} else {
				ContentViews(name: name, defaultView: defaultView)
			}
		}
	}
}

private struct ContentViews: View {
	@EnvironmentObject private var model: NavigationModel

	let name: String
	let defaultView: AnyViewBuilder

	var body: some View {
		ZStack {
			if !model.isAlternativeViewShowing(name) {
				defaultView().transition(model.defaultViewTransition(name)).zIndex(model.defaultViewZIndex(name))
			} // No `else`, see Experiment2
			if model.isAlternativeViewShowing(name), let alternativeView = model.alternativeView(name) {
				alternativeView().transition(model.alternativeViewTransition(name)).zIndex(model.alternativeViewZIndex(name))
			}
		}
	}
}
