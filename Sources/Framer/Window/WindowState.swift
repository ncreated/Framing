import Foundation

internal struct WindowState: Equatable {
    var isShowingBlueprints: Bool
    /// Blueprints managed by this window.
    var blueprints: [BlueprintState] = []
    /// Custom actions registered by the user.
    var buttons: [ButtonState] = []

    /// The state of blueprint in window
    struct BlueprintState: Equatable {
        /// The blueprint
        var blueprint: Blueprint
        /// The visibility of this blueprint.
        var isVisible: Bool
    }

    /// Custom button added by the user.
    struct ButtonState: Equatable {
        /// The title of the button.
        var title: String
        /// The action to trigger.
        var action: () -> Void

        static func == (lhs: ButtonState, rhs: ButtonState) -> Bool {
            return lhs.title == rhs.title
        }
    }
}

internal struct WindowStateReducer {
    func reduce(currentState: WindowState, on action: WindowAction) -> WindowState {
        var state = currentState

        switch action {
        case let .draw(blueprint):
            add(blueprint: blueprint, in: &state)
        case let .erase(blueprintID):
            erase(blueprintID: blueprintID, in: &state)
        case .eraseAllBlueprints:
            eraseAllBlueprints(in: &state)
        case let .add(button):
            add(button: button, in: &state)
        case .showBlueprints:
            showBlueprints(in: &state)
        case .hideBlueprints:
            hideBlueprints(in: &state)
        }

        return state
    }

    private func add(blueprint: Blueprint, in state: inout WindowState) {
        if let existingIndex = state.blueprints.firstIndex(where: { $0.blueprint.id == blueprint.id }) {
            var existingBlueprint = state.blueprints[existingIndex]
            existingBlueprint.blueprint = blueprint
            state.blueprints[existingIndex] = existingBlueprint
        } else {
            state.blueprints.append(.init(blueprint: blueprint, isVisible: true))
        }
    }

    private func erase(blueprintID: Blueprint.ID, in state: inout WindowState) {
        state.blueprints.removeAll { $0.blueprint.id == blueprintID }
    }

    private func eraseAllBlueprints(in state: inout WindowState) {
        state.blueprints = []
    }

    private func add(button: WindowAction.Button, in state: inout WindowState) {
        state.buttons.append(
            .init(
                title: button.title,
                action: button.action
            )
        )
    }

    private func showBlueprints(in state: inout WindowState) {
        state.isShowingBlueprints = true
    }

    private func hideBlueprints(in state: inout WindowState) {
        state.isShowingBlueprints = false
    }
}
