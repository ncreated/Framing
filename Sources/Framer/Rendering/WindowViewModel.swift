import Foundation

internal struct WindowViewModel {
    init(state: State) {
        self.blueprints = state.blueprints.compactMap { blueprintState in
            guard blueprintState.isVisible else {
                return nil
            }

            return .init(
                blueprint: blueprintState.blueprint
            )
        }

        self.controls = .init(state: state)
    }

    let blueprints: [BlueprintViewModel]
    let controls: ControlsViewModel
}

struct BlueprintViewModel {
    let blueprint: Blueprint
}

struct ControlsViewModel: Equatable {
    let mainButton: MainButtonViewModel
    let blueprintButtons: [BlueprintButtonViewModel]
    let userActionButtons: [UserActionButtonViewModel]

    /// View model of a button controlling visibility of a single blueprint.
    struct BlueprintButtonViewModel: Equatable {
        let text: String
        let isOn: Bool
        let tapAction: Action
    }

    /// View model of the main button controlling visibility of different elements in controls view.
    struct MainButtonViewModel: Equatable {
        let text: String
        let isOn: Bool
        let tapAction: Action
    }

    struct UserActionButtonViewModel: Equatable {
        let text: String
        let tapAction: () -> Void

        static func == (lhs: ControlsViewModel.UserActionButtonViewModel, rhs: ControlsViewModel.UserActionButtonViewModel) -> Bool {
            lhs.text == rhs.text
        }
    }

    init(state: State) {
        self.mainButton = .init(
            text: {
                switch state.controls {
                case .minimised: return "F"
                case .maximised: return "F"
                }
            }(),
            isOn: {
                switch state.controls {
                case .minimised: return false
                case .maximised: return true
                }
            }(),
            tapAction: {
                switch state.controls {
                case .minimised: return Action.changeControlsState(show: true)
                case .maximised: return Action.changeControlsState(show: false)
                }
            }()
        )

        switch state.controls {
        case .minimised:
            self.blueprintButtons = []
            self.userActionButtons = []
        case .maximised:
            self.blueprintButtons = state.blueprints.map { blueprintState in
                return .init(
                    text: blueprintState.blueprint.id.value,
                    isOn: blueprintState.isVisible,
                    tapAction: .changeBlueprintVisibility(
                        blueprintID: blueprintState.blueprint.id,
                        newVisibility: !blueprintState.isVisible
                    )
                )
            }
            self.userActionButtons = state.buttons.map { userAction in
                return .init(
                    text: userAction.title,
                    tapAction: userAction.action
                )
            }
        }
    }
}
