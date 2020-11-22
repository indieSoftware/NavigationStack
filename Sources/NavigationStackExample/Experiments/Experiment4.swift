// This experiment uses the ternary operator instead of an if-else branch to return different views with the different transitions applied,
// but that doesn't work.
import NavigationStack
import SwiftUI

struct Experiment4: View {
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
				// Using the ternary operator "?:" doesn't work, we have to use real if-else branches.
				transitionIndex == 0 ? DefaultContent().transition(.move(edge: defaultEdge)) : DefaultContent()
					.transition(.scale(scale: CGFloat(optionIndex * 2)))
			}
			if showAlternativeContent {
				transitionIndex == 0 ? AlternativeContent().transition(.move(edge: alternativeEdge)) : AlternativeContent()
					.transition(.scale(scale: CGFloat(optionIndex * 2)))
			}
		}
	}
}
