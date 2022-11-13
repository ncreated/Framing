import Foundation

internal enum Action: Equatable {

    // MARK: - Actions from public APIs

    /// Draws given blueprint (or updates existing one).
    case draw(blueprint: Blueprint)

    /// Removes existing blueprint.
    case erase(blueprintID: Blueprint.ID)

    /// Removes all existing blueprints.
    case eraseAllBlueprints

    /// Adds a button that calls attached closure.
    case add(button: Button)

    // MARK: - Actions from Framer's UI

    /// Toggles visibility of certain blueprint.
    case changeBlueprintVisibility(blueprintID: Blueprint.ID, newVisibility: Bool)

    /// Toggles visibility of Framer's UI by expanding or collapsing details.
    case changeControlsState(show: Bool)

    // MARK: - Types

    struct Button: Equatable {
        /// The title of a button.
        let title: String
        /// The closure to call when button is tapped.
        let action: () -> Void

        static func == (lhs: Button, rhs: Button) -> Bool {
            return lhs.title == rhs.title
        }
    }
}
