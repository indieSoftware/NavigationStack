import SwiftUI

/// A data struct with information for a transition animation used by the `ContentSwitcher`.
public struct NavigationAnimation {
	/// The Z-Index to use by content which should be shown behind the other.
	public static let zIndexOfBehind = -1.0
	/// The Z-Index to use by content which should be shown in front of the other.
	public static let zIndexOfInFront = 1.0

	/// The animation curve to use when animating a transition.
	public let animation: Animation
	/// The transition to apply to the origin view.
	public let defaultContentTransition: AnyTransition
	/// The transition to apply to the destination view.
	public let alternativeContentTransition: AnyTransition
	/// The Z-index to apply to the origin view during the transition.
	public let defaultContentZIndex: Double
	/// The Z-index to apply to the destination view during the transition.
	public let alternativeContentZIndex: Double

	/**
	 - parameter animation: The animation curve to use when animating a transition.
	 - parameter defaultContentTransition: The transition to apply to the origin view.
	  Defaults to `static` to keep the view visible during the transition.
	 - parameter alternativeContentTransition: The transition to apply to the destination view.
	  Defaults to `static` to keep the view visible during the transition.
	 - parameter defaultContentZIndex: The Z-index to apply to the origin view during the transition.
	  Defaults to -1 to show the default content behind the alternative content during animations.
	 - parameter alternativeContentZIndex: The Z-index to apply to the destination view during the transition.
	  Defaults to 1 to show the alternative content in front of the default content during animations.
	 */
	public init(
		animation: Animation = .default,
		defaultContentTransition: AnyTransition = .static,
		alternativeContentTransition: AnyTransition = .static,
		defaultContentZIndex: Double = zIndexOfBehind,
		alternativeContentZIndex: Double = zIndexOfInFront
	) {
		self.animation = animation
		self.defaultContentTransition = defaultContentTransition
		self.alternativeContentTransition = alternativeContentTransition
		self.defaultContentZIndex = defaultContentZIndex
		self.alternativeContentZIndex = alternativeContentZIndex
	}
}
