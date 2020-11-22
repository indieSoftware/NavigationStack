import SwiftUI

public extension AnyTransition {
	/**
	 A transition which uses a blurring effect.

	 See also: [SwiftUI doc for blur](https://developer.apple.com/documentation/swiftui/emptyview/blur(radius:opaque:))

	 - parameter radius: The radial size of the blur. A blur is more diffuse when its radius is large.
	 Noticable values are greater than 1. Should not be 0.
	 - returns: The constructed transition.
	 */
	static func blur(radius: Double) -> AnyTransition {
		.modifier(active: BlurModifier(radius: radius, opaque: false), identity: BlurModifier(radius: 0, opaque: false))
	}
}

/**
 The modifier wrapper for the corresponding SwiftUI function.

 See: [SwiftUI doc](https://developer.apple.com/documentation/swiftui/emptyview/blur(radius:opaque:))
 */
public struct BlurModifier: ViewModifier {
	/// The radial size of the blur.
	public let radius: Double
	/// A Boolean value that indicates whether the blur renderer permits transparency in the blur output.
	public let opaque: Bool
	public func body(content: Content) -> some View {
		content.blur(radius: (CGFloat)(radius), opaque: opaque)
	}
}
