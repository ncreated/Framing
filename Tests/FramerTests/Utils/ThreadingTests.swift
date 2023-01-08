import XCTest
@testable import Framer

class ThreadingTests: XCTestCase {
    func testMainAsyncQueueRunsOnMainThread() {
        let expectation = self.expectation(description: "Execute block")

        // Given
        let queue = MainAsyncQueue()

        // When
        var asyncRun = false
        queue.run {
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
        let queue = BackgroundAsyncQueue(named: "test")

        // When
        var asyncRun = false
        queue.run {
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
