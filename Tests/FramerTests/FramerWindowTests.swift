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
    /// Must be recorded on iPhone 14 Pro Simulator, iOS 16.2.
    private let recordMode = false
    private let snapshotsFolderName = "_FramerWindow_Snapshots_"
    private var rendererMock: RendererMock!

    override func setUp() {
        super.setUp()
        rendererMock = RendererMock(size: .init(width: 400, height: 800))
        FramerWindow.rendererProvider = rendererMock
        FramerWindow.install(startHidden: false, queue: NoQueue(), callback: nil)
    }

    override func tearDown() {
        FramerWindow.uninstall()
        super.tearDown()
    }

    func testDrawMultipleBlueprintsAndToggleFramerVisibility() throws {
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
        try compareWithSnapshot(imageFileSuffix: "-show")

        // When
        FramerWindow.current.hide()

        // Then
        try compareWithSnapshot(imageFileSuffix: "-hide")
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
