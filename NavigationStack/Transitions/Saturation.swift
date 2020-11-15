import SwiftUI

public extension AnyTransition {
	/**
	 A transition which uses a brighness effect.

	 See also: [SwiftUI doc for saturation](https://developer.apple.com/documentation/swiftui/emptyview/saturation(_:))

	 - parameter amount: A value between 0 (no saturation = gray) and 1 (full saturation = full color) that represents the amount of saturation to apply.
	 Defaults to 0. Should not be 1.
	 - returns: The constructed transition.
	 */
	static func saturation(_ amount: Double = 0) -> AnyTransition {
		.modifier(active: SaturationModifier(amount: amount), identity: SaturationModifier(amount: 1))
	}
}

/**
 The modifier wrapper for the corresponding SwiftUI function.

 See: [SwiftUI doc](https://developer.apple.com/documentation/swiftui/emptyview/saturation(_:))
 */
public struct SaturationModifier: ViewModifier {
	/// The amount of saturation to apply.
	public let amount: Double
	public func body(content: Content) -> some View {
		content.saturation(amount)
	}
}
