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
    }

    override func tearDown() {
        FramerWindow.uninstall()
        super.tearDown()
    }

    // MARK: - Blueprints

    func testSingleBlueprint() throws {
        // Given
        let frame = Frame(rect: FramerWindow.current.bounds)
            .inset(top: 40, left: 40, bottom: 40, right: 40)

        // When
        FramerWindow.current.draw(
            blueprint: Blueprint(
                id: "1",
                frames: [
                    frame.toBlueprintFrame(
                        withStyle: .init(lineWidth: 2, lineColor: .red, fillColor: .white, cornerRadius: 10, opacity: 1),
                        content: .init(text: "Frame", textColor: .red, font: .systemFont(ofSize: 20)),
                        annotation: .init(text: "Frame annotation", size: .normal, position: .top, alignment: .center)
                    )
                ]
            )
        )

        // Then
        try compare(
            image: mock.framerView.takeImage(),
            referenceImage: .inFolder(named: snapshotsFolderName),
            record: recordMode
        )
    }

    func testMultipleBlueprints() throws {
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
                id: "1",
                frames: [
                    frame1.toBlueprintFrame(
                        withStyle: .init(lineWidth: 6, lineColor: .red, fillColor: .white, cornerRadius: 3, opacity: 0.5),
                        content: .init(text: "Frame 1", textColor: .red, font: .systemFont(ofSize: 30)),
                        annotation: .init(text: "Frame 1 Annotation", size: .normal, position: .top, alignment: .center)
                    ),
                    frame2.toBlueprintFrame(
                        withStyle: .init(lineWidth: 4, lineColor: .green, fillColor: .white, cornerRadius: 2, opacity: 0.5),
                        content: .init(text: "Frame 2", textColor: .green, font: .systemFont(ofSize: 20)),
                        annotation: .init(text: "Frame 2 Annotation", size: .normal, position: .top, alignment: .center)
                    ),
                    frame3.toBlueprintFrame(
                        withStyle: .init(lineWidth: 2, lineColor: .blue, fillColor: .white, cornerRadius: 1, opacity: 0.5),
                        content: .init(text: "Frame 3", textColor: .blue, font: .systemFont(ofSize: 10)),
                        annotation: .init(text: "Frame 3 Annotation", size: .normal, position: .top, alignment: .center)
                    ),
                ]
            )
        )

        // Then
        try compare(
            image: mock.framerView.takeImage(),
            referenceImage: .inFolder(named: snapshotsFolderName),
            record: recordMode
        )
    }
}

extension FramerWindow {
    static func uninstall() {
        current = NoOpFramerWindowProxy()
    }
}
