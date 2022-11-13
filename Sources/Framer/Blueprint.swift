import Foundation
import UIKit

public struct Blueprint: Equatable {
    public struct ID: ExpressibleByStringLiteral, Hashable, Equatable {
        internal let value: String

        public init(stringLiteral value: String) {
            self.value = value
        }
    }

    public var id: ID
    public var frames: [BlueprintFrame]

    public init(
        id: ID = .init(stringLiteral: UUID().uuidString),
        frames: [BlueprintFrame]
    ) {
        self.id = id
        self.frames = frames
    }
}

public struct BlueprintFrame: Equatable {
    public var x: CGFloat
    public var y: CGFloat
    public var width: CGFloat
    public var height: CGFloat
    public var style: BlueprintFrameStyle
    public var content: BlueprintFrameContent?
    public var annotation: BlueprintFrameAnnotation?

    public init(
        x: CGFloat = 0,
        y: CGFloat = 0,
        width: CGFloat = 0,
        height: CGFloat = 0,
        style: BlueprintFrameStyle = .init(),
        content: BlueprintFrameContent? = nil,
        annotation: BlueprintFrameAnnotation? = nil
    ) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.style = style
        self.content = content
        self.annotation = annotation
    }
}

public struct BlueprintFrameStyle: Equatable {
    public var lineWidth: CGFloat
    public var lineColor: UIColor
    public var fillColor: UIColor
    public var cornerRadius: CGFloat
    public var opacity: CGFloat

    public init(
        lineWidth: CGFloat = 2,
        lineColor: UIColor = .white,
        fillColor: UIColor = .blue,
        cornerRadius: CGFloat = 0,
        opacity: CGFloat = 1
    ) {
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.fillColor = fillColor
        self.cornerRadius = cornerRadius
        self.opacity = opacity
    }
}

public struct BlueprintFrameContent: Equatable {
    public var text: NSString
    public var textColor: UIColor
    public var font: UIFont

    public init(
        text: NSString,
        textColor: UIColor,
        font: UIFont
    ) {
        self.text = text
        self.textColor = textColor
        self.font = font
    }
}

public struct BlueprintFrameAnnotation: Equatable {
    public var text: NSString
    public var size: AnnotationSize
    public var position: AnnotationPosition
    public var alignment: AnnotationAlignment

    public enum AnnotationSize: CGFloat {
        case tiny = 6
        case small = 8
        case normal = 10
        case large = 14
    }

    public enum AnnotationPosition: Equatable {
        case top
        case bottom
        case left
        case right
    }

    public enum AnnotationAlignment: Equatable {
        case leading
        case center
        case trailing
    }

    public init(
        text: NSString,
        size: AnnotationSize = .tiny,
        position: AnnotationPosition = .top,
        alignment: AnnotationAlignment = .leading
    ) {
        self.text = text
        self.size = size
        self.position = position
        self.alignment = alignment
    }
}
