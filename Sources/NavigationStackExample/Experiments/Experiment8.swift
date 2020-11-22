// This experiment tries like Experiment3 to save the transition into a property rather than in a state.
// This works when using a pre-update step for switching the content.
import NavigationStack
import SwiftUI

struct Experiment8: View {
	@State var animationIndex = 0
	@State var transitionIndex = 0
	@State var optionIndex = 0

	@State var showAlternativeContentPreStep = false
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

				showAlternativeContentPreStep.toggle() // First update the view with the new transition, but without animation.
				withAnimation(animation) {
					showAlternativeContent.toggle() // Then update the view with the previously applied transition and with animation.
				}
			}

			if showAlternativeContentPreStep { // This pre-step solves the animation glitch.
				if !showAlternativeContent {
					DefaultContent().transition(defaultTransition)
				}
				if showAlternativeContent {
					AlternativeContent().transition(alternativeTransition)
				}
			} else {
				if !showAlternativeContent {
					DefaultContent().transition(defaultTransition)
				}
				if showAlternativeContent {
					AlternativeContent().transition(alternativeTransition)
				}
			}
		}
	}
}
