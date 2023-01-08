import UIKit
import Framing

internal struct CanvasRenderer {
    private let renderer: UIGraphicsImageRenderer

    init(size: CGSize) {
        let format = UIGraphicsImageRendererFormat()
        self.renderer = UIGraphicsImageRenderer(size: size, format: format)
    }

    func render(state: CanvasState) -> UIImage {
        return renderer.image { context in
            state.blueprints.forEach { blueprint in
                drawShapeAndContent(for: blueprint, in: context)
                drawAnnotations(for: blueprint, in: context)
            }
        }
    }

    private func drawShapeAndContent(for blueprint: Blueprint, in context: UIGraphicsImageRendererContext) {
        blueprint.frames.forEach { blueprintFrame in
            let rect = rect(from: blueprintFrame)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: blueprintFrame.style.cornerRadius)

            context.cgContext.setAlpha(blueprintFrame.style.opacity)

            // Fill:
            context.cgContext.setFillColor(blueprintFrame.style.fillColor.cgColor)
            context.cgContext.addPath(path.cgPath)
            context.cgContext.fillPath()

            // Stroke:
            context.cgContext.setLineWidth(blueprintFrame.style.lineWidth)
            context.cgContext.setStrokeColor(blueprintFrame.style.lineColor.cgColor)
            context.cgContext.addPath(path.cgPath)
            context.cgContext.strokePath()

            // Content:
            if let content = blueprintFrame.content {
                let textAttributes: [NSAttributedString.Key : Any] = [
                    NSAttributedString.Key.font: content.font,
                    NSAttributedString.Key.foregroundColor: content.textColor
                ]

                content.text.draw(in: rect, withAttributes: textAttributes)
            }
        }
    }

    private func drawAnnotations(for blueprint: Blueprint, in context: UIGraphicsImageRendererContext) {
        // Tracks already drawn annotations in this renderer pass. This is to find eventual collisions
        // and mark colliding annotation with red stroke:
        var drawnAnnotationFrames: [Frame] = []

        blueprint.frames.forEach { blueprintFrame in
            guard let annotation = blueprintFrame.annotation else {
                return
            }

            let annotatedFrame = Frame(rect: rect(from: blueprintFrame))
            let (backgroundColor, foregroundColor) = annotationColors(for: blueprintFrame.style)

            let textAttributes: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: annotation.size.rawValue),
                NSAttributedString.Key.foregroundColor: foregroundColor
            ]

            var annotationFrame = Frame(ofSize: annotation.text.size(withAttributes: textAttributes))
            annotationFrame = adjust(
                position: annotation.position,
                alignment: annotation.alignment,
                of: annotationFrame,
                for: annotatedFrame
            )

            context.cgContext.setFillColor(backgroundColor.cgColor)
            context.cgContext.fill(annotationFrame.rect)

            annotation.text.draw(in: annotationFrame.rect, withAttributes: textAttributes)

            // Mark collisions:
            let collides = drawnAnnotationFrames.contains(where: { $0.rect.intersects(annotationFrame.rect) })

            if collides {
                context.cgContext.setLineWidth(2)
                context.cgContext.setStrokeColor(UIColor.red.cgColor)
                context.cgContext.stroke(annotationFrame.rect)
            }

            drawnAnnotationFrames.append(annotationFrame)
        }
    }

    // MARK: - Helpers

    private func rect(from blueprintFrame: BlueprintFrame) -> CGRect {
        return CGRect(
            x: blueprintFrame.x,
            y: blueprintFrame.y,
            width: blueprintFrame.width,
            height: blueprintFrame.height
        )
    }

    private func annotationColors(for style: BlueprintFrameStyle) -> (background: UIColor, foreground: UIColor) {
        if style.fillColor.alpha > 0.1 {
            return (style.fillColor, style.fillColor.contrast(by: 100))
        } else if style.lineColor.alpha > 0.1 {
            return (style.lineColor, style.lineColor.contrast(by: 100))
        } else {
            return (UIColor.lightGray, UIColor.gray)
        }
    }

    private func adjust(
        position: BlueprintFrameAnnotation.AnnotationPosition,
        alignment: BlueprintFrameAnnotation.AnnotationAlignment,
        of annotationFrame: Frame,
        for annotatedFrame: Frame
    ) -> Frame {
        switch position {
        case .top:
            return annotationFrame.putAbove(annotatedFrame, alignTo: frameHorizontalAlignment(from: alignment))
        case .bottom:
            return annotationFrame.putBelow(annotatedFrame, alignTo: frameHorizontalAlignment(from: alignment))
        case .left:
            return annotationFrame.putOnLeft(of: annotatedFrame, alignTo: frameVerticalAlignment(from: alignment))
        case .right:
            return annotationFrame.putOnRight(of: annotatedFrame, alignTo: frameVerticalAlignment(from: alignment))
        }
    }

    private func frameHorizontalAlignment(from annotationAlignment: BlueprintFrameAnnotation.AnnotationAlignment) -> Frame.HorizontalAlignment {
        switch annotationAlignment {
        case .leading:  return .left
        case .center:   return .center
        case .trailing: return .right
        }
    }

    private func frameVerticalAlignment(from annotationAlignment: BlueprintFrameAnnotation.AnnotationAlignment) -> Frame.VerticalAlignment {
        switch annotationAlignment {
        case .leading:  return .top
        case .center:   return .middle
        case .trailing: return .bottom
        }
    }
}
