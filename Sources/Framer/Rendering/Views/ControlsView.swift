import UIKit
import Framing

@available(iOS 14.0, *)
internal class ControlsView: UIView {
    /// A type receiving `Action`.
    weak var actionsReceiver: ActionsReceiver?

    private var buttons: [UIButton] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
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
        render(blueprintButtons: viewModel.blueprintButtons)
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
            action: { [weak self] in
                self?.actionsReceiver?.receive(action: mainButton.tapAction)
            }
        )
        buttons.append(button)
    }

    private func render(blueprintButtons: [ControlsViewModel.BlueprintButtonViewModel]) {
        let main = Frame(rect: bounds)
        let stack = Frame(ofSize: .init(width: bounds.width, height: 22))
            .putInside(main, alignTo: .bottomCenter)
            .offsetBy(y: -safeAreaInsets.bottom)
            .inset(left: 20, right: 20 + 22)

        blueprintButtons.enumerated().forEach { index, buttonViewModel in
            let frame = stack.divideIntoEqual(columns: blueprintButtons.count, take: index)
                .inset(top: 0, left: 2, bottom: 0, right: 2)
            let button = createButton(
                title: buttonViewModel.text,
                frame: frame.rect,
                isOn: buttonViewModel.isOn,
                action: { [weak self] in self?.actionsReceiver?.receive(action: buttonViewModel.tapAction) }
            )
            buttons.append(button)
        }
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
