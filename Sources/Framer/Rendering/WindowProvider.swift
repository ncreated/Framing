import UIKit
import Foundation

internal protocol RendererProvider {
    func getRenderer(_ callback: @escaping (Renderer) -> Void)
}

@available(iOS 14.0, *)
internal class WindowRendererProvider: RendererProvider {
    /// Holds the strong reference to Framer's overlay window.
    private var window: Window?

    /// Provides Framer's window (`UIWindow`).
    ///
    /// Depending if the app finished launching or not, the `callback` will be
    /// called synchronously or asynchronously.
    func getRenderer(_ callback: @escaping (Renderer) -> Void) {
        getSceneWithKeyWindow { scene in
            let window = Window(windowScene: scene)
            callback(window.framerView)
            self.window = window
        }
    }

    /// Finds the `UIWindowScene` that has a key window attached to.
    /// Depending if the app finished launching or not, the `callback` will be
    /// called synchronously or asynchronously.
    private func getSceneWithKeyWindow(_ callback: @escaping (UIWindowScene) -> Void) {
        if let sceneWithKeyWindow = findSceneWithKeyWindow() {
            callback(sceneWithKeyWindow)
        } else {
            let notificationCenter = NotificationCenter.default
            let notification = UIWindow.didBecomeKeyNotification
            var token: Any?
            token = notificationCenter
                .addObserver(forName: notification, object: nil, queue: .main) { [weak self] _ in
                    guard let sceneWithKeyWindow = self?.findSceneWithKeyWindow() else {
                        assertionFailure("Framer failed to find scene with key window after receiving `\(notification)`")
                        return
                    }
                    callback(sceneWithKeyWindow)
                    notificationCenter.removeObserver(token!)
                }
        }
    }

    private func findSceneWithKeyWindow() -> UIWindowScene? {
        let sceneWithKeyWindow = UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { connectedScene in
                connectedScene.windows.contains { windowInConnectedScene in windowInConnectedScene.isKeyWindow }
            }

        guard let sceneWithKeyWindow = sceneWithKeyWindow else {
            return nil // the window is not yet ready
        }

        return sceneWithKeyWindow
    }
}
