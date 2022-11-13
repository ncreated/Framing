//
//  ContentView.swift
//  FramerDemo
//
//  Created by Maciek Grzybowski on 31/07/2022.
//

import SwiftUI
import Framing
import Framer

struct ContentView: View {
    @State var uuid: String = UUID().uuidString

    @State var frame1Offset: CGFloat = -100
    @State var frame2Offset: CGFloat = -100

    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Spacer()
            Text("Hello, world! \n\(uuid)")
                .font(.footnote)
                .padding()
            Spacer()
            Button("Randomize text") {
                uuid = UUID().uuidString
            }
            Spacer()
        }
        .onReceive(timer) { _ in
            let main = Frame(rect: FramerWindow.current.bounds)
                .inset(top: 20, left: 20, bottom: 20, right: 20)

            frame1Offset += .random(in: 0...10)
            frame2Offset += .random(in: 0...10)

            if frame1Offset > 100 { frame1Offset = -100 }
            if frame2Offset > 100 { frame2Offset = -100 }

            let frame1 = Frame(ofSize: .init(width: 44, height: 44))
                .putInside(main, alignTo: .middleCenter)
                .offsetBy(x: frame1Offset)

            let frame2 = Frame(ofSize: .init(width: 44, height: 44))
                .putInside(main, alignTo: .middleCenter)
                .offsetBy(x: frame2Offset, y: -24)

            let blueprintA = Blueprint(
                id: "a",
                frames: [
                    frame1.toBlueprintFrame(
                        withStyle: .init(lineWidth: 2, lineColor: .red, fillColor: .systemBlue, cornerRadius: 10)
                    ),
                ]
            )

            let blueprintB = Blueprint(
                id: "b",
                frames: [
                    frame2.toBlueprintFrame(
                        withStyle: .init(lineWidth: 2, lineColor: .blue, fillColor: .systemBlue),
                        content: .init(text: "B123", textColor: .white, font: .systemFont(ofSize: 16)),
                        annotation: .init(text: "B123", size: .tiny)
                    ),
                ]
            )

            let blueprintC = Blueprint(
                id: "c",
                frames: [
                    Frame(x: 40, y: 140, width: 200, height: 60)
                        .toBlueprintFrame(
                            withStyle: .init(lineWidth: 1, lineColor: .yellow, fillColor: .gray, cornerRadius: 10, opacity: 0.5),
                            content: nil,
                            annotation: .init(
                                text: "200x60",
                                size: .small
                            )
                        ),
                    Frame(x: 50, y: 145, width: 190, height: 50)
                        .toBlueprintFrame(
                            withStyle: .init(lineWidth: 1, lineColor: .yellow, fillColor: .gray, cornerRadius: 10, opacity: 0.5),
                            content: nil,
                            annotation: .init(
                                text: "190x50",
                                size: .small,
                                alignment: .center
                            )
                        ),
                    Frame(x: 80, y: 165, width: 40, height: 30)
                        .toBlueprintFrame(
                            withStyle: .init(lineWidth: 1, lineColor: .blue, fillColor: .clear, cornerRadius: 10, opacity: 0.5),
                            content: nil,
                            annotation: .init(
                                text: "transparent",
                                size: .small,
                                alignment: .center
                            )
                        )
                ]
            )

            FramerWindow.current.draw(blueprint: blueprintA)
            FramerWindow.current.draw(blueprint: blueprintB)
            FramerWindow.current.draw(blueprint: blueprintC)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
