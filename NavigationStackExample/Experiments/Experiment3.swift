// This experiment tries to save the transition into a state property, but that doesn't work.
import NavigationStack
import SwiftUI

struct Experiment3: View {
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
				// Using a saved transition doesn't work, we have to write it explicitely out.
				DefaultContent().transition(defaultTransition)
			}
			if showAlternativeContent {
				AlternativeContent().transition(alternativeTransition)
			}
		}
	}
}
