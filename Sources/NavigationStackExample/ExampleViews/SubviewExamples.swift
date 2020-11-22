import NavigationStack
import SwiftUI

// This example tries to use the framework to navigate between sub-views.
// However, this not really a navigation and leads to problems because the navigation is designed to hold a nested tree,
// therefore, it's not recommended to use the navigation framework for switching sub-views.
struct SubviewExamples: View {
	let subview1Name = "Subview1"
	let subview2Name = "Subview2"

	@EnvironmentObject var navigationModel: NavigationModel

	var body: some View {
		HStack {
			VStack(alignment: .leading, spacing: 20) {
				Button(action: {
					navigationModel.hideTopViewWithReverseAnimation()
				}, label: {
					Text("Back")
				})
					.accessibility(identifier: "BackButton")

				Button(action: {
					navigationModel.showView(subview1Name, animation: NavigationAnimation.push) {
						ColoredSubview(color: .blue)
					}
				}, label: {
					Text("Push Subview1")
				})
					.accessibility(identifier: "Subview1Button")
				NavigationStackView(subview1Name) {
					ColoredSubview(color: .black)
				}

				Button(action: {
					navigationModel.showView(subview2Name, animation: NavigationAnimation.push) {
						ColoredSubview(color: .red)
					}
				}, label: {
					Text("Push Subview2")
				})
					.accessibility(identifier: "Subview2Button")
				NavigationStackView(subview2Name) {
					ColoredSubview(color: .black)
				}

				Button(action: {
					navigationModel.hideViewWithReverseAnimation(subview2Name)
				}, label: {
					Text("Reset Subview2")
				})
					.accessibility(identifier: "ResetButton")

				Spacer()
			}
			Spacer()
		}
		.padding()
		.background(Color.white)
	}
}

struct SubviewExamples_Previews: PreviewProvider {
	static var previews: some View {
		SubviewExamples()
			.environmentObject(NavigationModel())
	}
}

struct ColoredSubview: View {
	let color: UIColor

	var body: some View {
		Color(color)
			.frame(width: 200, height: 150)
	}
}
