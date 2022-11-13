import Foundation

/// The state of Framer's window.
internal struct State: Equatable {
    /// Current state of controls menu.
    var controls: ControlsState = .minimised
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

    /// The state of controls menu.
    enum ControlsState: Equatable {
        case minimised
        case maximised
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
