import Foundation
@testable import Framer

/// Radom queue that is either sync or async.
internal struct RandomQueue: Queue {
    private let isSync: Bool = .mockRandom()
    private let queue = DispatchQueue(label: "com.ncreated.framer.tests")

    func run(_ block: @escaping () -> Void) {
        if isSync {
            queue.sync { block() }
        } else {
            queue.async { block() }
        }
    }
}

internal struct NoQueue: Queue {
    func run(_ block: @escaping () -> Void) {
        block()
    }
}
