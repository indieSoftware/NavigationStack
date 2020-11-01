import NavigationStack
import SwiftUI

struct ContentView1: View {
	@EnvironmentObject var navigationModel: NavigationModel

	var body: some View {
		NavigationStackView("ContentView1") {
			HStack {
				VStack(alignment: .leading, spacing: 20) {
					Text("Content View 1")

					// It's safe to query the `hasAlternativeViewShowing` state from the model, because it will be frozen by the button view.
					// However, to be safe we could also just pass `false` because View1 is the root view.
					DismissTopContentButton(hasAlternativeViewShowing: navigationModel.hasAlternativeViewShowing)

					Group {
						Button(action: {
							// Example of a simple move transition which could also be replaced by `NavigationAnimation.push`.
							navigationModel.showView(
								"ContentView1",
								// animation: NavigationAnimation.push
								animation: NavigationAnimation(
									animation: .easeOut,
									defaultViewTransition: .move(edge: .leading),
									alternativeViewTransition: .move(edge: .trailing)
								)
							) {
								ContentView2()
							}
						}, label: {
							Text("Push View 2")
						})

						Button(action: {
							// Example of a combined transition usage, here scale is combined with opacity.
							navigationModel.showView(
								"ContentView1",
								animation: NavigationAnimation(
									animation: .easeOut,
									defaultViewTransition: AnyTransition.scale(scale: 2).combined(with: .opacity),
									alternativeViewTransition: AnyTransition.scale(scale: 0).combined(with: .opacity)
								)
							) {
								ContentView2()
							}
						}, label: {
							Text("Scale up to View 2")
						})

						Button(action: {
							// Example of a custom transition usage, here an iris effect is used to show the alternative content.
							navigationModel.showView(
								"ContentView1",
								animation: NavigationAnimation(
									animation: Animation.easeOut.speed(0.25),
									defaultViewTransition: .static,
									alternativeViewTransition: .iris
								)
							) {
								ContentView2()
							}
						}, label: {
							Text("Single Iris to View 2")
						})

						Button(action: {
							// Example of a horizontal move transition via shortcut naming.
							navigationModel.pushContent("ContentView1") {
								// It's safe to query the `isAlternativeViewShowing` state from the model, because it will be frozen by View3.
								// However, to be safe we could also just pass `false` because View2 will not be shown when transitioning from View1 to View3 directly.
								ContentView3(isView2Showing: navigationModel.isAlternativeViewShowing("ContentView2"))
							}
						}, label: {
							Text("Push View 3")
						})
					}
					Group {
						Button(action: {
							// Example of a vertical move transition via shortcut naming.
							navigationModel.presentContent("ContentView1") {
								ContentView4(isPresented: navigationModel.viewShowingBinding("ContentView1"))
							}
						}, label: {
							Text("Present View 4 (View 4 in front of View 1)")
						})

						Button(action: {
							// Example of how to change the zIndex of views, showing here View4 behind View1.
							navigationModel.showView(
								"ContentView1",
								animation: NavigationAnimation(
									animation: .easeOut,
									defaultViewTransition: .static,
									alternativeViewTransition: .move(edge: .bottom),
									defaultViewZIndex: NavigationAnimation.zIndexOfInFront,
									alternativeViewZIndex: NavigationAnimation.zIndexOfBehind
								)
							) {
								ContentView4(isPresented: navigationModel.viewShowingBinding("ContentView1"))
							}
						}, label: {
							Text("Present View 4 (View 4 behind View 1)")
						})

						Button(action: {
							// Example of a fade transition via shortcut naming.
							navigationModel.fadeInContent("ContentView1") {
								ContentView4(isPresented: navigationModel.viewShowingBinding("ContentView1"))
							}
						}, label: {
							Text("Present View 4 via fading")
						})

						Button(action: {
							navigationModel.presentContent("ContentView1") {
								TransitionExamples()
							}
						}, label: {
							Text("Show Transition Examples")
						})

						Button(action: {
							navigationModel.presentContent("ContentView1") {
								SubviewExamples()
							}
						}, label: {
							Text("Show Subview Examples")
						})
							.accessibility(identifier: "SubviewExamplesButton")
					}

					Spacer()
				}
				Spacer()
			}
			.padding()
			.background(Color.green.opacity(0.3))
		}
	}
}

struct ContentView1_Previews: PreviewProvider {
	static var previews: some View {
		ContentView1()
			.environmentObject(NavigationModel())
	}
}
