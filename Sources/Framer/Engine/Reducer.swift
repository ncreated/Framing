import Foundation
import CloudKit

internal struct Reducer {
    /// Changes current `State` with `Action` and returns new `State`.
    func reduce(currentState: State, on action: Action) throws -> State {
        var state = currentState

        switch action {
        case let .draw(blueprint):
            add(blueprint: blueprint, in: &state)
        case let .erase(blueprintID):
            remove(blueprintID: blueprintID, in: &state)
        case .eraseAllBlueprints:
            removeAllBlueprints(in: &state)
        case let .add(button):
            add(button: button, in: &state)
        case let .changeBlueprintVisibility(blueprintID, newVisibility):
            changeBlueprintVisibility(blueprintID: blueprintID, newVisibility: newVisibility, in: &state)
        case let .changeControlsState(show):
            state.controls = show ? .maximised : .minimised
        }

        return state
    }

    private func add(blueprint: Blueprint, in state: inout State) {
        if let existingIndex = state.blueprints.firstIndex(where: { $0.blueprint.id == blueprint.id }) {
            var existingBlueprint = state.blueprints[existingIndex]
            existingBlueprint.blueprint = blueprint
            state.blueprints[existingIndex] = existingBlueprint
        } else {
            let newBlueprint = State.BlueprintState(
                blueprint: blueprint,
                isVisible: true
            )
            state.blueprints.append(newBlueprint)
        }
    }

    private func remove(blueprintID: Blueprint.ID, in state: inout State) {
        state.blueprints = state.blueprints.filter { $0.blueprint.id != blueprintID }
    }

    private func removeAllBlueprints(in state: inout State) {
        state.blueprints = []
    }

    private func add(button: Action.Button, in state: inout State) {
        state.buttons.append(
            .init(
                title: button.title,
                action: button.action
            )
        )
    }

    private func changeBlueprintVisibility(blueprintID: Blueprint.ID, newVisibility: Bool, in state: inout State) {
        state.blueprints = state.blueprints.map { blueprintState in
            if blueprintState.blueprint.id == blueprintID {
                var blueprintState = blueprintState
                blueprintState.isVisible = newVisibility
                return blueprintState
            }

            return blueprintState
        }
    }
}
