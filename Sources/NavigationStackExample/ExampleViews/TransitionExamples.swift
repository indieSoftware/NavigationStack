import NavigationStack
import SwiftUI

struct TransitionExamples: View {
	static let id = String(describing: Self.self)
	static let transitionSpeed = 0.75

	@EnvironmentObject var navigationModel: NavigationModel

	var body: some View {
		NavigationStackView(TransitionExamples.id) {
			ScrollView {
				HStack {
					VStack(alignment: .leading, spacing: 20) {
						Button(action: {
							navigationModel.hideTopViewWithReverseAnimation()
						}, label: {
							Text("Dismiss Transition Examples")
						})
							.accessibility(identifier: "BackButton")

						// SwiftUI transitions
						Group {
							transitionExample(name: "Move", transition: .move(edge: .trailing))
							transitionExample(name: "Scale", transition: .scale(scale: 0.0, anchor: UnitPoint(x: 0.2, y: 0.2)))
							transitionExample(name: "Offset", transition: .offset(x: 100, y: 100))
							transitionExample(name: "Opacity", transition: .opacity)
							transitionExample(name: "Slide", transition: .slide)
							transitionExample(name: "Identity", transition: .identity)
						}

						// Identity replacement
						transitionExample(name: "Static", transition: .static)

						// Transitions with SwiftUI effects
						Group {
							transitionExample(name: "Blur", transition: .blur(radius: 100))
							transitionExample(name: "Brightness", transition: .brightness())
							transitionExample(name: "Contrast", transition: .contrast(-1))
							transitionExample(name: "HueRotation", transition: .hueRotation(.degrees(360)))
							transitionExample(name: "Saturation", transition: .saturation())
						}

						// Custom transitions
						Group {
							transitionExample(name: "TiltAndFly", transition: .tiltAndFly)
							transitionExample(name: "CircleShape", transition: .circleShape)
							transitionExample(name: "RectangleShape", transition: .rectangleShape)
							transitionExample(name: "StripesHorizontalDown", transition: .stripes(stripes: 5, horizontal: true))
							transitionExample(name: "StripesHorizontalUp", transition: .stripes(stripes: 5, horizontal: true, inverted: true))
							transitionExample(name: "StripesVerticalRight", transition: .stripes(stripes: 5, horizontal: false))
							transitionExample(name: "StripesVerticalLeft", transition: .stripes(stripes: 5, horizontal: false, inverted: true))
						}

						Spacer()
					}
					Spacer()
				}
			}
			.padding()
			.background(Color(UIColor.green).opacity(1.0))
		}
	}

	func transitionExample(name: String, transition: AnyTransition) -> some View {
		Button(name) {
			navigationModel.showView(
				TransitionExamples.id,
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
