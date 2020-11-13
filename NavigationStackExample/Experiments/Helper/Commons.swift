import SwiftUI

let experimentAnimationSpeedFactor = 0.75
let contentBackgroundOpacity = 1.0

struct DefaultContent: View {
	var body: some View {
		ZStack {
			Color(.green)
				.opacity(contentBackgroundOpacity)
			Text("Default Content (Green)")
		}
	}
}

struct AlternativeContent: View {
	var body: some View {
		ZStack {
			Color(.orange)
				.opacity(contentBackgroundOpacity)
			Text("Alternative Content (Orange)")
		}
	}
}

struct Pickers: View {
	@Binding var animationIndex: Int
	@Binding var transitionIndex: Int
	@Binding var optionIndex: Int

	var body: some View {
		HStack {
			Text("Animation")
			Picker("", selection: self.$animationIndex) {
				Text("Linear").tag(0)
				Text("Spring").tag(1)
			}
			.pickerStyle(SegmentedPickerStyle())
			.accessibility(identifier: "Picker_0")
		}
		.padding(8)

		HStack {
			Text("Transition")
			Picker("", selection: self.$transitionIndex) {
				Text("Move").tag(0)
				Text("Scale").tag(1)
			}
			.pickerStyle(SegmentedPickerStyle())
			.accessibility(identifier: "Picker_1")
		}
		.padding(8)

		HStack {
			if transitionIndex == 0 {
				Text("Tra. Edge")
				Picker("", selection: self.$optionIndex) {
					Text("Horizontal").tag(0)
					Text("Vertical").tag(1)
				}
				.pickerStyle(SegmentedPickerStyle())
				.accessibility(identifier: "Picker_2")
			} else {
				Text("Scaling")
				Picker("", selection: self.$optionIndex) {
					Text("x0").tag(0)
					Text("x2").tag(1)
				}
				.pickerStyle(SegmentedPickerStyle())
				.accessibility(identifier: "Picker_2")
			}
		}
		.padding(8)
	}
}

struct ToggleContentButton: View {
	@Binding var showAlternativeContent: Bool
	let buttonAction: () -> Void

	var body: some View {
		Button(action: buttonAction, label: {
			Text("Toggle content (show \(showAlternativeContent ? "Default" : "Alternative") Content)")
		})
			.accessibility(identifier: "ToggleContentButton")
	}
}
