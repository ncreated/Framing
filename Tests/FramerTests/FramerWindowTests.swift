import XCTest
import Framing
@testable import Framer

@available(iOS 14.0, *)
private class RendererProviderMock: RendererProvider {
    let framerView = FramerView(
        frame: .init(x: 0, y: 0, width: 400, height: 800),
        renderingQueue: NoQueue()
    )

    func getRenderer(_ callback: @escaping (Renderer) -> Void) {
        callback(framerView)
    }
}

@available(iOS 14.0, *)
internal class FramerWindowTests: XCTestCase {
    private let recordMode = false
    private let snapshotsFolderName = "_snapshots_"
    private var mock: RendererProviderMock!

    override func setUp() {
        super.setUp()
        mock = RendererProviderMock()
        FramerWindow.rendererProvider = mock
        FramerWindow.install(queue: NoQueue(), callback: nil)
        FramerWindow.current.forceShowControls()
    }

    override func tearDown() {
        FramerWindow.uninstall()
        super.tearDown()
    }

    // MARK: - Blueprints

    private let redFrameStyle = BlueprintFrameStyle(
        lineWidth: 2, lineColor: .red, fillColor: .white, cornerRadius: 10, opacity: 1
    )
    private let greenFrameStyle = BlueprintFrameStyle(
        lineWidth: 2, lineColor: .green, fillColor: .white, cornerRadius: 5, opacity: 0.75
    )
    private let blueFrameStyle = BlueprintFrameStyle(
        lineWidth: 2, lineColor: .blue, fillColor: .white, cornerRadius: 2, opacity: 0.5
    )

    private let redFrameContent = BlueprintFrameContent(
        text: "Frame (red)", textColor: .red, font: .systemFont(ofSize: 30)
    )
    private let greenFrameContent = BlueprintFrameContent(
        text: "Frame (green)", textColor: .green, font: .systemFont(ofSize: 20)
    )
    private let blueFrameContent = BlueprintFrameContent(
        text: "Frame (blue)", textColor: .blue, font: .systemFont(ofSize: 10)
    )

    func testDrawSingleBlueprintWithOneFrame() throws {
        // Given
        let frame = Frame(rect: FramerWindow.current.bounds)
            .inset(top: 40, left: 40, bottom: 40, right: 40)

        var blueprint = Blueprint(
            id: "blueprint 1",
            frames: [
                frame.toBlueprintFrame(
                    withStyle: redFrameStyle,
                    content: redFrameContent
                )
            ]
        )

        // When
        FramerWindow.current.draw(blueprint: blueprint)

        // Then
        try compareWithSnapshot(imageFileSuffix: "-noAnnotations")

        let alignments: [(String, BlueprintFrameAnnotation.AnnotationAlignment)] = [
            ("L", .leading),
            ("C", .center),
            ("T", .trailing),
        ]
        let positions: [(String, BlueprintFrameAnnotation.AnnotationPosition)] = [
            ("T", .top),
            ("B", .bottom),
            ("L", .left),
            ("R", .right),
        ]
        let sizes: [(String, BlueprintFrameAnnotation.AnnotationSize)] = [
            ("T", .tiny),
            ("S", .small),
            ("N", .normal),
            ("L", .large),
        ]

        for alignment in alignments {
            for position in positions {
                for size in sizes {
                    // When
                    blueprint.frames[0].annotation = .init(
                        text: "Annotation (size: \(size.0), position: \(position.0), alignment: \(alignment.0)",
                        size: size.1,
                        position: position.1,
                        alignment: alignment.1
                    )
                    FramerWindow.current.draw(blueprint: blueprint)

                    // Then
                    try compareWithSnapshot(imageFileSuffix: "-annotation\(size.0)\(position.0)\(alignment.0)")
                }
            }
        }
    }

    func testDrawSingleBlueprintWithMultipleFrames() throws {
        let container = Frame(rect: FramerWindow.current.bounds)
            .inset(top: 40, left: 40, bottom: 40, right: 40)

        // Given
        let frame1 = Frame(ofSize: .init(width: 200, height: 200))
            .putInside(container, alignTo: .topLeft)
        let frame2 = Frame(ofSize: .init(width: 200, height: 200))
            .putInside(container, alignTo: .topLeft)
            .offsetBy(x: 50, y: 50)
        let frame3 = Frame(ofSize: .init(width: 200, height: 200))
            .putInside(container, alignTo: .topLeft)
            .offsetBy(x: 100, y: 100)

        // When
        FramerWindow.current.draw(
            blueprint: Blueprint(
                id: "blueprint 1",
                frames: [
                    frame1.toBlueprintFrame(withStyle: redFrameStyle, content: redFrameContent),
                    frame2.toBlueprintFrame(withStyle: greenFrameStyle, content: greenFrameContent),
                    frame3.toBlueprintFrame(withStyle: blueFrameStyle, content: blueFrameContent),
                ]
            )
        )

        // Then
        try compareWithSnapshot()
    }

    func testDrawMultipleBlueprintsAndToggleTheirVisibility() throws {
        let container = Frame(rect: FramerWindow.current.bounds)
            .inset(top: 40, left: 40, bottom: 40, right: 40)

        // Given
        let frame1 = Frame(ofSize: .init(width: 200, height: 200))
            .putInside(container, alignTo: .topLeft)
        let frame2 = Frame(ofSize: .init(width: 200, height: 200))
            .putInside(container, alignTo: .topLeft)
            .offsetBy(x: 50, y: 50)
        let frame3 = Frame(ofSize: .init(width: 200, height: 200))
            .putInside(container, alignTo: .topLeft)
            .offsetBy(x: 100, y: 100)

        // When
        FramerWindow.current.draw(
            blueprint: Blueprint(
                id: "blueprint 1",
                frames: [
                    frame1.toBlueprintFrame(withStyle: redFrameStyle, content: redFrameContent),
                ]
            )
        )

        FramerWindow.current.draw(
            blueprint: Blueprint(
                id: "blueprint 2",
                frames: [
                    frame2.toBlueprintFrame(withStyle: greenFrameStyle, content: greenFrameContent),
                ]
            )
        )

        FramerWindow.current.draw(
            blueprint: Blueprint(
                id: "blueprint 3",
                frames: [
                    frame3.toBlueprintFrame(
                        withStyle: blueFrameStyle,
                        content: blueFrameContent
                    ),
                ]
            )
        )

        // Then
        try compareWithSnapshot(imageFileSuffix: "-showAll")

        // When
        FramerWindow.current.forceChangeBlueprintVisibility(blueprintID: "blueprint 2", newVisibility: false)

        // Then
        try compareWithSnapshot(imageFileSuffix: "-hide2")

        // When
        FramerWindow.current.forceChangeBlueprintVisibility(blueprintID: "blueprint 2", newVisibility: true)
        FramerWindow.current.forceChangeBlueprintVisibility(blueprintID: "blueprint 1", newVisibility: false)

        // Then
        try compareWithSnapshot(imageFileSuffix: "-hide1")
    }

    func testEraseBlueprint() throws {
        let container = Frame(rect: FramerWindow.current.bounds)
            .inset(top: 40, left: 40, bottom: 40, right: 40)

        // Given
        let frame1 = Frame(ofSize: .init(width: 200, height: 200))
            .putInside(container, alignTo: .topLeft)
        let frame2 = Frame(ofSize: .init(width: 200, height: 200))
            .putInside(container, alignTo: .topLeft)
            .offsetBy(x: 50, y: 50)
        let frame3 = Frame(ofSize: .init(width: 200, height: 200))
            .putInside(container, alignTo: .topLeft)
            .offsetBy(x: 100, y: 100)

        FramerWindow.current.draw(
            blueprint: Blueprint(
                id: "blueprint 1",
                frames: [
                    frame1.toBlueprintFrame(withStyle: redFrameStyle, content: redFrameContent),
                ]
            )
        )

        FramerWindow.current.draw(
            blueprint: Blueprint(
                id: "blueprint 2",
                frames: [
                    frame2.toBlueprintFrame(withStyle: greenFrameStyle, content: greenFrameContent),
                ]
            )
        )

        FramerWindow.current.draw(
            blueprint: Blueprint(
                id: "blueprint 3",
                frames: [
                    frame3.toBlueprintFrame(withStyle: blueFrameStyle, content: blueFrameContent),
                ]
            )
        )

        // When
        FramerWindow.current.erase(blueprintID: "blueprint 2")

        // Then
        try compareWithSnapshot(imageFileSuffix: "-erase2")

        // When
        FramerWindow.current.eraseAll()

        // Then
        try compareWithSnapshot(imageFileSuffix: "-eraseAll")
    }

    func testAddButtons() throws {
        // Given
        let frame = Frame(rect: FramerWindow.current.bounds)
            .inset(top: 40, left: 40, bottom: 40, right: 40)

        FramerWindow.current.draw(
            blueprint: Blueprint(
                id: "blueprint 1",
                frames: [
                    frame.toBlueprintFrame(withStyle: redFrameStyle, content: redFrameContent)
                ]
            )
        )

        // When
        FramerWindow.current.addButton(title: "button 1", action: {})
        FramerWindow.current.addButton(title: "button 2", action: {})
        FramerWindow.current.addButton(title: "button 3", action: {})

        // Then
        try compareWithSnapshot()
    }

    // MARK: - Snapshoting

    private func compareWithSnapshot(
        imageFileSuffix: String = "",
        file: StaticString = #filePath,
        function: StaticString = #function,
        line: UInt = #line
    ) throws {
        try compare(
            image: mock.framerView.takeImage(),
            referenceImage: .inFolder(
                named: snapshotsFolderName,
                imageFileSuffix: imageFileSuffix,
                file: file,
                function: function
            ),
            record: recordMode,
            file: file,
            line: line
        )
    }
}

// MARK: - Helpers

private extension FramerWindow {
    static func uninstall() {
        current = NoOpFramerWindowProxy()
    }
}

@available(iOS 14.0, *)
private extension FramerWindowProxy {
    func forceShowControls(file: StaticString = #filePath, line: UInt = #line) {
        guard let activeWindow = self as? ActiveWindowProxy else {
            XCTFail("Expected `ActiveWindowProxy` got \(type(of: self))", file: file, line: line)
            return
        }
        activeWindow.engine.receive(action: .changeControlsState(show: true))
    }

    func forceChangeBlueprintVisibility(
        blueprintID: Blueprint.ID,
        newVisibility: Bool,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard let activeWindow = self as? ActiveWindowProxy else {
            XCTFail("Expected `ActiveWindowProxy` got \(type(of: self))", file: file, line: line)
            return
        }
        activeWindow.engine.receive(action: .changeBlueprintVisibility(blueprintID: blueprintID, newVisibility: newVisibility))
    }
}
