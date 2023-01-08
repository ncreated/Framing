import UIKit

/// The entry point to Framer.
public class FramerWindow {
    /// The current Framer's window.
    public static var current: FramerWindowProxy = NoOpFramerWindowProxy()

    @available(iOS 14.0, *)
    internal static var rendererProvider: RendererProvider = WindowRendererProvider()

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
            assert(FramerWindow.current is NoOpFramerWindowProxy, "`FramerWindow.install()` should be called only once")

            // First, install `InactiveWindowProxy`. At this point Framer doesn't yet know
            // if the application was fully launched. In case it was not, if user calls
            // any Framer APIs, their actions will be buffered in `InactiveWindowProxy` and then
            // replayed to `ActiveWindowProxy` after `window` is ready.
            let inactiveWindow = InactiveWindowProxy(queue: queue)
            FramerWindow.current = inactiveWindow

            // Now, get the `renderer` from `rendererProvider`. This call will be
            // synchronous if the app is already started. If it is not, it will await
            // receiving `didBecomeKeyNotification` and execute asynchronously:
            rendererProvider.getRenderer { renderer in
                // Then, instantiate the acutal `ActiveWindowProxy` and pass it `InactiveWindowProxy`,
                // so it can replay all actions buffered prior to this moment:
                FramerWindow.current = ActiveWindowProxy(
                    renderer: renderer,
                    inactiveWindowProxy: inactiveWindow
                )

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
