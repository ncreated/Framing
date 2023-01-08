import XCTest
@testable import Framer

private class RendererMock: WindowRenderer {
    var renderedStates: [WindowState] = []
    var onRender: ((WindowState) -> Void)? = nil

    func render(state: WindowState) {
        renderedStates.append(state)
        onRender?(state)
    }

    var onAction: ((Framer.WindowAction) -> Void)? = nil
    var bounds: CGRect = .zero
}

class ActiveWindowControllerTests: XCTestCase {
    func testWhenActiveWindowIsInitialized_itFirstReplaysActionsFromInactiveWindowProxy() throws {
        guard #available(iOS 14.0, *) else { return }

        let renderChangesExpectation = expectation(description: "Render all changes")
        renderChangesExpectation.expectedFulfillmentCount = 4 // 1 (bulk transfer from inactive proxy) + 3 (APIs called on active proxy)

        let renderer = RendererMock()
        renderer.onRender = { _ in renderChangesExpectation.fulfill() }

        // Given
        let inactiveWindow = InactiveWindowController(queue: RandomQueue())
        inactiveWindow.draw(blueprint: .mockRandomWith(id: "1"))
        inactiveWindow.draw(blueprint: .mockRandomWith(id: "2"))
        inactiveWindow.draw(blueprint: .mockRandomWith(id: "3"))

        // When
        let controller = ActiveWindowController(
            renderer: renderer,
            inactiveWindow: inactiveWindow
        )

        controller.draw(blueprint: .mockRandomWith(id: "4"))
        controller.draw(blueprint: .mockRandomWith(id: "5"))
        controller.draw(blueprint: .mockRandomWith(id: "6"))

        // Then
        waitForExpectations(timeout: 5)

        let finalState = try XCTUnwrap(renderer.renderedStates.last)
        let renderedBlueprintIDs: [Blueprint.ID] = finalState.blueprints.map { $0.blueprint.id }
        XCTAssertEqual(renderedBlueprintIDs, ["1", "2", "3", "4", "5", "6"])
    }

    func testGivenActiveWindow_whenItIsCalled_itRendersChangesToWindow() {
        guard #available(iOS 14.0, *) else { return }

        let renderChangesExpectation = expectation(description: "Render all changes")
        renderChangesExpectation.expectedFulfillmentCount = 4 // == number of APIs called

        let blueprint: Blueprint = .mockRandom()
        let buttonTitle: String = .mockRandom()
        let renderer = RendererMock()

        // Given
        let controller = ActiveWindowController(
            renderer: renderer,
            inactiveWindow: InactiveWindowController(queue: RandomQueue())
        )

        renderer.onRender = { _ in renderChangesExpectation.fulfill() }

        // When
        controller.draw(blueprint: blueprint)
        controller.erase(blueprintID: blueprint.id)
        controller.eraseAllBlueprints()
        controller.addButton(title: buttonTitle, action: {})

        // Then
        waitForExpectations(timeout: 5)
    }

    func testItHasTheSizeOfRenderer() {
        guard #available(iOS 14.0, *) else { return }

        // Given
        let renderer = RendererMock()
        renderer.bounds = .init(x: .mockRandom(), y: .mockRandom(), width: .mockRandom(), height: .mockRandom())

        // When
        let controller = ActiveWindowController(
            renderer: renderer,
            inactiveWindow: InactiveWindowController(queue: RandomQueue())
        )

        // Then
        XCTAssertEqual(controller.bounds, renderer.bounds)
    }
}
