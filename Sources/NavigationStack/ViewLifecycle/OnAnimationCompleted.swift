import SwiftUI

public extension View {
	/**
	 Calls the completion handler whenever an animation on the given value completes.
	 For this the value has to be changed within a `withAnimation` block otherwise the completion block will not be called.

	 - parameter value: The value to observe for animations. Must be a `VectorArithmetic` type, e.g. `Double` or `Float`.
	 - parameter completion: The completion callback to call once the animation completes.
	 - parameter value: The current value when the completion block is called.
	 - returns: A modified `View` instance with the observer attached.
	 */
	func onAnimationCompleted<Value: VectorArithmetic>(for value: Value, completion: @escaping (_ value: Value) -> Void) -> some View {
		modifier(AnimationCompletionObserverModifier(observedValue: value, completion: completion))
	}
}

/**
 An animatable modifier that is used for observing animations for a given animatable value.

 Source: [https://www.avanderlee.com/swiftui/withanimation-completion-callback](https://www.avanderlee.com/swiftui/withanimation-completion-callback)
 */
private struct AnimationCompletionObserverModifier<Value>: AnimatableModifier where Value: VectorArithmetic {
	/// While animating, SwiftUI changes the old input value to the new target value using this property.
	/// This value is set to the old value until the animation completes.
	/// didSet is only called when the data is changed within a `withAnimation` block and then it is called multiple times throughout the animation.
	var animatableData: Value {
		didSet {
			notifyCompletionIfFinished()
		}
	}

	/// The target value for which we're observing.
	/// This value is directly set once the animation starts.
	/// During animation, `animatableData` will hold the oldValue and is only updated to the target value once the animation completes.
	private let targetValue: Value

	/// The completion callback which is called once the animation completes.
	private let completion: (_ value: Value) -> Void

	init(observedValue: Value, completion: @escaping (_ value: Value) -> Void) {
		self.completion = completion
		targetValue = observedValue
		animatableData = observedValue // Doesn't trigger didSet except the value is changed within an animation.
	}

	func body(content: Content) -> some View {
		// We're not really modifying the view so we can directly return the original input value.
		content
	}

	/// Verifies whether the current animation is finished and calls the completion callback if true.
	private func notifyCompletionIfFinished() {
		guard animatableData == targetValue else { return }

		// Dispatching is needed to take the next runloop for the completion callback.
		// This prevents errors like "Modifying state during view update, this will cause undefined behavior."
		DispatchQueue.main.async {
			self.completion(animatableData)
		}
	}
}
