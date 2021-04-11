// Issue report: https://github.com/indieSoftware/NavigationStack/issues/1

import NavigationStack
import SwiftUI

struct Experiment10: View {
	var body: some View {
		ContentView()
			.environmentObject(NavigationModel())
	}
}

private struct SecondScreen: View {
	@EnvironmentObject var navigationModel: NavigationModel
	var body: some View {
		ZStack {
			Color.blue
			VStack {
				Spacer()
				HStack {
					Spacer()
					VStack {
						Text("Screen 2")
							.foregroundColor(.white)
						Button(action: {
							print("NavStack: \(navigationModel)")
						}, label: {
							Text("Print nav stack")
								.foregroundColor(.white)
						})
					}
					Spacer()
				}
				Spacer()
			}
		}
	}
}

private struct ContentView: View {
	static let id = String(describing: Self.self)
	@EnvironmentObject var navigationModel: NavigationModel

	var body: some View {
		NavigationStackView(ContentView.id) {
			ZStack {
				Color.red
				VStack {
					Spacer()
					HStack {
						Spacer()
						VStack {
							Text("Screen 1")
							Button(action: {
								print("NavStack: \(navigationModel)")
							}, label: {
								Text("Print nav stack")
							})
						}
						Spacer()
					}
					Spacer()
				}
			}.edgesIgnoringSafeArea(.all)
		}
		.onAppear {
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
				print("Push executed")
				self.navigationModel.pushContent(ContentView.id) {
					SecondScreen()
				}
			}
		}
	}
}
