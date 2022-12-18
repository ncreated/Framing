import UIKit

/// Framer's window proxy - the public interface of Framer.
public protocol FramerWindowProxy {
    /// Draws given `blueprint`:
    /// - if `blueprint.id` is already drawn, it will be updated.
    /// - otherwise, it a new blueprint will be created.
    func draw(blueprint: Blueprint)

    /// Erases blueprint with given `Blueprint.ID` in current window.
    func erase(blueprintID: Blueprint.ID)

    /// Erases all blueprints in current window.
    func eraseAll()

    /// Adds a button with given `title` which calls provided `action`.
    func addButton(title: String, action: @escaping () -> Void)

    /// Framer window bounds.
    var bounds: CGRect { get }
}

/// No-op window proxy.
///
/// It is used until `FramerWindow.install()` is called.
internal struct NoOpFramerWindowProxy: FramerWindowProxy {
    func draw(blueprint: Blueprint) { reportNoOp()  }
    func erase(blueprintID: Blueprint.ID) { reportNoOp() }
    func eraseAll() { reportNoOp() }
    func addButton(title: String, action: @escaping () -> Void) { reportNoOp() }
    var bounds: CGRect { .zero }

    private func reportNoOp() {
        print("Using no-op Framer's window. Make sure `FramerWindow.install()` was called before anything else.")
    }
}

/// An inactive window proxy.
///
/// It is used after `FramerWindow.install()` is called but before application finishes launching.
/// As soon as `didBecomeKeyNotification` is received it gets replaced by `AciveWindowProxy`.
internal class InactiveWindowProxy: FramerWindowProxy {
    /// Synchronization queue.
    /// It is later inherited by `ActiveWindowProxy`.
    internal let queue: Queue
    /// Actions corresponding to API calls.
    private var bufferedActions: [Action] = []

    init(queue: Queue) {
        self.queue = queue
    }

    func getBufferedActions(_ callback: @escaping ([Action]) -> Void) {
        queue.run { callback(self.bufferedActions) }
    }

    // MARK: - FramerWindowProxy

    func draw(blueprint: Blueprint) {
        queue.run { self.bufferedActions.append(.draw(blueprint: blueprint)) }
    }

    func erase(blueprintID: Blueprint.ID) {
        queue.run { self.bufferedActions.append(.erase(blueprintID: blueprintID)) }
    }

    func eraseAll() {
        queue.run { self.bufferedActions.append(.eraseAllBlueprints) }
    }

    func addButton(title: String, action: @escaping () -> Void) {
        queue.run { self.bufferedActions.append(.add(button: .init(title: title, action: action))) }
    }

    var bounds: CGRect { .zero }
}

/// An active window proxy.
///
/// It is used after `FramerWindow.install()` is called and application finished launching.
/// This is the main window proxy powering Framer's capabilities.
@available(iOS 14.0, *)
internal class ActiveWindowProxy: FramerWindowProxy {
    /// Synchronization queue.
    private let queue: Queue
    /// Renderer displaying Framer's UI Framer's UI.
    internal let renderer: Renderer
    /// An engine processing user actions and invoking renderer (the `window`).
    internal let engine: Engine

    /// Initializer.
    /// - Parameters:
    ///   - renderer: renderer displaying Framer's UI
    ///   - inactiveWindowProxy: an `InactiveWindowProxy` to transfer buffered actions from
    init(
        renderer: Renderer,
        inactiveWindowProxy: InactiveWindowProxy
    ) {
        self.queue = inactiveWindowProxy.queue
        self.renderer = renderer
        self.engine = Engine(renderer: renderer)

        // Replay any actions received by Framer in `InactiveWindowProxy` (prior to
        // initialization of `ActiveWindowProxy`). This is effective if `FramerWindow.install()` needed
        // to await receiving `didBecomeKeyNotification` and user did call some APIs on `InactiveWindowProxy`.
        inactiveWindowProxy.getBufferedActions { bufferedActions in
            self.engine.receive(actions: bufferedActions)
        }
    }

    // MARK: - FramerWindowProxy

    func draw(blueprint: Blueprint) {
        queue.run {
            self.engine.receive(action: .draw(blueprint: blueprint))
        }
    }

    func erase(blueprintID: Blueprint.ID) {
        queue.run {
            self.engine.receive(action: .erase(blueprintID: blueprintID))
        }
    }

    func eraseAll() {
        queue.run {
            self.engine.receive(action: .eraseAllBlueprints)
        }
    }

    func addButton(title: String, action: @escaping () -> Void) {
        queue.run {
            self.engine.receive(action: .add(button: .init(title: title, action: action)))
        }
    }

    var bounds: CGRect { renderer.bounds }
}
