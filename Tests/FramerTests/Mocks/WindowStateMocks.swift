@testable import Framer

extension WindowState: AnyMockable, RandomMockable {
    static func mockAny() -> WindowState {
        return .mockWith()
    }

    static func mockRandom() -> WindowState {
        return WindowState(
            isShowingBlueprints: .mockRandom(),
            blueprints: .mockRandom(),
            buttons: .mockRandom()
        )
    }

    static func mockWith(
        isShowingBlueprints: Bool = .mockAny(),
        blueprints: [BlueprintState] = .mockAny(),
        buttons: [ButtonState] = .mockAny()
    ) -> WindowState {
        return WindowState(
            isShowingBlueprints: isShowingBlueprints,
            blueprints: blueprints,
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
