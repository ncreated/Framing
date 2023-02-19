import XCTest
@testable import Framer

class InactiveWindowControllerTests: XCTestCase {
    func testGivenInactiveWindow_whenItIsCalled_itAddsActionsToBuffer() {
        let readActionsExpectation = expectation(description: "Read all buffered actions")
        let blueprint: Blueprint = .mockRandom()
        let buttonTitle: String = .mockRandom()

        // Given
        let controller = InactiveWindowController(
            initialState: .mockRandom(),
            queue: NoQueue()
        )

        // When
        controller.draw(blueprint: blueprint)
        controller.erase(blueprintID: blueprint.id)
        controller.eraseAllBlueprints()
        controller.addButton(title: buttonTitle, action: {})

        // Then
        let expectedActions: [WindowAction] = [
            .draw(blueprint: blueprint),
            .erase(blueprintID: blueprint.id),
            .eraseAllBlueprints,
            .add(button: .init(title: buttonTitle, action: {}))
        ]

        controller.getBufferedActions { actions in
            XCTAssertEqual(actions, expectedActions)
            readActionsExpectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }

    func testItHasNoSize() {
        let controller = InactiveWindowController(
            initialState: .mockRandom(),
            queue: NoQueue()
        )
        XCTAssertEqual(controller.bounds, .zero)
    }
}
