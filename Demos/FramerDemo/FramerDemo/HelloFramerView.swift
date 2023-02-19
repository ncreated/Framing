import SwiftUI
import Framer

struct HelloFramerView: View {
    init() {
        FramerWindow.install()
    }

    var body: some View {
        ZStack {
            Color("FCFFE7")
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                Text("Framer")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(Color("EB455F"))
                    .frameIt("Title")
                Text("What is Framer?")
                    .font(.headline)
                    .frameIt("Headline")
                Text("Framer is a basic canvas for drawing \"blueprints\" on. It can be rendered to standalone image or displayed in overlay window.")
                    .font(.body)
                    .frameIt("Body")
                HStack {
                    Spacer()
                    .frameIt("Spacer")
                    Image(systemName: "photo.artframe")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 40, maxHeight: 40)
                        .foregroundColor(Color("2B3467"))
                }
            }
            .frameIt(
                "VStack",
                 frameStyle: .init(lineColor: .blue),
                 annotationStyle: .init(position: .bottom, alignment: .center)
            )
            .padding(40)
            .fontDesign(.monospaced)
        }
    }
}

struct HelloFramerView_Previews: PreviewProvider {
    static var previews: some View {
        HelloFramerView()
    }
}
