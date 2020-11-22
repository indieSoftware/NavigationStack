import SwiftUI

public extension AnyTransition {
	/**
	 A transition which uses a brighness effect.

	 See also: [SwiftUI doc for brightness](https://developer.apple.com/documentation/swiftui/emptyview/brightness(_:))

	 - parameter amount: A value between 0 (no effect) and 1 (full white brightening) that represents the intensity of the brightness effect.
	 Defaults to 1. Should not be 0.
	 - returns: The constructed transition.
	 */
	static func brightness(_ amount: Double = 1) -> AnyTransition {
		.modifier(active: BrightnessModifier(amount: amount), identity: BrightnessModifier(amount: 0))
	}
}

/**
 The modifier wrapper for the corresponding SwiftUI function.

 See: [SwiftUI doc](https://developer.apple.com/documentation/swiftui/emptyview/brightness(_:))
 */
public struct BrightnessModifier: ViewModifier {
	/// The intensity of the brightness effect.
	public let amount: Double
	public func body(content: Content) -> some View {
		content.brightness(amount)
	}
}
