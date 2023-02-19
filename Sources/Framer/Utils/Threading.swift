import Foundation

internal protocol Queue {
    func async(_ block: @escaping () -> Void)
    func sync<T>(_ block: () -> T) -> T
}

internal struct MainQueue: Queue {
    private let queue = DispatchQueue.main

    func async(_ block: @escaping () -> Void) {
        queue.async { block() }
    }

    func sync<T>(_ block: () -> T) -> T {
        queue.sync { block() }
    }
}

internal struct BackgroundQueue: Queue {
    private let queue: DispatchQueue

    init(named label: String) {
        self.queue = DispatchQueue(label: label, qos: .utility)
    }

    func async(_ block: @escaping () -> Void) {
        queue.async { block() }
    }

    func sync<T>(_ block: () -> T) -> T {
        queue.sync { block() }
    }
}

internal final class RWLock {
    private var lock = pthread_rwlock_t()

    deinit {
        pthread_rwlock_destroy(&lock)
    }

    init() {
        pthread_rwlock_init(&lock, nil)
    }

    func read<T>(block: () -> T) ->T {
        pthread_rwlock_rdlock(&lock)
        defer { pthread_rwlock_unlock(&lock) }
        return block()
    }

    func write<T>(block: () -> T) -> T {
        pthread_rwlock_wrlock(&lock)
        defer { pthread_rwlock_unlock(&lock) }
        return block()
    }
}
