import NavigationStack
import SwiftUI

struct ContentView2: View {
	static let navigationName = String(describing: Self.self)

	@EnvironmentObject var navigationModel: NavigationModel

	var body: some View {
		NavigationStackView(ContentView2.navigationName) {
			HStack {
				VStack(alignment: .leading, spacing: 20) {
					Text(ContentView2.navigationName)

					// It's safe to query the `hasAlternativeViewShowing` state from the model, because it will be frozen by the button view.
					// However, to be safe we could also just pass `true` because View2 is not the root view.
					DismissTopContentButton(hasAlternativeViewShowing: navigationModel.hasAlternativeViewShowing)

					Button(action: {
						// Example of a reset transition via move, which is essentially a pop transition.
						navigationModel.hideView(
							ContentView1.navigationName,
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
							ContentView1.navigationName,
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
							ContentView1.navigationName,
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
						navigationModel.pushContent(ContentView2.navigationName) {
							// It's safe to query the `isAlternativeViewShowing` state from the model, because it will be frozen by View3.
							// However, to be sage we could also just pass `true` because View2 is alreaydy showing when transitioning from View2 to View3.
							ContentView3(isView2Showing: navigationModel.isAlternativeViewShowing(ContentView2.navigationName))
						}
					}, label: {
						Text("Push View 3")
					})
						.accessibility(identifier: "PushView3")

					Button(action: {
						navigationModel.presentContent(ContentView2.navigationName) {
							ContentView4(isPresented: navigationModel.viewShowingBinding(ContentView2.navigationName))
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
		}
	}
}

struct ContentView2_Previews: PreviewProvider {
	static var previews: some View {
		ContentView2()
			.environmentObject(NavigationModel())
	}
}
