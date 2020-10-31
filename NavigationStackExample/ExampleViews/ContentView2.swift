import NavigationStack
import SwiftUI

struct ContentView2: View {
	@EnvironmentObject var navigationModel: NavigationModel

	var body: some View {
		NavigationStackView("ContentView2") {
			HStack {
				VStack(alignment: .leading, spacing: 20) {
					Text("Content View 2")

					// It's safe to query the `hasAlternativeContentShowing` state from the model, because it will be frozen by the button view.
					// However, we could also just pass `true` because View2 is not the root view.
					DismissTopContentButton(hasAlternativeContentShowing: navigationModel.hasAlternativeContentShowing)

					Button(action: {
						// Example of a reset transition via move, which is essentially a pop transition.
						navigationModel.resetContent(
							"ContentView1",
							animation: NavigationAnimation(
								animation: .easeOut,
								defaultContentTransition: .move(edge: .leading),
								alternativeContentTransition: .move(edge: .trailing)
							)
						)
					}, label: {
						Text("Pop to View 1")
					})

					Button(action: {
						// Example of a combined reset transition.
						navigationModel.resetContent(
							"ContentView1",
							animation: NavigationAnimation(
								animation: .easeOut,
								defaultContentTransition: AnyTransition.scale(scale: 2).combined(with: .opacity),
								alternativeContentTransition: AnyTransition.scale(scale: 0).combined(with: .opacity)
							)
						)
					}, label: {
						Text("Scale down to View 1")
					})

					Button(action: {
						// Example of a custom reset transition.
						navigationModel.resetContent(
							"ContentView1",
							animation: NavigationAnimation(
								animation: Animation.easeOut.speed(0.25),
								defaultContentTransition: .iris,
								alternativeContentTransition: .iris
							)
						)
					}, label: {
						Text("Double Iris to View 1")
					})

					Button(action: {
						navigationModel.pushContent("ContentView2") {
							// It's safe to query the `isAlternativeContentShowing` state from the model, because it will be frozen by View3.
							// However, we could also just pass `true` because View2 is alreaydy showing when transitioning from View2 to View3.
							ContentView3(isView2Showing: navigationModel.isAlternativeContentShowing("ContentView2"))
						}
					}, label: {
						Text("Push View 3")
					})

					Button(action: {
						navigationModel.presentContent("ContentView2") {
							ContentView4(isPresented: navigationModel.contentShowingBinding("ContentView2"))
						}
					}, label: {
						Text("Present View 4")
					})

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
