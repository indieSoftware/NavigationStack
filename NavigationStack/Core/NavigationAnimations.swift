import SwiftUI

public extension NavigationAnimation {
	/// A transition animation suitable for a typical push animation.
	static let push = NavigationAnimation(
		animation: .easeOut,
		defaultContentTransition: .move(edge: .leading),
		alternativeContentTransition: .move(edge: .trailing)
	)

	/// A transition animation suitable for a typical pop animation.
	static let pop = NavigationAnimation(
		animation: .easeOut,
		defaultContentTransition: .move(edge: .leading),
		alternativeContentTransition: .move(edge: .trailing)
	)

	/// A transition animation suitable for a typical modal present animation.
	static let present = NavigationAnimation(
		animation: .easeOut,
		defaultContentTransition: .static,
		alternativeContentTransition: .move(edge: .bottom)
	)

	/// A transition animation suitable for a typical modal dismiss animation.
	static let dismiss = NavigationAnimation(
		animation: .easeOut,
		defaultContentTransition: .static,
		alternativeContentTransition: .move(edge: .bottom)
	)

	/// A transition animation used to blend the new view into the old view.
	static let fade = NavigationAnimation(
		animation: .easeInOut,
		defaultContentTransition: .static,
		alternativeContentTransition: .opacity
	)
}
