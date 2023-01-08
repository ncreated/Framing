import XCTest
import Framing
@testable import Framer

@available(iOS 14.0, *)
private struct RendererMock: WindowRendererProvider {
    let view: WindowView

    init(size: CGSize) {
        self.view = WindowView(
            frame: .init(origin: .zero, size: size),
            renderingQueue: NoQueue()
        )
    }

    func getRenderer(_ callback: @escaping (WindowRenderer) -> Void) {
        callback(view)
    }
}

@available(iOS 14.0, *)
internal class FramerWindowTests: XCTestCase {
    private let recordMode = false
    private let snapshotsFolderName = "_FramerWindow_Snapshots_"
    private var rendererMock: RendererMock!

    override func setUp() {
        super.setUp()
        rendererMock = RendererMock(size: .init(width: 400, height: 800))
        FramerWindow.rendererProvider = rendererMock
        FramerWindow.install(queue: NoQueue(), callback: nil)
        FramerWindow.current.forceShowControls()
    }

    override func tearDown() {
        FramerWindow.uninstall()
        super.tearDown()
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
                    frame3.toBlueprintFrame(withStyle: blueFrameStyle, content: blueFrameContent),
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
            image: rendererMock.view.takeImage(),
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
        current = NoOpWindowController()
    }
}

@available(iOS 14.0, *)
private extension FramerWindowController {
    func forceShowControls(file: StaticString = #filePath, line: UInt = #line) {
        guard let activeWindow = self as? ActiveWindowController else {
            XCTFail("Expected `ActiveWindowController` got \(type(of: self))", file: file, line: line)
            return
        }
        activeWindow.renderer.onAction?(.changeControlsState(show: true))
    }

    func forceChangeBlueprintVisibility(
        blueprintID: Blueprint.ID,
        newVisibility: Bool,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard let activeWindow = self as? ActiveWindowController else {
            XCTFail("Expected `ActiveWindowController` got \(type(of: self))", file: file, line: line)
            return
        }
        activeWindow.renderer.onAction?(.changeBlueprintVisibility(blueprintID: blueprintID, newVisibility: newVisibility))
    }
}
