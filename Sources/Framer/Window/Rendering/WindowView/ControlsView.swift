import UIKit
import Framing

@available(iOS 14.0, *)
internal class ControlsView: UIView {
    /// A type receiving `Action`.
    private weak var actionsReceiver: WindowRenderer?

    private var buttons: [UIButton] = []

    init(frame: CGRect, actionsReceiver: WindowRenderer) {
        super.init(frame: frame)
        self.actionsReceiver = actionsReceiver
        self.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Rendering

    private var lastRenderedViewModel: ControlsViewModel? = nil

    func render(viewModel: ControlsViewModel) {
        guard viewModel != lastRenderedViewModel else {
            return
        }
        uncheckedRender(viewModel: viewModel)
    }

    override func safeAreaInsetsDidChange() {
        if let viewModel = lastRenderedViewModel {
            uncheckedRender(viewModel: viewModel)
        }
    }

    private func uncheckedRender(viewModel: ControlsViewModel) {
        defer { lastRenderedViewModel = viewModel }

        buttons.forEach { $0.removeFromSuperview() }
        buttons = []

        render(mainButton: viewModel.mainButton)
        render(userActionButtons: viewModel.userActionButtons)

        buttons.forEach { addSubview($0) }
    }

    private func render(mainButton: ControlsViewModel.MainButtonViewModel) {
        let main = Frame(rect: bounds)
            .inset(top: safeAreaInsets.top, left: safeAreaInsets.left, bottom: safeAreaInsets.bottom, right: safeAreaInsets.right)
        let frame = Frame(ofSize: .init(width: 22, height: 22))
            .putInside(main, alignTo: .bottomRight)

        let button = createButton(
            title: mainButton.text,
            frame: frame.rect,
            isOn: mainButton.isOn,
            action: { [weak self] in self?.actionsReceiver?.onAction?(mainButton.tapAction) }
        )
        buttons.append(button)
    }

    private func render(userActionButtons: [ControlsViewModel.UserActionButtonViewModel]) {
        let main = Frame(rect: bounds)
        let stack = Frame(ofSize: .init(width: 60, height: bounds.height))
            .putInside(main, alignTo: .middleRight)
            .offsetBy(y: -(safeAreaInsets.bottom + 22 + 20))

        userActionButtons.enumerated().forEach { index, buttonViewModel in
            let frame = Frame(ofSize: .init(width: 60, height: 22))
                .putInside(stack, alignTo: .bottomCenter)
                .offsetBy(y: -CGFloat(index) * (22.0 + 6.0))
            let button = createButton(
                title: buttonViewModel.text,
                frame: frame.rect,
                isOn: true,
                action: { buttonViewModel.tapAction() }
            )
            buttons.append(button)
        }
    }

    // MARK: - Private

    private func createButton(
        title: String,
        frame: CGRect,
        isOn: Bool,
        action: @escaping () -> Void
    ) -> UIButton {

        let button = UIButton(
            frame: frame,
            primaryAction: .init(handler: { _ in action() })
        )

        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemGray6, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10)
        button.backgroundColor = isOn ? .systemGray : .systemGray3
        button.layer.cornerRadius = 3

        return button
    }

    // MARK: - Capturing Touches

    /// Only capture touches that happen on interactive elements `controlsView`.
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return subviews.contains(where: { subview in
            return subview is UIControl && subview.frame.contains(point)
        })
    }
}
