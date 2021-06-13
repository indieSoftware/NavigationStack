import NavigationStack
import SwiftUI

struct OnDidAppearExample: View {
	static let id = String(describing: Self.self)

	@EnvironmentObject private var navigationModel: NavigationModel

	@State private var view2State: ViewState = .none

	var body: some View {
		NavigationStackView(OnDidAppearExample.id) {
			HStack {
				VStack(alignment: .leading, spacing: 20) {
					HStack {
						// General back button.
						Button(action: {
							navigationModel.hideTopViewWithReverseAnimation()
						}, label: {
							Text("Back")
						})
							.accessibility(identifier: "BackButton")
						Text(OnDidAppearExample.id)
					}

					// Button to push view2.
					Button(action: {
						// View2 should be showsn thus it is appearing.
						view2State = .appearing
						navigationModel.showView(
							OnDidAppearExample.id,
							animation: NavigationAnimation(
								animation: .easeInOut(duration: 3),
								defaultViewTransition: .move(edge: .leading),
								alternativeViewTransition: .move(edge: .trailing)
							)
						) {
							OnDidAppearDestinationView(view2State: $view2State)
						}
					}, label: {
						Text("Push Destination View")
					})
						.accessibility(identifier: "PushView2")

					// Displays the current state of view2.
					Text("View2 state: \(String(describing: view2State))")

					Spacer()
				}
				Spacer()
			}
			.padding()
			.background(Color.green)
			.onDidAppear {
				// View1 has appeared which means the other view has disappeared.
				view2State = .none
				print("\(OnDidAppearExample.id) did appear")
			}
		}
	}
}

private struct OnDidAppearDestinationView: View {
	static let id = String(describing: Self.self)

	@EnvironmentObject private var navigationModel: NavigationModel

	@Binding var view2State: ViewState

	var body: some View {
		HStack {
			VStack(alignment: .leading, spacing: 20) {
				Text(OnDidAppearDestinationView.id)

				// Button to go back to view1.
				Button(action: {
					// Pop back which means view2 is about to disappear.
					view2State = .disappearing
					navigationModel.hideView(
						OnDidAppearExample.id,
						animation: NavigationAnimation(
							animation: .easeInOut(duration: 3),
							defaultViewTransition: .move(edge: .leading),
							alternativeViewTransition: .move(edge: .trailing)
						)
					)
				}, label: {
					Text("Pop back")
				})
					.accessibility(identifier: "PopView2")

				// Displays the current state of view2.
				Text("View2 state: \(String(describing: view2State))")

				Spacer()
			}
			Spacer()
		}
		.padding()
		.background(Color.orange)
		.onDidAppear {
			// View2 has appeared and is now present.
			view2State = .present
			print("\(OnDidAppearDestinationView.id) did appear")
		}
	}
}

private enum ViewState {
	case none
	case appearing
	case present
	case disappearing
}

struct OnDidAppearExample_Previews: PreviewProvider {
	static var previews: some View {
		OnDidAppearExample()
			.environmentObject(NavigationModel())
		OnDidAppearDestinationView(view2State: .constant(.none))
			.environmentObject(NavigationModel())
	}
}
