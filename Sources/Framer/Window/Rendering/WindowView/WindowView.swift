import UIKit

@available(iOS 14.0, *)
internal class WindowView: UIView, WindowRenderer {
    /// Queue to perform rendering operations.
    private var queue: Queue!
    /// Renders canvas state into image.
    private var canvasRenderer: CanvasRenderer!
    /// Displays canvas image.
    private var canvasView: UIImageView!
    /// A view with Framer's UI controls.
    private(set) var controlsView: ControlsView!

    // MARK: - Initialization

    init(
        frame: CGRect,
        renderingQueue: Queue = MainQueue()
    ) {
        super.init(frame: frame)

        self.queue = renderingQueue
        self.canvasRenderer = CanvasRenderer(size: frame.size)

        self.canvasView = UIImageView(frame: bounds)
        self.addSubview(canvasView)

        self.controlsView = ControlsView(frame: bounds, actionsReceiver: self)
        self.addSubview(controlsView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - WindowRenderer

    func render(state: WindowState) {
        let viewModel = WindowViewModel(state: state)
        queue.async {
            self.render(viewModel: viewModel)
        }
    }

    var onAction: ((WindowAction) -> Void)?

    private func render(viewModel: WindowViewModel) {
        canvasView.image = canvasRenderer.render(state: viewModel.canvasState)
        controlsView.render(viewModel: viewModel.controls)
    }
}
