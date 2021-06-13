import NavigationStack
import SwiftUI

struct ContentView2: View {
	static let id = String(describing: Self.self)

	@EnvironmentObject private var navigationModel: NavigationModel

	var body: some View {
		NavigationStackView(ContentView2.id) {
			HStack {
				VStack(alignment: .leading, spacing: 20) {
					Text(ContentView2.id)

					// It's safe to query the `hasAlternativeViewShowing` state from the model, because it will be frozen by the button view.
					// However, to be safe we could also just pass `true` because View2 is not the root view.
					DismissTopContentButton(hasAlternativeViewShowing: navigationModel.hasAlternativeViewShowing)

					Button(action: {
						// Example of a reset transition via move, which is essentially a pop transition.
						navigationModel.hideView(
							ContentView1.id,
							animation: NavigationAnimation(
								animation: .easeOut,
								defaultViewTransition: .move(edge: .leading),
								alternativeViewTransition: .move(edge: .trailing)
							)
						)
					}, label: {
						Text("Pop to View 1")
					})
						.accessibility(identifier: "PopToView1")

					Button(action: {
						// Example of a combined reset transition.
						navigationModel.hideView(
							ContentView1.id,
							animation: NavigationAnimation(
								animation: .easeOut,
								defaultViewTransition: AnyTransition.scale(scale: 2).combined(with: .opacity),
								alternativeViewTransition: AnyTransition.scale(scale: 0).combined(with: .opacity)
							)
						)
					}, label: {
						Text("Scale down to View 1")
					})
						.accessibility(identifier: "ScaleDownToView1")

					Button(action: {
						// Example of a custom reset transition.
						navigationModel.hideView(
							ContentView1.id,
							animation: NavigationAnimation(
								animation: Animation.easeOut.speed(0.25),
								defaultViewTransition: .circleShape,
								alternativeViewTransition: .circleShape
							)
						)
					}, label: {
						Text("Double Iris to View 1")
					})
						.accessibility(identifier: "DoubleIrisToView1")

					Button(action: {
						navigationModel.pushContent(ContentView2.id) {
							// It's safe to query the `isAlternativeViewShowing` state from the model, because it will be frozen by View3.
							// However, to be sage we could also just pass `true` because View2 is alreaydy showing when transitioning from View2 to View3.
							ContentView3(isView2Showing: navigationModel.isAlternativeViewShowing(ContentView2.id))
						}
					}, label: {
						Text("Push View 3")
					})
						.accessibility(identifier: "PushView3")

					Button(action: {
						navigationModel.presentContent(ContentView2.id) {
							ContentView4(isPresented: navigationModel.viewShowingBinding(ContentView2.id))
						}
					}, label: {
						Text("Present View 4")
					})
						.accessibility(identifier: "PresentView4")

					Spacer()
				}
				Spacer()
			}
			.padding()
			.background(Color.yellow.opacity(0.3))
			.onAppear {
				// onAppear shouldn't be used for views in the navigation stack because it will be called too often!
				print("\(ContentView2.id) onAppear (negative example)")
			}
			.onDidAppear {
				print("\(ContentView2.id) did appear")
			}
		}
	}
}

struct ContentView2_Previews: PreviewProvider {
	static var previews: some View {
		ContentView2()
			.environmentObject(NavigationModel())
	}
}
