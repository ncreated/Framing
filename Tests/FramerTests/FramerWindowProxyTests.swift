import XCTest
@testable import Framer

private class RendererMock: Renderer {
    var renderedStates: [State] = []
    var onRender: ((State) -> Void)? = nil

    func render(state: State) {
        renderedStates.append(state)
        onRender?(state)
    }

    var setActionsReceiverCallCount = 0

    func set(actionsReceiver: ActionsReceiver) {
        setActionsReceiverCallCount += 1
    }

    var bounds: CGRect { .zero }
}

class FramerWindowProxyTests: XCTestCase {
    func testGivenInactiveWindowProxy_whenItIsCalled_itAddsActionsToBuffer() {
        let readActionsExpectation = expectation(description: "Read all buffered actions")
        let blueprint: Blueprint = .mockRandom()
        let buttonTitle: String = .mockRandom()

        // Given
        let proxy = InactiveWindowProxy(queue: RandomQueue())

        // When
        proxy.draw(blueprint: blueprint)
        proxy.erase(blueprintID: blueprint.id)
        proxy.eraseAll()
        proxy.addButton(title: buttonTitle, action: {})

        // Then
        let expectedActions: [Action] = [
            .draw(blueprint: blueprint),
            .erase(blueprintID: blueprint.id),
            .eraseAllBlueprints,
            .add(button: .init(title: buttonTitle, action: {}))
        ]

        proxy.getBufferedActions { actions in
            XCTAssertEqual(actions, expectedActions)
            readActionsExpectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }

    func testGivenActiveWindowProxy_whenItIsCalled_itRendersChangesToWindow() {
        guard #available(iOS 14.0, *) else { return }

        let renderChangesExpectation = expectation(description: "Render all changes")
        renderChangesExpectation.expectedFulfillmentCount = 4 // == number of APIs called

        let blueprint: Blueprint = .mockRandom()
        let buttonTitle: String = .mockRandom()
        let renderer = RendererMock()

        // Given
        let proxy = ActiveWindowProxy(
            renderer: renderer,
            inactiveWindowProxy: InactiveWindowProxy(queue: RandomQueue())
        )

        renderer.onRender = { _ in renderChangesExpectation.fulfill() }

        // When
        proxy.draw(blueprint: blueprint)
        proxy.erase(blueprintID: blueprint.id)
        proxy.eraseAll()
        proxy.addButton(title: buttonTitle, action: {})

        // Then
        waitForExpectations(timeout: 5)
    }

    func testWhenActiveWindowProxyIsInitialized_itFirstReplaysActionsFromInactiveWindowProxy() throws {
//        guard #available(iOS 14.0, *) else { return }
//
//        let renderChangesExpectation = expectation(description: "Render all changes")
//        renderChangesExpectation.expectedFulfillmentCount = 4 // 1 (bulk transfer from inactive proxy) + 3 (APIs called on active proxy)
//
//        let renderer = RendererMock()
//        renderer.onRender = { _ in renderChangesExpectation.fulfill() }
//
//        // Given
//        let inactiveProxy = InactiveWindowProxy(queue: RandomQueue())
//        inactiveProxy.draw(blueprint: .mockRandomWith(id: "1"))
//        inactiveProxy.draw(blueprint: .mockRandomWith(id: "2"))
//        inactiveProxy.draw(blueprint: .mockRandomWith(id: "3"))
//
//        // When
//        let proxy = ActiveWindowProxy(
//            renderer: renderer,
//            inactiveWindowProxy: inactiveProxy
//        )
//
//        proxy.draw(blueprint: .mockRandomWith(id: "4"))
//        proxy.draw(blueprint: .mockRandomWith(id: "5"))
//        proxy.draw(blueprint: .mockRandomWith(id: "6"))
//
//        // Then
//        waitForExpectations(timeout: 5)
//
//        let finalState = try XCTUnwrap(renderer.renderedStates.last)
//        let renderedBlueprintIDs: [Blueprint.ID] = finalState.blueprints.map { $0.blueprint.id }
//        XCTAssertEqual(renderedBlueprintIDs, ["1", "2", "3", "4", "5", "6"])
    }
}
