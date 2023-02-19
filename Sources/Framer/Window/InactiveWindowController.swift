import Foundation

/// An inactive window proxy.
///
/// It is used after `FramerWindow.install()` is called but before application finishes launching.
/// As soon as `didBecomeKeyNotification` is received it gets replaced by `AciveWindowProxy`.
internal class InactiveWindowController: FramerWindowController {
    /// Synchronization queue.
    /// It is later inherited by `ActiveWindowProxy`.
    internal let queue: Queue
    internal let initialState: WindowState
    /// Actions corresponding to API calls.
    private var bufferedActions: [WindowAction] = []

    init(initialState: WindowState, queue: Queue) {
        self.initialState = initialState
        self.queue = queue
    }

    func getBufferedActions(_ callback: @escaping ([WindowAction]) -> Void) {
        queue.async { callback(self.bufferedActions) }
    }

    // MARK: - FramerWindowController

    func draw(blueprint: Blueprint) {
        queue.async { self.bufferedActions.append(.draw(blueprint: blueprint)) }
    }

    func erase(blueprintID: Blueprint.ID) {
        queue.async { self.bufferedActions.append(.erase(blueprintID: blueprintID)) }
    }

    func eraseAllBlueprints() {
        queue.async { self.bufferedActions.append(.eraseAllBlueprints) }
    }

    func addButton(title: String, action: @escaping () -> Void) {
        queue.async { self.bufferedActions.append(.add(button: .init(title: title, action: action))) }
    }

    func show() {
        queue.async { self.bufferedActions.append(.showBlueprints) }
    }

    func hide() {
        queue.async { self.bufferedActions.append(.hideBlueprints) }
    }

    var isVisible: Bool {
        return false // inactive window doesn't show anything
    }

    var bounds: CGRect { .zero }
}
