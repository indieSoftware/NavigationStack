// This experiment is the same as Experiment1, but tries to transform the if-else branch into something more generic.
// It's possibile to use a switch statement and extracting it into a subview.
import NavigationStack
import SwiftUI

struct Experiment6: View {
	@State var animationIndex = 0
	@State var transitionIndex = 0
	@State var optionIndex = 0

	@State var showAlternativeContent = false

	@State var animation = Animation.linear
	@State var defaultEdge = Edge.leading
	@State var alternativeEdge = Edge.trailing
	@State var defaultTransition = AnyTransition.identity
	@State var alternativeTransition = AnyTransition.identity

	var body: some View {
		VStack(spacing: 20) {
			Pickers(animationIndex: $animationIndex, transitionIndex: $transitionIndex, optionIndex: $optionIndex)

			ToggleContentButton(showAlternativeContent: $showAlternativeContent) {
				switch animationIndex {
				case 0:
					animation = Animation.linear.speed(experimentAnimationSpeedFactor)
				case 1:
					animation = Animation.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 2.5).speed(experimentAnimationSpeedFactor)
				default:
					break
				}

				switch optionIndex {
				case 0:
					defaultEdge = .leading
					alternativeEdge = .trailing
				case 1:
					defaultEdge = .top
					alternativeEdge = .bottom
				default:
					break
				}

				switch transitionIndex {
				case 0:
					defaultTransition = .move(edge: defaultEdge)
					alternativeTransition = .move(edge: alternativeEdge)
				case 1:
					defaultTransition = .scale(scale: CGFloat(optionIndex * 2))
					alternativeTransition = .scale(scale: CGFloat(optionIndex * 2))
				default:
					break
				}

				withAnimation(animation) {
					showAlternativeContent.toggle()
				}
			}

			if !showAlternativeContent {
				DefaultContent4(transitionIndex: $transitionIndex, defaultEdge: $defaultEdge, optionIndex: $optionIndex)
			}
			if showAlternativeContent {
				switch transitionIndex {
				case 0:
					AlternativeContent().transition(.move(edge: alternativeEdge))
				case 1:
					AlternativeContent().transition(.scale(scale: CGFloat(optionIndex * 2)))
				default:
					Text("Undefined alternative transition")
				}
			}
		}
	}

	/*
	 private func defaultContent1() -> AnyView {
	 	switch defaultTransition { // This is just an opaque type of AnyTransition and not an enum!
	 	case .move(edge: _): // '_' can only appear in a pattern or on the left side of an assignment
	 		return AnyView(DefaultContent().transition(.move(edge: defaultEdge)))
	 	default:
	 		return AnyView(Text("Undefined default transition"))
	 	}
	 }

	 private func defaultContent2() -> AnyView {
	 	switch transitionIndex {
	 	case 0:
	 		return AnyView(DefaultContent().transition(.move(edge: defaultEdge))) // No transition because the transition view is inside of AnyView
	 	default:
	 		return AnyView(Text("Undefined default transition"))
	 	}
	 }

	 private func defaultContent3() -> AnyView {
	 	switch transitionIndex {
	 	case 0:
	 		return AnyView(DefaultContent())
	 			.transition(.move(edge: defaultEdge)) // Cannot convert return expression of type 'some View' to return type 'AnyView'
	 	default:
	 		return AnyView(Text("Undefined default transition"))
	 	}
	 }
	 */
	private struct DefaultContent4: View {
		@Binding var transitionIndex: Int
		@Binding var defaultEdge: Edge
		@Binding var optionIndex: Int
		var body: some View {
			switch transitionIndex {
			case 0:
				DefaultContent().transition(.move(edge: defaultEdge))
			case 1:
				DefaultContent().transition(.scale(scale: CGFloat(optionIndex * 2)))
			default:
				Text("Undefined default transition")
			}
		}
	}
}
