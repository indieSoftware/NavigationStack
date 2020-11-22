import SwiftUI

public extension AnyTransition {
	/**
	 A transition which doesn't apply any visible changes, but is not the `identity` because using SwiftUI's `identity` leads to results
	 not expected when used in combination with a second transition animation executed simultaniously by the other content view.
	 This should be used for one view to remain unchanged while the counter-part view uses a visible transition animation.
	 */
	static var `static`: AnyTransition {
		.modifier(
			// The contrast values for active and identity have to differ otherwise SwiftUI ignores this transition completely.
			active: ContrastModifier(contrast: 0.99), // Only a small change which shouldn't be noticable.
			identity: ContrastModifier(contrast: 1.0)
		)
	}
}
