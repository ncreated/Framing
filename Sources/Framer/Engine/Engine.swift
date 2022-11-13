import Foundation

/// A type receiving Framer's actions.
internal protocol ActionsReceiver: AnyObject {
    func receive(action: Action)
    func receive(actions: [Action])
}

extension ActionsReceiver {
    func receive(action: Action) {
        receive(actions: [action])
    }
}

/// A type rendering Framer's window.
internal protocol Renderer: AnyObject {
    /// Updates UI to given state.
    ///
    /// This method is called on background queue, so the implementation must use its appropriate thread.
    func render(state: State)

    /// Registers `ActionsReceiver`.
    /// Any UI actions originating in the renderer should be passed to `actionsReceiver`.
    ///
    /// To avoid retain cycles, the implementation should not capture strong reference to `ActionsReceiver`.
    func set(actionsReceiver: ActionsReceiver)

    /// The `bounds` property of the renderer.
    var bounds: CGRect { get }
}

/// An engine processing actions and invoking renderer.
internal class Engine: ActionsReceiver {
    /// Reduces `State` with `Actions` into new `State`.
    private let reducer = Reducer()
    /// Current `State`.
    private var state = State()
    /// The renderer.
    private weak var renderer: Renderer?

    init(renderer: Renderer) {
        self.renderer = renderer

        // Register `engine` to receive actions originated in Framer's UI:
        renderer.set(actionsReceiver: self)

        // Render initial state
        renderer.render(state: state)
    }

    func receive(actions: [Action]) {
        guard !actions.isEmpty else { return }

        do {
            try actions.forEach { action in
                self.state = try self.reducer.reduce(currentState: self.state, on: action)
            }
            self.renderer?.render(state: self.state)
        } catch let error {
            print("🔥 Framer error: \(error)")
        }
    }
}
