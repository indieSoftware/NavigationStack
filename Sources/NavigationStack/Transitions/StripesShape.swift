import SwiftUI

public extension AnyTransition {
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
 A slicing pattern consisting of multiple rectangle shapes.

 Source inspired by [SwiftUI-Lab](https://swiftui-lab.com/advanced-transitions)
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
