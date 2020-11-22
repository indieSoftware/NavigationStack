// This experiment tries to use an if-else branch to switch the default and alternative content view, but that doesn't work.
import NavigationStack
import SwiftUI

struct Experiment2: View {
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
				if transitionIndex == 0 {
					DefaultContent().transition(.move(edge: defaultEdge))
				} else {
					DefaultContent().transition(.scale(scale: CGFloat(optionIndex * 2)))
				}
			} else if showAlternativeContent { // Using an else-branch doesn't work, we have to separate both if-statement.
				if transitionIndex == 0 {
					AlternativeContent().transition(.move(edge: alternativeEdge))
				} else {
					AlternativeContent().transition(.scale(scale: CGFloat(optionIndex * 2)))
				}
			}
		}
	}
}
