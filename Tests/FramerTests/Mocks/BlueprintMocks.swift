import Foundation
import UIKit
@testable import Framer

extension Blueprint: AnyMockable, RandomMockable {
    static func mockAny() -> Blueprint {
        return .mockWith()
    }

    static func mockRandom() -> Blueprint {
        return Blueprint(
            id: .mockRandom(),
            frames: .mockRandom()
        )
    }

    static func mockRandomWith(blueprintID: ID) -> Blueprint {
        var random: Blueprint = .mockRandom()
        random.id = blueprintID
        return random
    }

    static func mockRandomWith(id: String) -> Blueprint {
        return mockRandomWith(blueprintID: .init(stringLiteral: id))
    }

    static func mockWith(
        id: ID = .mockAny(),
        frames: [BlueprintFrame] = .mockAny()
    ) -> Blueprint {
        return Blueprint(
            id: id,
            frames: frames
        )
    }
}

extension Blueprint.ID: AnyMockable, RandomMockable {
    static func mockAny() -> Blueprint.ID {
        return .mockWith()
    }

    static func mockRandom() -> Blueprint.ID {
        return Blueprint.ID(
            stringLiteral: .mockRandom()
        )
    }

    static func mockWith(
        stringLiteral: String = .mockAny()
    ) -> Blueprint.ID {
        return Blueprint.ID(
            stringLiteral: stringLiteral
        )
    }
}

extension BlueprintFrameAnnotation: AnyMockable, RandomMockable {
    static func mockAny() -> BlueprintFrameAnnotation {
        return .mockWith()
    }

    static func mockRandom() -> BlueprintFrameAnnotation {
        return BlueprintFrameAnnotation(
            text: .mockRandom(),
            style: .mockRandom()
        )
    }

    static func mockWith(
        text: String = .mockAny(),
        style: BlueprintFrameAnnotationStyle = .mockAny()
    ) -> BlueprintFrameAnnotation {
        return BlueprintFrameAnnotation(
            text: text,
            style: style
        )
    }
}

extension BlueprintFrameAnnotationStyle: AnyMockable, RandomMockable {
    static func mockAny() -> BlueprintFrameAnnotationStyle {
        return .init()
    }

    static func mockRandom() -> BlueprintFrameAnnotationStyle {
        return .init(
            size: .mockRandom(),
            position: .mockRandom(),
            alignment: .mockRandom()
        )
    }
}

extension BlueprintFrameAnnotationStyle.Alignment: AnyMockable, RandomMockable {
    static func mockAny() -> BlueprintFrameAnnotationStyle.Alignment {
        return .leading
    }

    static func mockRandom() -> BlueprintFrameAnnotationStyle.Alignment {
        return [
            .leading,
            .center,
            .trailing
        ].randomElement()!
    }
}

extension BlueprintFrameAnnotationStyle.Position: AnyMockable, RandomMockable {
    static func mockAny() -> BlueprintFrameAnnotationStyle.Position {
        return .top
    }

    static func mockRandom() -> BlueprintFrameAnnotationStyle.Position {
        return [
            .top,
            .bottom,
            .left,
            .right
        ].randomElement()!
    }
}

extension BlueprintFrameAnnotationStyle.Size: AnyMockable, RandomMockable {
    static func mockAny() -> BlueprintFrameAnnotationStyle.Size {
        return .tiny
    }

    static func mockRandom() -> BlueprintFrameAnnotationStyle.Size {
        return [
            .tiny,
            .small,
            .normal,
            .large
        ].randomElement()!
    }
}

extension BlueprintFrameContent: AnyMockable, RandomMockable {
    static func mockAny() -> BlueprintFrameContent {
        return .mockWith()
    }

    static func mockRandom() -> BlueprintFrameContent {
        return BlueprintFrameContent(
            text: .mockRandom(),
            textColor: .mockRandom(),
            font: .mockRandom()
        )
    }

    static func mockWith(
        text: String = .mockAny(),
        textColor: UIColor = .mockAny(),
        font: UIFont = .mockAny()
    ) -> BlueprintFrameContent {
        return BlueprintFrameContent(
            text: text,
            textColor: textColor,
            font: font
        )
    }
}

extension BlueprintFrameStyle: AnyMockable, RandomMockable {
    static func mockAny() -> BlueprintFrameStyle {
        return .mockWith()
    }

    static func mockRandom() -> BlueprintFrameStyle {
        return BlueprintFrameStyle(
            lineWidth: .mockRandom(),
            lineColor: .mockRandom(),
            fillColor: .mockRandom(),
            cornerRadius: .mockRandom(),
            opacity: .mockRandom()
        )
    }

    static func mockWith(
        lineWidth: CGFloat = .mockAny(),
        lineColor: UIColor = .mockAny(),
        fillColor: UIColor = .mockAny(),
        cornerRadius: CGFloat = .mockAny(),
        opacity: CGFloat = .mockAny()
    ) -> BlueprintFrameStyle {
        return BlueprintFrameStyle(
            lineWidth: lineWidth,
            lineColor: lineColor,
            fillColor: fillColor,
            cornerRadius: cornerRadius,
            opacity: opacity
        )
    }
}

extension BlueprintFrame: AnyMockable, RandomMockable {
    static func mockAny() -> BlueprintFrame {
        return .mockWith()
    }

    static func mockRandom() -> BlueprintFrame {
        return BlueprintFrame(
            x: .mockRandom(),
            y: .mockRandom(),
            width: .mockRandom(),
            height: .mockRandom(),
            style: .mockRandom(),
            content: .mockRandom(),
            annotation: .mockRandom()
        )
    }

    static func mockWith(
        x: CGFloat = .mockAny(),
        y: CGFloat = .mockAny(),
        width: CGFloat = .mockAny(),
        height: CGFloat = .mockAny(),
        style: BlueprintFrameStyle = .mockAny(),
        content: BlueprintFrameContent? = .mockAny(),
        annotation: BlueprintFrameAnnotation? = .mockAny()
    ) -> BlueprintFrame {
        return BlueprintFrame(
            x: x,
            y: y,
            width: width,
            height: height,
            style: style,
            content: content,
            annotation: annotation
        )
    }
}
