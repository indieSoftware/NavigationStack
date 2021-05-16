import NavigationStack
import SwiftUI

struct ContentView3: View {
	static let id = String(describing: Self.self)

	@EnvironmentObject var navigationModel: NavigationModel

	// Freezes the state of `navigationModel.isAlternativeViewShowing("ContentView2")` to prevent transition animation glitches.
	let isView2Showing: Bool

	var body: some View {
		NavigationStackView(ContentView3.id) {
			HStack {
				VStack(alignment: .leading, spacing: 20) {
					Text(ContentView3.id)

					// It's safe to query the `hasAlternativeViewShowing` state from the model, because it will be frozen by the button view.
					// However, to be safe we could also just pass `true` because View3 is not the root view.
					DismissTopContentButton(hasAlternativeViewShowing: navigationModel.hasAlternativeViewShowing)

					Group {
						Button(action: {
							// Example of the shortcut pop transition, which is a move transition.
							navigationModel.popContent(ContentView1.id)
						}, label: {
							Text("Pop to root (View 1)")
						})
							.accessibility(identifier: "PopToRoot")

						// Using isAlternativeViewShowing from the model to show different sub-views will lead to animation glitches,
						// therefore use the frozen `isView2Showing` value.
						// if navigationModel.isAlternativeViewShowing("ContentView2") {
						if isView2Showing {
							Button(action: {
								navigationModel.popContent(ContentView2.id)
							}, label: {
								Text("Pop to View 2 (w/ animation)")
							})
								.accessibility(identifier: "PopToView2Animated")
						}

						Button(action: {
							// Example of a simple hide transition without animation.
							navigationModel.hideView(ContentView2.id)
							// When no animation has to be played then `onDidAppear` will not be executed.
							// This is not necessary because with no animation the follow-up logic in `onDidAppear` can be instead executed right here.
						}, label: {
							// Using isAlternativeViewShowing from the model to show different sub-views will lead to animation glitches,
							// therefore use the frozen `isView2Showing` value.
							// if navigationModel.isAlternativeViewShowing("ContentView2") {
							if isView2Showing {
								Text("Pop to View 2 (w/o animation)")
							} else {
								Text("Pop to View 2 (not available)")
							}
						})
							.accessibility(identifier: "PopToView2NoAnimation")

						Button(action: {
							navigationModel.presentContent(ContentView3.id) {
								ContentView4(isPresented: navigationModel.viewShowingBinding(ContentView3.id))
							}
						}, label: {
							Text("Present View 4")
						})
							.accessibility(identifier: "PresentView4")
					}

					Spacer()
				}
				Spacer()
			}
			.padding()
			.background(Color.orange.opacity(0.3))
			.onDidAppear {
				print("\(ContentView3.id) did appear")
			}
		}
	}
}

struct ContentView3_Previews: PreviewProvider {
	static var previews: some View {
		ContentView3(isView2Showing: true)
			.environmentObject(NavigationModel())
	}
}
