import NavigationStack
import SwiftUI

struct TransitionExamples: View {
	static let rootContentName = "TransitionExamples"
	static let transitionSpeed = 0.75

	@EnvironmentObject var navigationModel: NavigationModel

	var body: some View {
		NavigationStackView(TransitionExamples.rootContentName) {
			HStack {
				ScrollView {
					VStack(alignment: .leading, spacing: 20) {
						Button(action: {
							navigationModel.hideTopViewWithReverseAnimation()
						}, label: {
							Text("Dismiss Transition Examples")
						})
							.accessibility(identifier: "BackButton")

						transitionExample(name: "Move", transition: .move(edge: .trailing))
						transitionExample(name: "Scale", transition: .scale(scale: 0.0, anchor: UnitPoint(x: 0.2, y: 0.2)))
						transitionExample(name: "Offset", transition: .offset(x: 100, y: 100))
						transitionExample(name: "Opacity", transition: .opacity)
						transitionExample(name: "Slide", transition: .slide)
						transitionExample(name: "Static", transition: .static)
						transitionExample(name: "Iris", transition: .iris)
						transitionExample(name: "Contrast", transition: .contrast(active: 0.0, identity: 1.0))

						Spacer()
					}
				}
				Spacer()
			}
			.padding()
			.background(Color(UIColor.green).opacity(1.0))
		}
	}

	func transitionExample(name: String, transition: AnyTransition) -> some View {
		Button(name) {
			navigationModel.showView(
				TransitionExamples.rootContentName,
				animation: NavigationAnimation(
					animation: Animation.easeOut.speed(TransitionExamples.transitionSpeed),
					defaultViewTransition: .static,
					alternativeViewTransition: transition
				)
			) {
				TransitionDestinationView()
			}
		}
		.accessibility(identifier: "\(name)Button")
	}
}

struct TransitionDestinationView: View {
	@EnvironmentObject var navigationModel: NavigationModel

	var body: some View {
		Button(action: {
			navigationModel.hideTopViewWithReverseAnimation()
		}, label: {
			HStack(alignment: .center) {
				Spacer()
				VStack(alignment: .center, spacing: 20) {
					Spacer()
					Text("Dismiss")
					Spacer()
				}
				Spacer()
			}
		})
			.accessibility(identifier: "BackButton")
			.padding()
			.background(Color(UIColor.yellow).opacity(1.0))
	}
}

struct TransitionExamples_Previews: PreviewProvider {
	static var previews: some View {
		TransitionExamples()
			.environmentObject(NavigationModel())
		TransitionDestinationView()
			.environmentObject(NavigationModel())
	}
}
