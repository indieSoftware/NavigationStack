import SwiftUI

/// A data struct with information for a transition animation used by the `NavigationStackView`.
public struct NavigationAnimation {
	/// The Z-Index (`-1`) to use by content which should be shown behind the other.
	public static let zIndexOfBehind = -1.0
	/// The Z-Index (`1`) to use by content which should be shown in front of the other.
	public static let zIndexOfInFront = 1.0

	/**
	 - parameter animation: The animation curve to use when animating a transition.
	 - parameter defaultViewTransition: The transition to apply to the origin view.
	  Defaults to `static` to keep the view visible during the transition.
	 - parameter alternativeViewTransition: The transition to apply to the destination view.
	  Defaults to `static` to keep the view visible during the transition.
	 - parameter defaultViewZIndex: The Z-index to apply to the origin view during the transition.
	  Defaults to -1 to show the default view behind the alternative view during animations.
	 - parameter alternativeViewZIndex: The Z-index to apply to the destination view during the transition.
	  Defaults to 1 to show the alternative view in front of the default view during animations.
	 */
	public init(
		animation: Animation = .default,
		defaultViewTransition: AnyTransition = .static,
		alternativeViewTransition: AnyTransition = .static,
		defaultViewZIndex: Double = zIndexOfBehind,
		alternativeViewZIndex: Double = zIndexOfInFront
	) {
		self.animation = animation
		self.defaultViewTransition = defaultViewTransition
		self.alternativeViewTransition = alternativeViewTransition
		self.defaultViewZIndex = defaultViewZIndex
		self.alternativeViewZIndex = alternativeViewZIndex
	}

	/// The animation curve to use when animating a transition.
	let animation: Animation
	/// The transition to apply to the origin view.
	let defaultViewTransition: AnyTransition
	/// The transition to apply to the destination view.
	let alternativeViewTransition: AnyTransition
	/// The Z-index to apply to the origin view during the transition.
	let defaultViewZIndex: Double
	/// The Z-index to apply to the destination view during the transition.
	let alternativeViewZIndex: Double
}
