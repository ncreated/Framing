import XCTest
@testable import Framer

class ThreadingTests: XCTestCase {
    func testMainAsyncQueueRunsOnMainThread() {
        let expectation = self.expectation(description: "Execute block")

        // Given
        let queue = MainQueue()

        // When
        var asyncRun = false
        queue.async {
            XCTAssertTrue(Thread.isMainThread)
            asyncRun = true
            expectation.fulfill()
        }

        // Then
        XCTAssertEqual(asyncRun, false, "It must run asynchronously")
        waitForExpectations(timeout: 1)
        XCTAssertEqual(asyncRun, true, "It must run asynchronously")
    }

    func testBackgroundAsyncQueueRunsOnBackgorundThread() {
        let expectation = self.expectation(description: "Execute block")

        // Given
        let queue = BackgroundQueue(named: "test")

        // When
        var asyncRun = false
        queue.async {
            XCTAssertFalse(Thread.isMainThread)
            asyncRun = true
            expectation.fulfill()
        }

        // Then
        XCTAssertEqual(asyncRun, false, "It must run asynchronously")
        waitForExpectations(timeout: 1)
        XCTAssertEqual(asyncRun, true, "It must run asynchronously")
    }
}
