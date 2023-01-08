import Foundation

/// An inactive window proxy.
///
/// It is used after `FramerWindow.install()` is called but before application finishes launching.
/// As soon as `didBecomeKeyNotification` is received it gets replaced by `AciveWindowProxy`.
internal class InactiveWindowController: FramerWindowController {
    /// Synchronization queue.
    /// It is later inherited by `ActiveWindowProxy`.
    internal let queue: Queue
    /// Actions corresponding to API calls.
    private var bufferedActions: [WindowAction] = []

    init(queue: Queue) {
        self.queue = queue
    }

    func getBufferedActions(_ callback: @escaping ([WindowAction]) -> Void) {
        queue.run { callback(self.bufferedActions) }
    }

    // MARK: - FramerWindowController

    func draw(blueprint: Blueprint) {
        queue.run { self.bufferedActions.append(.draw(blueprint: blueprint)) }
    }

    func erase(blueprintID: Blueprint.ID) {
        queue.run { self.bufferedActions.append(.erase(blueprintID: blueprintID)) }
    }

    func eraseAllBlueprints() {
        queue.run { self.bufferedActions.append(.eraseAllBlueprints) }
    }

    func addButton(title: String, action: @escaping () -> Void) {
        queue.run { self.bufferedActions.append(.add(button: .init(title: title, action: action))) }
    }

    var bounds: CGRect { .zero }
}
