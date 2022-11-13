import Foundation

internal protocol Queue {
    func run(_ block: @escaping () -> Void)
}

internal struct MainAsyncQueue: Queue {
    func run(_ block: @escaping () -> Void) {
        DispatchQueue.main.async { block() }
    }
}

internal struct BackgroundAsyncQueue: Queue {
    private let queue: DispatchQueue

    init(named label: String) {
        self.queue = DispatchQueue(label: label, qos: .utility)
    }

    func run(_ block: @escaping () -> Void) {
        queue.async { block() }
    }
}
