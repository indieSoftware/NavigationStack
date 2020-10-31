import NavigationStack
import SwiftUI

struct DismissTopContentButton: View {
	@EnvironmentObject var navigationModel: NavigationModel

	/// Freezes the state of `navigationModel.hasAlternativeContentShowing` to prevent transition animation glitches.
	let hasAlternativeContentShowing: Bool

	var body: some View {
		HStack {
			// Don't use `hasAlternativeContentShowing` from the model to show different sub-views because this will lead to animation glitches!
			if !hasAlternativeContentShowing {
				Text("Not possible: ")
			}
			// Dangerous access to `isAlternativeContentShowing` to show different sub-views, because this might lead to animation glitches.
			// However, here it's fine because the access doesn't happen in the subview itself.
			if navigationModel.isAlternativeContentShowing("Subview") {
				Text("Subview")
					.transition(AnyTransition.move(edge: .leading).combined(with: .opacity))
			}
			Button(action: {
				navigationModel.resetTopContentWithReverseAnimation()
			}, label: {
				Text("Back")
			})
		}
	}
}

struct DismissTopContentButton_Previews: PreviewProvider {
	static var previews: some View {
		DismissTopContentButton(hasAlternativeContentShowing: true)
			.environmentObject(NavigationModel())
	}
}
