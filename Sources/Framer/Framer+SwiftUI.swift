#if canImport(SwiftUI)
import SwiftUI

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

@available(iOS 13.0, *)
struct FramerItModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.overlay(
            GeometryReader { geometry in
                Color.clear
                    .preference(
                        key: FramePreferenceKey.self,
                        value: geometry.frame(in: .global)
                    )
            }
        )
    }
}

@available(iOS 13.0, *)
public extension View {
    func frameIt(
        _ frameName: String,
        frameStyle: BlueprintFrameStyle = .init(),
        annotationStyle: BlueprintFrameAnnotationStyle = .init()
    ) -> some View {
        return self.modifier(FramerItModifier())
            .onPreferenceChange(FramePreferenceKey.self) { frame in
                FramerWindow.current.draw(
                    blueprint: Blueprint(
                        id: Blueprint.ID(stringLiteral: "\(self)-\(frameName)"),
                        frames: [
                            BlueprintFrame(
                                x: frame.minX,
                                y: frame.minY,
                                width: frame.width,
                                height: frame.height,
                                style: frameStyle,
                                annotation: BlueprintFrameAnnotation(
                                    text: "\(frameName) \(pretty(frame))",
                                    style: annotationStyle
                                )
                            )
                        ]
                    )
                )
            }
    }
}

private func pretty(_ rect: CGRect) -> String {
    return "(x: \(pretty(rect.minX)), y: \(pretty(rect.minY)), w: \(pretty(rect.width)), h: \(pretty(rect.height)))"
}

private func pretty(_ value: CGFloat) -> String {
    if value == value.rounded() {
        return "\(Int(value))"
    }
    return "\(((value * 10).rounded()) / 10)"
}
#endif
