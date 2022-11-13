@testable import Framer

extension State: AnyMockable, RandomMockable {
    static func mockAny() -> State {
        return .mockWith()
    }

    static func mockRandom() -> State {
        return State(
            controls: .mockRandom(),
            blueprints: .mockRandom(),
            buttons: .mockRandom()
        )
    }

    static func mockWith(
        controls: ControlsState = .mockAny(),
        blueprints: [BlueprintState] = .mockAny(),
        buttons: [ButtonState] = .mockAny()
    ) -> State {
        return State(
            controls: controls,
            blueprints: blueprints,
            buttons: buttons
        )
    }
}

extension State.ButtonState: AnyMockable, RandomMockable {
    static func mockAny() -> State.ButtonState {
        return .mockWith()
    }

    static func mockRandom() -> State.ButtonState {
        return State.ButtonState(
            title: .mockRandom(),
            action: {}
        )
    }

    static func mockWith(
        title: String = .mockAny(),
        action: @escaping () -> Void = {}
    ) -> State.ButtonState {
        return State.ButtonState(
            title: title,
            action: action
        )
    }
}

extension State.ControlsState: AnyMockable, RandomMockable {
    static func mockAny() -> State.ControlsState {
        return .minimised
    }

    static func mockRandom() -> State.ControlsState {
        return [
            .minimised,
            .maximised
        ].randomElement()!
    }
}

extension State.BlueprintState: AnyMockable, RandomMockable {
    static func mockAny() -> State.BlueprintState {
        return .mockWith()
    }

    static func mockRandom() -> State.BlueprintState {
        return State.BlueprintState(
            blueprint: .mockRandom(),
            isVisible: .mockRandom()
        )
    }

    static func mockWith(
        blueprint: Blueprint = .mockAny(),
        isVisible: Bool = .mockAny()
    ) -> State.BlueprintState {
        return State.BlueprintState(
            blueprint: blueprint,
            isVisible: isVisible
        )
    }
}
