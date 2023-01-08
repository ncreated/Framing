import Foundation

/// An active window proxy.
///
/// It is used after `FramerWindow.install()` is called and application finished launching.
/// This is the main window proxy powering Framer's capabilities.
@available(iOS 14.0, *)
internal class ActiveWindowController: FramerWindowController {
    /// Synchronization queue.
    private let queue: Queue

    internal let renderer: WindowRenderer
    internal var state: WindowState
    internal let reducer: WindowStateReducer

    /// Initializer.
    /// - Parameters:
    ///   - renderer: renderer displaying Framer's UI
    ///   - inactiveWindow: an `InactiveWindowController` to transfer buffered actions from
    init(
        renderer: WindowRenderer,
        inactiveWindow: InactiveWindowController
    ) {
        self.queue = inactiveWindow.queue
        self.renderer = renderer
        self.state = WindowState()
        self.reducer = WindowStateReducer()

        // Replay any actions received by Framer in `InactiveWindowController` (prior to
        // initialization of `ActiveWindowController`). This is effective if `FramerWindow.install()` needed
        // to await receiving `didBecomeKeyNotification` and user did call some APIs on `InactiveWindowController`.
        inactiveWindow.getBufferedActions { bufferedActions in
            self.receive(nextActions: bufferedActions)
        }

        // Subscribe to actions coming from user interaction with Framer UI:
        renderer.onAction = { nextAction in
            self.receive(nextAction: nextAction)
        }
    }

    // MARK: - FramerWindowController

    func draw(blueprint: Blueprint) {
        queue.run {
            self.receive(nextAction: .draw(blueprint: blueprint))
        }
    }

    func erase(blueprintID: Blueprint.ID) {
        queue.run {
            self.receive(nextAction: .erase(blueprintID: blueprintID))
        }
    }

    func eraseAllBlueprints() {
        queue.run {
            self.receive(nextAction: .eraseAllBlueprints)
        }
    }

    func addButton(title: String, action: @escaping () -> Void) {
        queue.run {
            self.receive(nextAction: .add(button: .init(title: title, action: action)))
        }
    }

    var bounds: CGRect { renderer.bounds }

    // MARK: - Private

    private func receive(nextAction: WindowAction) {
        receive(nextActions: [nextAction])
    }

    private func receive(nextActions: [WindowAction]) {
        state = nextActions.reduce(state, reducer.reduce)
        renderer.render(state: state)
    }
}
