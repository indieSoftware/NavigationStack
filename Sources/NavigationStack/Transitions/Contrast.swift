import SwiftUI

public extension AnyTransition {
	/**
	 A transition which changes the contrast of a view.

	 See also: [SwiftUI doc for contrast](https://developer.apple.com/documentation/swiftui/emptyview/contrast(_:))

	 - parameter contast: The intensity of color contrast to apply. Negative values invert colors in addition to applying contrast.
	 Ranges from 1 (normal contast) to -1 (inverted contrast), defaults to 0 (no contrast). Should not be 1.
	 - returns: The constructed transition.
	 */
	static func contrast(_ contrast: Double = 0) -> AnyTransition {
		.modifier(active: ContrastModifier(contrast: contrast), identity: ContrastModifier(contrast: 1))
	}
}

/**
 The modifier wrapper for the corresponding SwiftUI function.

 See: [SwiftUI doc](https://developer.apple.com/documentation/swiftui/emptyview/contrast(_:))
 */
public struct ContrastModifier: ViewModifier {
	/// The intensity of color contrast to apply.
	public let contrast: Double
	public func body(content: Content) -> some View {
		content.contrast(contrast)
	}
}
