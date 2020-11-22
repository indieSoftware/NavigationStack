import SwiftUI

public extension AnyTransition {
	/**
	 A transition which uses a brighness effect.

	 See also: [SwiftUI doc for huerotation](https://developer.apple.com/documentation/swiftui/emptyview/huerotation(_:))

	 - parameter degree: The hue rotation angle to apply to the colors in this view. 0° means no shift and 180° a total shift.
	 Defaults to 180°. Should not be zero.
	 - returns: The constructed transition.
	 */
	static func hueRotation(_ angle: Angle = .degrees(180)) -> AnyTransition {
		.modifier(active: HueRotationModifier(angle: angle), identity: HueRotationModifier(angle: .zero))
	}
}

/**
 The modifier wrapper for the corresponding SwiftUI function.

 See: [SwiftUI doc](https://developer.apple.com/documentation/swiftui/emptyview/huerotation(_:))
 */
public struct HueRotationModifier: ViewModifier {
	/// The hue rotation angle to apply to the colors in this view.
	public let angle: Angle
	public func body(content: Content) -> some View {
		content.hueRotation(angle)
	}
}
