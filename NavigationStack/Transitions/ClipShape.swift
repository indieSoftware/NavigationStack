import SwiftUI

public extension AnyTransition {
	/**
	 A custom transition using a scaling circle.
	 */
	static var circleShape: AnyTransition {
		.modifier(
			active: ClipShapeModifier(shape: CircleShape(animatableData: 0), style: FillStyle()),
			identity: ClipShapeModifier(shape: CircleShape(animatableData: 1), style: FillStyle())
		)
	}

	/**
	 A custom transition using a scaling rectangle.
	 */
	static var rectangleShape: AnyTransition {
		AnyTransition.modifier(
			active: ClipShapeModifier(shape: RectangleShape(animatableData: 1), style: FillStyle()),
			identity: ClipShapeModifier(shape: RectangleShape(animatableData: 0), style: FillStyle())
		)
	}

	/**
	 A custom transition using horizontal or vertical stripes to blend over.

	 - parameter stripes: The number of stripes the view should be sliced into.
	 - parameter horizontal: Set to true to lay the stripes out horizontally, false for vertically.
	 */
	static func stripes(stripes: Int, horizontal: Bool, inverted: Bool = false) -> AnyTransition {
		AnyTransition.asymmetric(
			insertion: AnyTransition.modifier(
				active: ClipShapeModifier(
					shape: StripesShape(insertion: true, stripes: stripes, horizontal: horizontal, inverted: inverted, animatableData: 1),
					style: FillStyle()
				),
				identity: ClipShapeModifier(
					shape: StripesShape(insertion: true, stripes: stripes, horizontal: horizontal, inverted: inverted, animatableData: 0),
					style: FillStyle()
				)
			),
			removal: AnyTransition.modifier(
				active: ClipShapeModifier(
					shape: StripesShape(insertion: false, stripes: stripes, horizontal: horizontal, inverted: inverted, animatableData: 1),
					style: FillStyle()
				),
				identity: ClipShapeModifier(
					shape: StripesShape(insertion: false, stripes: stripes, horizontal: horizontal, inverted: inverted, animatableData: 0),
					style: FillStyle()
				)
			)
		)
	}
}

/**
 The modifier wrapper for the corresponding SwiftUI function.

 See: [SwiftUI doc](https://developer.apple.com/documentation/swiftui/emptyview/clipshape(_:style:))
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

/**
 A circle shape which size can be animated.

 Source by [Paul Hudson: Hacking with Swift](https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-a-custom-transition)
 */
public struct CircleShape: Shape {
	public var animatableData: CGFloat

	public func path(in rect: CGRect) -> Path {
		let maximumCircleRadius = sqrt(rect.width * rect.width + rect.height * rect.height)
		let circleRadius = maximumCircleRadius * animatableData

		let posX = rect.midX - circleRadius / 2
		let posY = rect.midY - circleRadius / 2

		let circleRect = CGRect(x: posX, y: posY, width: circleRadius, height: circleRadius)

		return Circle().path(in: circleRect)
	}
}

/**
 A rectangle shape which size can be animated.

 Source by [SwiftUI-Lab](https://swiftui-lab.com/advanced-transitions)
 */
public struct RectangleShape: Shape {
	public var animatableData: CGFloat

	public func path(in rect: CGRect) -> Path {
		var path = Path()

		path.addRect(rect.insetBy(dx: animatableData * rect.width / 2.0, dy: animatableData * rect.height / 2.0))

		return path
	}
}

/**
 A slicing pattern consisting of multiple rectangle shapes.

 Source by [SwiftUI-Lab](https://swiftui-lab.com/advanced-transitions)
 */
public struct StripesShape: Shape {
	/// When true the animation will enlarge the view, when false the animation will shrink the view.
	public let insertion: Bool
	/// The number of stripes to use.
	public let stripes: Int
	/// When true then the stripes will be layed horizontally, otherwise vertically.
	public let horizontal: Bool
	/// When false then the horizontal animation is intended to the bottom, when true then to the top.
	/// When false then the vertical animation is intended to the right, when true then to the left.
	public let inverted: Bool

	public var animatableData: CGFloat

	public func path(in rect: CGRect) -> Path {
		var path = Path()
		let inversionModifier: CGFloat = inverted ? -1.0 : 1.0

		if horizontal {
			let stripeHeight = rect.height / CGFloat(stripes)

			for index in 0 ... stripes {
				let position = CGFloat(index)

				if insertion {
					path.addRect(CGRect(x: 0, y: position * stripeHeight, width: rect.width, height: inversionModifier * stripeHeight * (1 - animatableData)))
				} else {
					path.addRect(CGRect(
						x: 0,
						y: position * stripeHeight + (stripeHeight * animatableData),
						width: rect.width,
						height: inversionModifier * stripeHeight * (1 - animatableData)
					))
				}
			}
		} else {
			let stripeWidth = rect.width / CGFloat(stripes)

			for index in 0 ... stripes {
				let position = CGFloat(index)

				if insertion {
					path.addRect(CGRect(x: position * stripeWidth, y: 0, width: inversionModifier * stripeWidth * (1 - animatableData), height: rect.height))
				} else {
					path.addRect(CGRect(
						x: position * stripeWidth + (stripeWidth * animatableData),
						y: 0,
						width: inversionModifier * stripeWidth * (1 - animatableData),
						height: rect.height
					))
				}
			}
		}

		return path
	}
}
