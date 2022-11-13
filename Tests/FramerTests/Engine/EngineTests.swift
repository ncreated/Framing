import XCTest
@testable import Framer

private class RendererSpy: Renderer {
    var renderedStates: [State] = []
    var setActionsReceivers: [ActionsReceiver] = []

    func render(state: State) {
        renderedStates.append(state)
    }

    func set(actionsReceiver: ActionsReceiver) {
        setActionsReceivers.append(actionsReceiver)
    }

    var bounds: CGRect { .zero }
}

class EngineTests: XCTestCase {
    func testWhenInitialized_itRegistersItselfAsActionsReceiver() {
        // Given
        let renderer = RendererSpy()

        // When
        let engine = Engine(renderer: renderer)

        // Then
        XCTAssertEqual(renderer.setActionsReceivers.count, 1)
        XCTAssertTrue(renderer.setActionsReceivers[0] === engine)
    }

    func testWhenInitialized_itRendersInitialState() {
        // Given
        let renderer = RendererSpy()

        // When
        _ = Engine(renderer: renderer)

        // Then
        XCTAssertEqual(renderer.renderedStates, [State()])
    }

    func testAfterReceivingAnAction_itRendersNewState() {
        // Given
        let renderer = RendererSpy()
        let engine = Engine(renderer: renderer)

        // When
        (0..<5).forEach { _ in
            engine.receive(action: .draw(blueprint: .mockRandom()))
        }

        // Then
        XCTAssertEqual(renderer.renderedStates.count, 6) // 5 + 1 (initial state)
    }

    func testWhenReceivingActionsInBulk_itRendersStateOnlyOnce() {
        // Given
        let renderer = RendererSpy()
        let engine = Engine(renderer: renderer)

        // When
        engine.receive(actions: (0..<5).map { _ in .draw(blueprint: .mockRandom()) })

        // Then
        XCTAssertEqual(renderer.renderedStates.count, 2) // 1 + 1 (initial state)
    }
}
