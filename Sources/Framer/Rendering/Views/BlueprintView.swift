import UIKit
import Framing

internal class BlueprintView: UIView {
    /// The main image view rendering the blueprint.
    /// It has the size of the entire `BlueprintView`, which is the size of window.
    private let mainView: UIImageView
    /// An accessory image view rendering blueprint annotations.
    /// It has the size of the entire `BlueprintView`, which is the size of window.
    private let annotationsView: UIImageView
    /// Renders blueprints into image displayed in `imageView`.
    private let renderer: UIGraphicsImageRenderer

    override init(frame: CGRect) {
        let format = UIGraphicsImageRendererFormat()
        self.renderer = UIGraphicsImageRenderer(size: frame.size, format: format)
        self.mainView = UIImageView(frame: frame)
        self.annotationsView = UIImageView(frame: frame)

        super.init(frame: frame)

        self.backgroundColor = .clear
        self.isUserInteractionEnabled = false
        addSubview(self.mainView)
        addSubview(self.annotationsView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Rendering

    func render(viewModel: BlueprintViewModel) {
        mainView.image = renderer.image { context in
            viewModel.blueprint.frames.forEach { blueprintFrame in
                let rect = rect(from: blueprintFrame)
                let path = UIBezierPath(roundedRect: rect, cornerRadius: blueprintFrame.style.cornerRadius)

                context.cgContext.setAlpha(blueprintFrame.style.opacity)

                context.cgContext.setFillColor(blueprintFrame.style.fillColor.cgColor)
                context.cgContext.addPath(path.cgPath)
                context.cgContext.fillPath()

                context.cgContext.setLineWidth(blueprintFrame.style.lineWidth)
                context.cgContext.setStrokeColor(blueprintFrame.style.lineColor.cgColor)
                context.cgContext.addPath(path.cgPath)
                context.cgContext.strokePath()

                if let content = blueprintFrame.content {
                    let textAttributes: [NSAttributedString.Key : Any] = [
                        NSAttributedString.Key.font: content.font,
                        NSAttributedString.Key.foregroundColor: content.textColor
                    ]

                    content.text.draw(in: rect, withAttributes: textAttributes)
                }
            }
        }

        // Tracks already drawn annotations in this renderer pass. This is to find eventual collisions
        // and mark colliding annotation with red stroke:
        var drawnAnnotationFrames: [Frame] = []

        annotationsView.image = renderer.image { context in
            viewModel.blueprint.frames.forEach { blueprintFrame in
                if let annotation = blueprintFrame.annotation {
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
        }
    }

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

    // MARK: - Positioning annotation accordingly to annotated view

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
