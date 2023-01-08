import SwiftUI
import Framer
import Framing

var isFramerInstalled = false

func frameIt() {
    if !isFramerInstalled {
        FramerWindow.install()
        isFramerInstalled = true
    }

    guard let swiftUIHostingView = findSwiftUIHostingView() else {
        return
    }

    var frames = (0..<Int.random(in: (3..<6))).map { idx in
        let inset = CGFloat.random(in: (30..<50))
        let container = Frame(rect: swiftUIHostingView.frame)
            .inset(top: inset, left: inset, bottom: inset, right: inset)
        let size = CGSize(width: Double.random(in: (30..<50)), height: Double.random(in: (30..<50)))

        let alignment: Frame.InsideAlignment = [
            .topLeft,
            .topCenter,
            .topRight,
            .middleLeft,
            .middleCenter,
            .middleRight,
            .bottomLeft,
            .bottomCenter,
            .bottomRight,
        ].randomElement()!

        return Frame(ofSize: size)
            .putInside(container, alignTo: alignment)
    }

    FramerWindow.current.eraseAllBlueprints()

    frames.forEach { frame in
        let rect = "(\(pretty(frame.minX)), \(pretty(frame.minY)), \(pretty(frame.width)), \(pretty(frame.height)))"

        FramerWindow.current.draw(
            blueprint: Blueprint(
                id: .init(stringLiteral: rect),
                frames: [
                    BlueprintFrame(
                        x: frame.minX,
                        y: frame.minY,
                        width: frame.width,
                        height: frame.height,
                        style: BlueprintFrameStyle(
                            lineWidth: 2,
                            lineColor: .black,
                            fillColor: .white,
                            cornerRadius: 3,
                            opacity: 0.25
                        ),
                        annotation: BlueprintFrameAnnotation(
                            text: "\(rect)",
                            size: .normal,
                            position: .bottom,
                            alignment: .trailing
                        )
                    )
                ]
            )
        )
    }
}

private func findSwiftUIHostingView() -> UIView? {
    let sceneWithKeyWindow = UIApplication.shared
        .connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .first { connectedScene in
            connectedScene.windows.contains { windowInConnectedScene in windowInConnectedScene.isKeyWindow }
        }

    guard let appWindow = sceneWithKeyWindow?.keyWindow else {
        return nil
    }

    return findSubview(in: appWindow, matching: { v in
        let className = String(describing: type(of: v))
        return className.hasPrefix("_UIHostingView")
    })
}

private func findSubview(in view: UIView, matching predicate: (UIView) -> Bool) -> UIView? {
    if predicate(view) {
        return view
    } else {
        for subview in view.subviews {
            if let match = findSubview(in: subview, matching: predicate) {
                return match
            }
        }
    }
    return nil
}

private func pretty(_ value: CGFloat) -> String {
    return "\(((value * 10).rounded()) / 10)"
}

private func dfsVisit(view: UIView, calling block: (UIView) -> Void) {
    view.subviews.forEach {
        dfsVisit(view: $0, calling: block)
        block($0)
    }
}
