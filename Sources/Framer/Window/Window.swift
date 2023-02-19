import UIKit

/// Window hosting Framer's renderer.
@available(iOS 14.0, *)
internal class Window: UIWindow {
    private(set) var view: WindowView!

    // MARK: - Initialization

    /// Creates `Window` and automatically associates it with provided scene.
    /// - Parameter windowScene: the scene to associate it with
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        self.windowLevel = .alert + 1
        self.isHidden = false

        self.view = WindowView(frame: bounds)
        self.addSubview(view)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func makeKey() {
        // Empty override, to prevent Framer window becoming the key one
    }

    // MARK: - Capturing Touches

    /// Only capture touches that happen insided `controlsView`.
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return view.controlsView.point(inside: point, with: event)
    }
}
