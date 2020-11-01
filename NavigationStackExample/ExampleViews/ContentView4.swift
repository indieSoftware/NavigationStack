import SwiftUI

/// A typical SwiftUI view with a presentation binding to toggle its visibility.
struct ContentView4: View {
	@Binding var isPresented: Bool

	var body: some View {
		HStack {
			VStack(alignment: .leading, spacing: 20) {
				Text("ContentView4")

				Button(action: {
					withAnimation(.easeOut) {
						isPresented.toggle()
					}
				}, label: {
					Text("Dismiss View 4 w/ animation")
				})

				Button(action: {
					isPresented.toggle()
				}, label: {
					Text("Dismiss View 4 w/o animation")
				})

				Spacer()
			}
			Spacer()
		}
		.padding()
		.background(Color(UIColor.lightGray).opacity(1.0))
	}
}

struct ContentView4_Previews: PreviewProvider {
	static var previews: some View {
		ContentView4(isPresented: .constant(true))
	}
}
