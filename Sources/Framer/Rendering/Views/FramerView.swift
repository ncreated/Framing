import UIKit

@available(iOS 14.0, *)
internal class FramerView: UIView, Renderer {
    /// Queue to perform rendering operations.
    private var queue: Queue!
    /// A view with Framer's UI controls.
    private(set) var controlsView: ControlsView!
    /// Holds `BlueprintViews`.
    private var blueprintsContainer: UIView!

    // MARK: - Initialization

    init(
        frame: CGRect,
        renderingQueue: Queue = MainAsyncQueue()
    ) {
        super.init(frame: frame)

        self.queue = renderingQueue

        self.blueprintsContainer = UIView(frame: bounds)
        self.addSubview(blueprintsContainer)

        self.controlsView = ControlsView(frame: bounds)
        self.addSubview(controlsView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Renderer

    func render(state: State) {
        let viewModel = WindowViewModel(state: state)
        queue.run {
            self.render(viewModel: viewModel)
        }
    }

    func set(actionsReceiver: ActionsReceiver) {
        controlsView.actionsReceiver = actionsReceiver
    }

    private func render(viewModel: WindowViewModel) {
        blueprintsContainer.subviews.forEach { $0.removeFromSuperview() }

        viewModel.blueprints.forEach { blueprintViewModel in
            let blueprintView = BlueprintView(frame: blueprintsContainer.bounds)
            blueprintsContainer.addSubview(blueprintView)
            blueprintView.render(viewModel: blueprintViewModel)
        }

        controlsView.render(viewModel: viewModel.controls)
    }
}
