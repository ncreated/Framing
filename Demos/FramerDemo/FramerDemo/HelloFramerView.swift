import SwiftUI

struct HelloFramerView: View {
    var body: some View {
        ZStack {
            Color("FCFFE7")
                .ignoresSafeArea()

            VStack(spacing: -6) {
                Text("👋")
                    .font(.system(size: 40))
                    .offset(y: -20)
                HStack(spacing: 10) {
                    Image(systemName: "photo.artframe")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 40, maxHeight: 40)
                        .foregroundColor(Color("2B3467"))
                    Text("Hello")
                        .font(.system(size: 30))
                        .fontWeight(.light)
                        .fontDesign(.monospaced)
                        .foregroundColor(Color("2B3467"))
                }
                Text("Framer")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .fontDesign(.monospaced)
                    .foregroundColor(Color("EB455F"))
                Button {
                    frameIt()
                } label: {
                    Text("Frame something!")
                        .fontDesign(.monospaced)
                }
                .offset(y: 20)
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(Color("FCFFE7"))
        }
    }
}

struct HelloFramerView_Previews: PreviewProvider {
    static var previews: some View {
        HelloFramerView()
    }
}
