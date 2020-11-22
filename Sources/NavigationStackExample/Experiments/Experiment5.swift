// This experiment uses the same set up as Experiment4, but instead of using the ternary operator to return back two different views
// here we use it to just return the different transitions, but that doesn't work either.
import NavigationStack
import SwiftUI

struct Experiment5: View {
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
				// We have to separate both transitions in their separate branches, just returning a different transition doesn't work.
				DefaultContent().transition(transitionIndex == 0 ? .move(edge: defaultEdge) : .scale(scale: CGFloat(optionIndex * 2)))
			}
			if showAlternativeContent {
				AlternativeContent().transition(transitionIndex == 0 ? .move(edge: alternativeEdge) : .scale(scale: CGFloat(optionIndex * 2)))
			}
		}
	}
}
