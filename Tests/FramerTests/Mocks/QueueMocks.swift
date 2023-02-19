import Foundation
@testable import Framer

internal struct NoQueue: Queue {
    func async(_ block: @escaping () -> Void) {
        block()
    }

    func sync<T>(_ block: () -> T) -> T {
        block()
    }
}
