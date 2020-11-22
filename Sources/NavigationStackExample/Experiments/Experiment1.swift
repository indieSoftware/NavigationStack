// This experiment includes knowledge from experiment 2 to 5 to get the transition animation working as expected.
import NavigationStack
import SwiftUI

struct Experiment1: View {
	@State var animationIndex = 0
	@State var transitionIndex = 0
	@State var optionIndex = 0

	@State var showAlternativeContent = false

	@State var animation = Animation.linear
	@State var defaultEdge = Edge.leading
	@State var alternativeEdge = Edge.trailing

	var body: some View {
		VStack(spacing: 20) {
			Pickers(animationIndex: $animationIndex, transitionIndex: $transitionIndex, optionIndex: $optionIndex)

			ToggleContentButton(showAlternativeContent: $showAlternativeContent) {
				// Set the animation and the transition before the withAnimation block to update it before visualising it
				// and to decouple these states from the picker variables.
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

				withAnimation(animation) {
					showAlternativeContent.toggle()
				}
			}

			if !showAlternativeContent {
				if transitionIndex == 0 {
					DefaultContent().transition(.move(edge: defaultEdge))
				} else {
					DefaultContent().transition(.scale(scale: CGFloat(optionIndex * 2)))
				}
			}
			if showAlternativeContent {
				if transitionIndex == 0 {
					AlternativeContent().transition(.move(edge: alternativeEdge))
				} else {
					AlternativeContent().transition(.scale(scale: CGFloat(optionIndex * 2)))
				}
			}
		}
	}
}
