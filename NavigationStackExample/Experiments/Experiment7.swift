// This experiment works like Experiment1, but shows a glitch when accessing the showAlternativeContent state inside of a sub-view.
import NavigationStack
import SwiftUI

struct Experiment7: View {
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
					DefaultContent2(alternativeContentShowing: $showAlternativeContent).transition(.move(edge: defaultEdge))
				} else {
					DefaultContent2(alternativeContentShowing: $showAlternativeContent).transition(.scale(scale: CGFloat(optionIndex * 2)))
				}
			}
			if showAlternativeContent {
				if transitionIndex == 0 {
					AlternativeContent2(alternativeContentShowing: $showAlternativeContent).transition(.move(edge: alternativeEdge))
				} else {
					AlternativeContent2(alternativeContentShowing: $showAlternativeContent).transition(.scale(scale: CGFloat(optionIndex * 2)))
				}
			}
		}
	}

	struct DefaultContent2: View {
		// let alternativeContentShowing: Bool
		// This binding leads to animation glitches, use a non-binding instead (uncomment the line above) to solve this.
		@Binding var alternativeContentShowing: Bool
		var body: some View {
			ZStack {
				ContentText(alternativeContentShowing: alternativeContentShowing)
				Color(.green)
					.opacity(0.5)
			}
		}
	}

	struct AlternativeContent2: View {
		// let alternativeContentShowing: Bool
		// This binding leads to animation glitches, use a non-binding instead (uncomment the line above) to solve this.
		@Binding var alternativeContentShowing: Bool
		var body: some View {
			ZStack {
				ContentText(alternativeContentShowing: alternativeContentShowing)
				Color(.orange)
					.opacity(0.5)
			}
		}
	}

	struct ContentText: View {
		let alternativeContentShowing: Bool
		var body: some View {
			if !alternativeContentShowing {
				Text("Default Content (Green)")
			} else {
				Text("Alternative Content (Orange)")
			}
		}
	}
}
