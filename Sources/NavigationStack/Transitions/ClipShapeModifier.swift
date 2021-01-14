import SwiftUI

/**
 The modifier wrapper for the corresponding SwiftUI function.

 See: [SwiftUI doc for clipshape](https://developer.apple.com/documentation/swiftui/emptyview/clipshape(_:style:))
 */
public struct ClipShapeModifier<S: Shape>: ViewModifier {
	/// The clipping shape to use for this view. The shape fills the view’s frame, while maintaining its aspect ratio.
	public let shape: S
	/// The fill style to use when rasterizing shape.
	public let style: FillStyle
	public func body(content: Content) -> some View {
		content.clipShape(shape, style: style)
	}
}
