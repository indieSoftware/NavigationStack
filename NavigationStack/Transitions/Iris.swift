import SwiftUI

public extension AnyTransition {
	/**
	 A custom transition using a scaling circle to clip the view.
	 */
	static var iris: AnyTransition {
		.modifier(
			active: ClipShapeModifier(shape: ScaledCircle(animatableData: 0)),
			identity: ClipShapeModifier(shape: ScaledCircle(animatableData: 1))
		)
	}
}

struct ClipShapeModifier<T: Shape>: ViewModifier {
	public let shape: T

	public func body(content: Content) -> some View {
		content.clipShape(shape)
	}
}

/// Source by Paul Hudson: [Hacking with Swift]( https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-a-custom-transition )
struct ScaledCircle: Shape {
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
