// Issue report: https://github.com/indieSoftware/NavigationStack/issues/1
// With v1.0.2 the push is not visually executed sometimes.
// Could be reproduced with iOS 14.4, but not anymore with iOS 14.5.
// When starting the app with this text multiple times then sometimes the animation doesn't apply
// and the pushed screen is not visible even when the nav stack is correclty set after the called push.
// It seems this happens because of `isAlternativeViewShowingPrecede` is set to true in `NavigationStackModel`
// and immediately after that `isAlternativeViewShowing` is also set to true within a `withAnimation` block.
// When wrapping the last assignment inclusive the `withAnimation` block into a `DispatchQueue.main.asyncAfter(deadline: .now())` seems to solve this issue.
// It seems with iOS 14.5 it's also solved, therefore, the applied changes for this were reverted.

import NavigationStack
import SwiftUI

struct Experiment10: View {
	var body: some View {
		ContentView()
			.environmentObject(NavigationModel())
	}
}

private struct SecondScreen: View {
	@EnvironmentObject var navigationModel: NavigationModel
	var body: some View {
		ZStack {
			Color.blue
			VStack {
				Spacer()
				HStack {
					Spacer()
					VStack {
						Text("Screen 2")
							.foregroundColor(.white)
						Button(action: {
							print("NavStack: \(navigationModel)")
						}, label: {
							Text("Print nav stack")
								.foregroundColor(.white)
						})
					}
					Spacer()
				}
				Spacer()
			}
		}
	}
}

private struct ContentView: View {
	static let id = String(describing: Self.self)
	@EnvironmentObject var navigationModel: NavigationModel

	var body: some View {
		NavigationStackView(ContentView.id) {
			ZStack {
				Color.red
				VStack {
					Spacer()
					HStack {
						Spacer()
						VStack {
							Text("Screen 1")
							Button(action: {
								print("NavStack: \(navigationModel)")
							}, label: {
								Text("Print nav stack")
							})
						}
						Spacer()
					}
					Spacer()
				}
			}.edgesIgnoringSafeArea(.all)
		}
		.onAppear {
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { // It seems with a higher delay the issue happens more often
				print("Push executed")
				self.navigationModel.showView(ContentView.id, animation: .push) { // When applying nil as animation this issue never happens
					SecondScreen()
				}
			}
		}
	}
}
