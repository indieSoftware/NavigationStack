import SwiftUI

public extension AnyTransition {
	static var `static`: AnyTransition {
		.modifier(
			// The contrast values for active and identity have to differ otherwise SwiftUI ignores this transition completely.
			active: ContrastModifier(contrast: 0.99), // Only a small change which shouldn't be noticable.
			identity: ContrastModifier(contrast: 1.0)
		)
	}
}
