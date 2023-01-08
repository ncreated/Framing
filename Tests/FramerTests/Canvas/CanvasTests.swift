import XCTest
@testable import Framer

class CanvasTests: XCTestCase {
    func testItCanBeModifiedFromDifferentThreads() {
        let canvas = Canvas(size: .init(width: 400, height: 400))
        let ids: [Blueprint.ID] = .mockRandom(count: 10)

        DispatchQueue.concurrentPerform(iterations: 500) { iteration in
            switch iteration % 4 {
            case 0:
                canvas.draw(blueprint: .mockRandomWith(blueprintID: ids.randomElement()!))
            case 1:
                canvas.erase(blueprintID: ids.randomElement()!)
            case 2:
                canvas.eraseAllBlueprints()
            case 3:
                _ = canvas.image
            default:
                break
            }
        }

        _ = canvas
    }
}
