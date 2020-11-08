import SwiftUI

public extension AnyTransition {
	/// A transition which doesn't apply any visible changes.
	/// This can be used for one view to remain unchanged while the counter-part view uses a visible transition animation.
	static var `static`: AnyTransition {
		.modifier(
			// The contrast values for active and identity have to differ otherwise SwiftUI ignores this transition completely.
			active: ContrastModifier(contrast: 0.99), // Only a small change which shouldn't be noticable.
			identity: ContrastModifier(contrast: 1.0)
		)
	}
}
