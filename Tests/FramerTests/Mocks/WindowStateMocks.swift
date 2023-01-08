@testable import Framer

extension WindowState: AnyMockable, RandomMockable {
    static func mockAny() -> WindowState {
        return .mockWith()
    }

    static func mockRandom() -> WindowState {
        return WindowState(
            blueprints: .mockRandom(),
            controls: .mockRandom(),
            buttons: .mockRandom()
        )
    }

    static func mockWith(
        blueprints: [BlueprintState] = .mockAny(),
        controls: ControlsState = .mockAny(),
        buttons: [ButtonState] = .mockAny()
    ) -> WindowState {
        return WindowState(
            blueprints: blueprints,
            controls: controls,
            buttons: buttons
        )
    }
}

extension WindowState.ButtonState: AnyMockable, RandomMockable {
    static func mockAny() -> WindowState.ButtonState {
        return .mockWith()
    }

    static func mockRandom() -> WindowState.ButtonState {
        return WindowState.ButtonState(
            title: .mockRandom(),
            action: {}
        )
    }

    static func mockWith(
        title: String = .mockAny(),
        action: @escaping () -> Void = {}
    ) -> WindowState.ButtonState {
        return WindowState.ButtonState(
            title: title,
            action: action
        )
    }
}

extension WindowState.ControlsState: AnyMockable, RandomMockable {
    static func mockAny() -> WindowState.ControlsState {
        return .minimised
    }

    static func mockRandom() -> WindowState.ControlsState {
        return [
            .minimised,
            .maximised
        ].randomElement()!
    }
}

extension WindowState.BlueprintState: AnyMockable, RandomMockable {
    static func mockAny() -> WindowState.BlueprintState {
        return .mockWith()
    }

    static func mockRandom() -> WindowState.BlueprintState {
        return WindowState.BlueprintState(
            blueprint: .mockRandom(),
            isVisible: .mockRandom()
        )
    }

    static func mockWith(
        blueprint: Blueprint = .mockAny(),
        isVisible: Bool = .mockAny()
    ) -> WindowState.BlueprintState {
        return WindowState.BlueprintState(
            blueprint: blueprint,
            isVisible: isVisible
        )
    }
}
