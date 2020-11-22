// A simple example how to use SwiftUI navigation with Apple's out-of-the-box solutions.
import SwiftUI

struct Experiment0: View {
	@State var isShowingView1 = false
	@State var isShowingView3 = false
	@State var isShowingView3fullscreen = false

	var body: some View {
		NavigationView {
			HStack {
				VStack(alignment: .leading, spacing: 20) {
					NavigationLink(
						destination: AlternativeContentView1(isShowingView1: $isShowingView1),
						isActive: $isShowingView1
					) {
						Text("NavigationLink to View1")
					}

					Button(action: {
						isShowingView3.toggle()
					}, label: {
						Text("Present View 3 as sheet")
					})
						.sheet(isPresented: $isShowingView3) {
							AlternativeContentView3(isShowingView3: $isShowingView3)
						}

					if #available(iOS 14.0, *) {
						Button(action: {
							isShowingView3fullscreen.toggle()
						}, label: {
							Text("Present View 3 fullscreen (iOS 14 only)")
						})
							.fullScreenCover(isPresented: $isShowingView3fullscreen) { // fullscreen only with iOS 14
								AlternativeContentView3(isShowingView3: $isShowingView3fullscreen)
							}
					} else {
						Text("Present View 3 fullscreen (iOS 14 only)")
					}

					Spacer()
				}
				Spacer()
			}
			.padding()
			.navigationBarTitle("Home View")
			.navigationBarHidden(false) // has some glitches with iOS 13
		}
	}
}

struct AlternativeContentView1: View {
	@Binding var isShowingView1: Bool
	@State var isShowingView2 = false

	var body: some View {
		HStack {
			VStack(alignment: .leading, spacing: 20) {
				Text("Alternative Content 1")

				NavigationLink(
					destination: AlternativeContentView2(isShowingView1: $isShowingView1, isShowingView2: $isShowingView2),
					isActive: $isShowingView2
				) {
					Text("NavigationLink to View2")
				}

				Button(action: {
					isShowingView1.toggle()
				}, label: {
					Text("Back to Home")
				})

				Spacer()
			}
			Spacer()
		}
		.padding()
		.navigationBarTitle("Alternative Content 1")
		.navigationBarHidden(true)
	}
}

struct AlternativeContentView2: View {
	@Binding var isShowingView1: Bool // passing states of previous views is awkward
	@Binding var isShowingView2: Bool

	var body: some View {
		HStack {
			VStack(alignment: .leading, spacing: 20) {
				Text("Alternative Content 2")

				Button(action: {
					isShowingView2.toggle()
				}, label: {
					Text("Back to View2")
				})

				Button(action: {
					isShowingView1.toggle()
				}, label: {
					Text("Back to Home")
				})

				Spacer()
			}
			Spacer()
		}
		.padding()
		.navigationBarTitle("Alternative Content 2")
	}
}

struct AlternativeContentView3: View {
	@Binding var isShowingView3: Bool
	@State var isShowingView4 = false

	var body: some View {
		HStack {
			VStack(alignment: .leading, spacing: 20) {
				Text("Alternative Content 3")

				Button(action: {
					isShowingView3.toggle()
				}, label: {
					Text("Dismiss View 3")
				})

				Button(action: {
					isShowingView4.toggle()
				}, label: {
					Text("Present View 4 as sheet")
				})
					.sheet(isPresented: $isShowingView4) {
						AlternativeContentView4(isShowingView3: $isShowingView3, isShowingView4: $isShowingView4)
					}

				Spacer()
			}
			Spacer()
		}
		.padding()
		.navigationBarTitle("Alternative Content 3")
	}
}

struct AlternativeContentView4: View {
	@Binding var isShowingView3: Bool
	@Binding var isShowingView4: Bool

	var body: some View {
		HStack {
			VStack(alignment: .leading, spacing: 20) {
				Text("Alternative Content 4")

				Button(action: {
					isShowingView4.toggle()
				}, label: {
					Text("Dismiss View 4")
				})

				Button(action: {
					isShowingView3.toggle() // doesn't work correctly
				}, label: {
					Text("Dismiss to Home")
				})

				Spacer()
			}
			Spacer()
		}
		.padding()
		.navigationBarTitle("Alternative Content 4")
	}
}
