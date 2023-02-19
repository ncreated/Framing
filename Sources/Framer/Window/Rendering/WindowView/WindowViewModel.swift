import Foundation

internal struct WindowViewModel {
    init(state: WindowState) {
        let visibleBlueprints = state.blueprints
            .compactMap { $0.isVisible ? $0 : nil }
            .map { $0.blueprint }

        self.canvasState = CanvasState(blueprints: state.isShowingBlueprints ? visibleBlueprints : [])
        self.controls = ControlsViewModel(state: state)
    }

    let canvasState: CanvasState
    let controls: ControlsViewModel
}

struct ControlsViewModel: Equatable {
    let mainButton: MainButtonViewModel
    let userActionButtons: [UserActionButtonViewModel]

    /// View model of the main button controlling visibility of different elements in controls view.
    struct MainButtonViewModel: Equatable {
        let text: String
        let isOn: Bool
        let tapAction: WindowAction
    }

    struct UserActionButtonViewModel: Equatable {
        let text: String
        let tapAction: () -> Void

        static func == (lhs: ControlsViewModel.UserActionButtonViewModel, rhs: ControlsViewModel.UserActionButtonViewModel) -> Bool {
            lhs.text == rhs.text
        }
    }

    init(state: WindowState) {
        self.mainButton = .init(
            text: "F",
            isOn: state.isShowingBlueprints,
            tapAction: state.isShowingBlueprints ? .hideBlueprints : .showBlueprints
        )

        if state.isShowingBlueprints {
            self.userActionButtons = state.buttons.map { userAction in
                return .init(
                    text: userAction.title,
                    tapAction: userAction.action
                )
            }
        } else {
            self.userActionButtons = []
        }
    }
}
