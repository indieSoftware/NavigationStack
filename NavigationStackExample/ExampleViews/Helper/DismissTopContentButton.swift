import NavigationStack
import SwiftUI

struct DismissTopContentButton: View {
	@EnvironmentObject var navigationModel: NavigationModel

	/// Freezes the state of `navigationModel.hasAlternativeViewShowing` to prevent transition animation glitches.
	let hasAlternativeViewShowing: Bool

	var body: some View {
		HStack {
			// Don't use `hasAlternativeViewShowing` from the model to show different sub-views because this will lead to animation glitches!
			if !hasAlternativeViewShowing {
				Text("Not possible: ")
			}
			// Dangerous access to `isAlternativeViewShowing` to show different sub-views, because this might lead to animation glitches.
			// However, here it's fine because the access doesn't happen in the subview itself.
			if navigationModel.isAlternativeViewShowing("Subview") {
				Text("Subview")
					.transition(AnyTransition.move(edge: .leading).combined(with: .opacity))
			}
			Button(action: {
				navigationModel.hideTopViewWithReverseAnimation()
			}, label: {
				Text("Back")
			})
		}
	}
}

struct DismissTopContentButton_Previews: PreviewProvider {
	static var previews: some View {
		DismissTopContentButton(hasAlternativeViewShowing: true)
			.environmentObject(NavigationModel())
	}
}
