import SwiftUI

public extension AnyTransition {
	/// A transition which changes the contrast of a view.
	static func contrast(active: Double, identity: Double) -> AnyTransition {
		.modifier(active: ContrastModifier(contrast: active), identity: ContrastModifier(contrast: identity))
	}
}

struct ContrastModifier: ViewModifier {
	public let contrast: Double
	public func body(content: Content) -> some View {
		content.contrast(contrast)
	}
}
