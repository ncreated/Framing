import UIKit

public protocol FramerWindowController: FramerCanvasDrawer {
    /// Adds a button with given `title` which calls provided `action`.
    func addButton(title: String, action: @escaping () -> Void)

    /// Framer window bounds.
    var bounds: CGRect { get }
}

public class FramerWindow {
    /// The current Framer's window.
    public static var current: FramerWindowController = NoOpWindowController()

    @available(iOS 14.0, *)
    internal static var rendererProvider: WindowRendererProvider = WindowProvider()

    /// Installs the Framer window.
    /// After this call `FramerWindow.current` will be activated and ready for interaction.
    ///
    /// `Framer.install()` can be called at any point of the app lifecycle (even before the app finished launching).
    ///
    /// - Parameter callback: an optional callback called when Framer's window gets presented
    public static func install(callback: (() -> Void)? = nil) {
        guard #available(iOS 14.0, *) else {
            assertionFailure("`Framer` can be only used on iOS 14 and later")
            return
        }

        install(
            queue: BackgroundAsyncQueue(named: "com.ncreated.framer.proxy"),
            callback: callback
        )
    }

    @available(iOS 14.0, *)
    internal static func install(queue: Queue, callback: (() -> Void)?) {
        onMainThread {
            assert(FramerWindow.current is NoOpWindowController, "`FramerWindow.install()` should be called only once")

            // First, install `InactiveWindowController`. At this point Framer doesn't yet know
            // if the application was fully launched. In case it was not, if user calls
            // any Framer APIs, their actions will be buffered in `InactiveWindowController` and then
            // replayed to `ActiveWindowController` after `window` is ready.
            let inactiveWindow = InactiveWindowController(queue: queue)
            FramerWindow.current = inactiveWindow

            // Now, get the `renderer` from `rendererProvider`. This call will be
            // synchronous if the app is already started. If it is not, it will await
            // receiving `didBecomeKeyNotification` and execute asynchronously:
            rendererProvider.getRenderer { renderer in
                // Then, instantiate the acutal `ActiveWindowController` and pass it `InactiveWindowController`,
                // so it can replay all actions buffered prior to this moment:
                FramerWindow.current = ActiveWindowController(renderer: renderer, inactiveWindow: inactiveWindow)

                // Last, notify it's ready:
                callback?()
            }
        }
    }
}

private func onMainThread(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async { block() }
    }
}

internal struct NoOpWindowController: FramerWindowController {
    func draw(blueprint: Blueprint) { noop()  }
    func erase(blueprintID: Blueprint.ID) { noop() }
    func eraseAllBlueprints() { noop() }
    func addButton(title: String, action: @escaping () -> Void) { noop() }
    var bounds: CGRect { .zero }

    private func noop() {
        print("Using no-op Framer's window. Make sure `FramerWindow.install()` was called before anything else.")
    }
}
