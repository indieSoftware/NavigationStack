import SwiftUI

public struct NavigationStackView: View {
	@EnvironmentObject private var model: NavigationModel

	private let name: String
	private let defaultContent: ContentBuilder

	public init<Content>(_ name: String, @ViewBuilder defaultContent: @escaping () -> Content) where Content: View {
		self.name = name
		self.defaultContent = { AnyView(defaultContent()) }
	}

	public var body: some View {
		ZStack {
			if model.isAlternativeContentShowingPrecede(name) { // `if-else` is necessary, see Experiment8
				ContentViews(name: name, defaultContent: defaultContent)
			} else {
				ContentViews(name: name, defaultContent: defaultContent)
			}
		}
	}
}

private struct ContentViews: View {
	@EnvironmentObject private var model: NavigationModel
	let name: String
	let defaultContent: ContentBuilder
	var body: some View {
		if !model.isAlternativeContentShowing(name) {
			defaultContent().transition(model.defaultContentTransition(name)).zIndex(model.defaultContentZIndex(name))
		} // No `else`, see Experiment2
		if model.isAlternativeContentShowing(name), let alternativeContent = model.alternativeContent(name) {
			alternativeContent().transition(model.alternativeContentTransition(name)).zIndex(model.alternativeContentZIndex(name))
		}
	}
}
